Return-Path: <linux-kernel-owner+w=401wt.eu-S1765571AbZDIKJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765571AbZDIKJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758972AbZDIKIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:08:43 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43538 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756745AbZDIKIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:08:42 -0400
X-Sasl-enc: q86oGf5y0gSYHR5Z/oip28jIIPDIxbBDjPnipZE9MTZx 1239271721
Message-ID: <49DDC925.9050706@fastmail.fm>
Date: Thu, 09 Apr 2009 11:08:37 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org, kernel-janitors@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH 28/56] ipv6: Remove void casts
References: <> <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>
In-Reply-To: <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added maintainer CC]
Jack Stone wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  net/ipv6/route.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 1394ddb..9c70a88 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -834,8 +834,7 @@ EXPORT_SYMBOL(ip6_route_output);
>  int ip6_dst_blackhole(struct sock *sk, struct dst_entry **dstp, struct flowi *fl)
>  {
>  	struct rt6_info *ort = (struct rt6_info *) *dstp;
> -	struct rt6_info *rt = (struct rt6_info *)
> -		dst_alloc(&ip6_dst_blackhole_ops);
> +	struct rt6_info *rt = dst_alloc(&ip6_dst_blackhole_ops);
>  	struct dst_entry *new = NULL;
>  
>  	if (rt) {
>   

