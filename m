Return-Path: <linux-kernel-owner+w=401wt.eu-S1757761AbYLLEcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761AbYLLEcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 23:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756186AbYLLEcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 23:32:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45203
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756161AbYLLEcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 23:32:42 -0500
Date: Thu, 11 Dec 2008 20:32:43 -0800 (PST)
Message-Id: <20081211.203243.124017657.davem@davemloft.net>
To: ajax@redhat.com
Cc: linux-kernel@vger.kernel.org, davej@redhat.com, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, kaber@trash.net
Subject: Re: [PATCH] net: Remove a noisy printk
From: David Miller <davem@davemloft.net>
In-Reply-To: <1229033625-30825-1-git-send-email-ajax@redhat.com>
References: <1229033625-30825-1-git-send-email-ajax@redhat.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adam Jackson <ajax@redhat.com>
Date: Thu, 11 Dec 2008 17:13:42 -0500

> From: Dave Jones <davej@redhat.com>
> 
> These messages are trivial to trigger when running stress tests
> like isic, and add no real value.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Adam Jackson <ajax@redhat.com>

If you don't send this to the netfilter developers nor the networking
developers, noboby knowledgable can even look at this patch.

CC:'d

> ---
>  net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> index 4a7c352..0e86d0d 100644
> --- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> +++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> @@ -147,8 +147,6 @@ static unsigned int ipv4_conntrack_local(unsigned int hooknum,
>  	/* root is playing with raw sockets. */
>  	if (skb->len < sizeof(struct iphdr) ||
>  	    ip_hdrlen(skb) < sizeof(struct iphdr)) {
> -		if (net_ratelimit())
> -			printk("ipt_hook: happy cracking.\n");
>  		return NF_ACCEPT;
>  	}
>  	return nf_conntrack_in(dev_net(out), PF_INET, hooknum, skb);
> -- 
> 1.6.0.3
