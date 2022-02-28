class MessagesController < ApplicationController
  def create
    @chatroom = Chatroom.find(params[:chatroom_id])
    @message = Message.new(message_params)
    @message.user = current_user
    @message.chatroom = @chatroom

    if @message.save
      redirect_to chatroom_path(@chatroom, anchor: "message-#{@message.id}")
      ChatroomChannel.broadcast_to(
          @chatroom, render_to_string(partial: "message", locals: {message: @message})
        )
      head :ok
    else
      render 'chatroom/show'
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
