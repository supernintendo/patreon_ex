defmodule PatreonEx do
  alias PatreonEx.Impl.Wrapper

  @moduledoc """
  This module contains functions that access the Patreon API V2 endpoints and
  functions that generate OAuth URLs and authenticate responses.
  """

  @doc """
  This function generates a OAuth2 redirect URL that takes your users to a
  Patreon login page. After logging in your users will be redirected to a
  page of your choosing.

  Returns `string`

  ## Examples
      authorize_url([identity, campaigns], "https://google.com", "your_client_id")

  """

  @spec authorize_url(list(binary), binary, binary) :: binary

  defdelegate authorize_url(scope, redirect_uri, client_id), to: Wrapper

  @doc """
  This function is the same as `authorize_url/3` but generates a URL that asks
  users for permission for all scopes.

  Returns `string`

  ## Examples
      authorize_url("https://google.com", "your_client_id")

  """

  @spec authorize_url(list(binary), binary, binary) :: binary

  defdelegate authorize_url(redirect_uri, client_id), to: Wrapper


  @doc """
  This function is validates the URL parameter `code` that the user is
  redirected to after logging in. Your application needs to retrieve the
  `code` from the URL and pass it to this command.

  If validation is successful, then Patreon will return an access token
  that you can use to make API calls.

  Returns `map`

  ## Examples
      validate_code("your code param from url", "https://google.com", "your client id", "your client secret")

  """
  @spec validate_code(binary, binary, binary, binary) :: map

  defdelegate validate_code(validation_code, redirect_uri, client_id, client_secret), to: Wrapper

  @doc """
  This function wraps a request to the `identity` endpoint.

  Returns `map`

  ## Examples
      get_user(
        "access_token_here",
        %{
          "include" => "memberships.currently_entitled_tiers",
          "fields[user]" => Enum.join(["about", "hide_pledges", "full_name", "image_url", "thumb_url", "url"], ","),
          "fields[tier]" => Enum.join(["title", "description"], ",")
        }
        )
  """

  @spec get_user(binary, map) :: map

  defdelegate get_user(token, params), to: Wrapper

  @doc """
  This function is wraps a request to the `identity` endpoint.

  Returns `map`

  ## Examples
      get_campaigns(
        "access_token_here",
        %{
          "include" => "tiers",
          "fields[campaign]" => Enum.join(["vanity", "creation_name", "discord_server_id", "image_url", "is_nsfw", "url"], ","),
          "fields[tier]" => Enum.join(["title", "description"], ",")
        }
        )
  """

  @spec get_campaigns(binary, map) :: map

  defdelegate get_campaigns(token, params), to: Wrapper

  @doc """
  Fetches the users for a given campaign
  """
  @spec get_campaign_users(binary, binary, map) :: map

  defdelegate get_campaign_users(token, campaign_id, params), to: Wrapper

  @doc """
  Fetches posts for a given campaign.

  ## Parameters
    * `token` - Access token
    * `campaign_id` - ID of the campaign to fetch posts from
    * `params` - Optional parameters map for filtering and including related data

  ## Examples
      get_campaign_posts(
        "access_token_here",
        "12345",
        %{
          "include" => "campaign,user",
          "fields[post]" => Enum.join(["title", "content", "published_at", "url"], ","),
          "filter[is_draft]" => false,
          "sort" => "-published_at"
        }
      )
  """
  @spec get_campaign_posts(binary, binary, map) :: map
  defdelegate get_campaign_posts(token, campaign_id, params), to: Wrapper

  @doc """
  Refreshes an OAuth2 token using a refresh token.
  Returns a map containing the new access_token and refresh_token on success.

  ## Parameters
    * `refresh_token` - The refresh token to use
    * `client_id` - Your Patreon client ID
    * `client_secret` - Your Patreon client secret

  ## Examples
      refresh_token("refresh_token_here", "client_id", "client_secret")
  """
  @spec refresh_token(binary, binary, binary) :: {:ok, map} | {:error, any}
  defdelegate refresh_token(refresh_token, client_id, client_secret), to: Wrapper
end
