Return-Path: <linux-kernel-owner+w=401wt.eu-S932671AbZDIKIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671AbZDIKIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761040AbZDIKIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:08:09 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:32774 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760966AbZDIKII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:08:08 -0400
X-Sasl-enc: tjYMEiAjqn90z2K9e9kq3GUAv6W8Es/lHhQOkAzkmFxF 1239271686
Message-ID: <49DDC903.5040803@fastmail.fm>
Date: Thu, 09 Apr 2009 11:08:03 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org, kernel-janitors@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH 27/56] ipv4: Remove void casts
References: <> <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm>
In-Reply-To: <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm>
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
>  net/ipv4/route.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index c40debe..3699077 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -2707,8 +2707,7 @@ static struct dst_ops ipv4_dst_blackhole_ops = {
>  static int ipv4_dst_blackhole(struct net *net, struct rtable **rp, struct flowi *flp)
>  {
>  	struct rtable *ort = *rp;
> -	struct rtable *rt = (struct rtable *)
> -		dst_alloc(&ipv4_dst_blackhole_ops);
> +	struct rtable *rt = dst_alloc(&ipv4_dst_blackhole_ops);
>  
>  	if (rt) {
>  		struct dst_entry *new = &rt->u.dst;
>   

