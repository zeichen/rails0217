class GroupsController < ApplicationController
	before_action :authenticate_user!  

	def index
		
		@groups=Group.all
	end 
	def new 
		@group= Group.new
	end
	def create 
		@group= Group.create(group_params)
		if @group.save
			current_user.join!(@group)
			redirect_to groups_path
		else
			render :new
		end
	
	end
	def show
		@group = Group.find(params[:id])
		@posts = @group.posts
	end
	def edit 
		@group = Group.find(params[:id])
	end
	def update 
		@group = Group.find(params[:id])
		if(@group.update(group_params))
			redirect_to groups_path, notice:"修改成功"
		else
			render :edit
		end
	end

	def destory 
		@group = Group.find(params[:id])
		@group.destroy 
		redirect_to groups_path, alert:"討論版已刪除"
	end
	
	def join 
	@group =Group.find(params[:id]) 

	if !current_user.is_member_of?(@group)
		current_user.join!(@group)
		 flash[:notice] = "加入本討論版成功！"
		else
			 flash[:warning] = "你已經是本討論版成員了！"
			end
			redirect_to groups_path(@group)
		end

	def quit 
	@group =Group.find(params[:id]) 

	if current_user.is_member_of?(@group)
		current_user.quit!(@group)
		  flash[:alert] = "已退出本討論版！"
		else
			 flash[:warning] = "你不是本討論版成員，怎麼退出 XD"
			end
			redirect_to groups_path(@group)
		end



	private

def group_params
	params.require(:group).permit(:title, :description)
end

end


