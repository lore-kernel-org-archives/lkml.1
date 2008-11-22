Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbYKVBPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbYKVBPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 20:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbYKVBP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 20:15:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57949
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753734AbYKVBP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 20:15:26 -0500
Date: Fri, 21 Nov 2008 17:15:25 -0800 (PST)
Message-Id: <20081121.171525.198161288.davem@davemloft.net>
To: qhfeng.kernel@gmail.com
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 01/3] NET: remove redundant argument comments
From: David Miller <davem@davemloft.net>
In-Reply-To: <49270a30.011e6e0a.40c2.ffffb30e@mx.google.com>
References: <49270a30.011e6e0a.40c2.ffffb30e@mx.google.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qinghuang Feng <qhfeng.kernel@gmail.com>
Date: Sat, 22 Nov 2008 03:20:57 +0800

> Remove redundant argument comments in files of net/*
> 
> Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>

Applied, please submit networking patches to netdev@vger.kernel.org
in the future.

> diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
> index 2f1fe5f..7fa0eb2 100644
> --- a/net/9p/trans_rdma.c
> +++ b/net/9p/trans_rdma.c
> @@ -528,8 +528,6 @@ static void rdma_close(struct p9_client *client)
>  
>  /**
>   * alloc_rdma - Allocate and initialize the rdma transport structure
> - * @msize: MTU
> - * @dotu: Extension attribute
>   * @opts: Mount options structure
>   */
>  static struct p9_trans_rdma *alloc_rdma(struct p9_rdma_opts *opts)
> diff --git a/net/decnet/dn_nsp_out.c b/net/decnet/dn_nsp_out.c
> index 1964faf..81a40ff 100644
> --- a/net/decnet/dn_nsp_out.c
> +++ b/net/decnet/dn_nsp_out.c
> @@ -230,7 +230,6 @@ static inline unsigned dn_nsp_clone_and_send(struct sk_buff *skb,
>  /**
>   * dn_nsp_output - Try and send something from socket queues
>   * @sk: The socket whose queues are to be investigated
> - * @gfp: The memory allocation flags
>   *
>   * Try and send the packet on the end of the data and other data queues.
>   * Other data gets priority over data, and if we retransmit a packet we
> diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> index 64ce3d3..537ea34 100644
> --- a/net/ipv6/ip6_tunnel.c
> +++ b/net/ipv6/ip6_tunnel.c
> @@ -1150,7 +1150,6 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
>   * ip6_tnl_change - update the tunnel parameters
>   *   @t: tunnel to be changed
>   *   @p: tunnel configuration parameters
> - *   @active: != 0 if tunnel is ready for use
>   *
>   * Description:
>   *   ip6_tnl_change() updates the tunnel parameters
> diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
> index 5bcc452..56fd85a 100644
> --- a/net/llc/af_llc.c
> +++ b/net/llc/af_llc.c
> @@ -103,7 +103,6 @@ static inline u8 llc_ui_header_len(struct sock *sk, struct sockaddr_llc *addr)
>   *	llc_ui_send_data - send data via reliable llc2 connection
>   *	@sk: Connection the socket is using.
>   *	@skb: Data the user wishes to send.
> - *	@addr: Source and destination fields provided by the user.
>   *	@noblock: can we block waiting for data?
>   *
>   *	Send data via reliable llc2 connection.
> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
> index 501c783..bef73e9 100644
> --- a/net/mac80211/mesh_hwmp.c
> +++ b/net/mac80211/mesh_hwmp.c
> @@ -759,7 +759,6 @@ enddiscovery:
>   *
>   * @skb: 802.11 frame to be sent
>   * @sdata: network subif the frame will be sent through
> - * @fwd_frame: true if this frame was originally from a different host
>   *
>   * Returns: 0 if the next hop was found. Nonzero otherwise. If no next hop is
>   * found, the function will start a path discovery and queue the frame so it is
> diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
> index 0a0ef17..1821c5d 100644
> --- a/net/netlabel/netlabel_mgmt.c
> +++ b/net/netlabel/netlabel_mgmt.c
> @@ -596,7 +596,6 @@ listdef_failure:
>  /**
>   * netlbl_mgmt_protocols_cb - Write an individual PROTOCOL message response
>   * @skb: the skb to write to
> - * @seq: the NETLINK sequence number
>   * @cb: the NETLINK callback
>   * @protocol: the NetLabel protocol to use in the message
>   *
> 
