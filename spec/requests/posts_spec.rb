require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "/posts/new" do
    it "succeeds" do
      get new_post_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "/posts/create" do
    def create_post(title, body)
      post posts_path, params: {
        post: {
          title: title,
          body: body
        }
      }
    end

    context "valid params" do
      it "successfully creates a post" do
        expect do
          create_post("ex title", "ex body")
        end.to change { Post.count }.from(0).to(1)
        expect(response).to have_http_status(:redirect)
      end
    end

    context "invalid params" do
      it "fails at creating the post" do
        expect do
          create_post("", "")
        end.not_to change {Post.count}

        expect(Post.count).to eq(0)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "/posts/:id for show" do
    let(:post) {create(:post)}

    context "when passing in valid post id" do
      it "successeds" do
        get post_path(post)
        expect(response).to have_http_status(:success)
      end
    end

    context "when passing in invalid post id" do
      it "fails" do
        expect { get post_path("qwer")}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "edit post" do
    let(:post) { create(:post) }

    it "succeeds" do
      get edit_post_path(post)
      expect(response).to have_http_status(:success)
    end
  end

  describe "update post" do
    let(:post) { create(:post) }

    context "when it is valid update" do
      it "updates" do
        old_title = post.title
        new_title = "new title"

        expect do
          put post_path(post), params: {
            post: {
              title: new_title
            }
          }
        end.to change { post.reload.title }.from(old_title).to(new_title)
        expect(response).to have_http_status(:redirect)
      end
    end

    context "when it is invalid update" do
      it "fails to update" do
        expect do
        put post_path(post), params: {
          post: {
            title: ""
          }
        }
        end.not_to change { post.reload.title }
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "delete post" do
    let(:post) { create(:post) }

    it "successfully deletes the post" do
      # expect do
      #   delete post_path(post)
      # end.to change { Post.count }.from(1).to(0)

      # delete post_path(post)
      # expect { Post.find(post.id) }.to raise_error(ActiveRecord::RecordNotFound)

      # expect { post.save }.to change{ Post.all.size }.by(1)
      
      post.save
      expect do
        delete post_path(post)
      end.to change { Post.count }.from(1).to(0)

      expect(response).to have_http_status(:redirect)
    end
  end
end
