Return-Path: <linux-kernel-owner+w=401wt.eu-S1758780AbYGRR5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbYGRR5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbYGRR5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:57:42 -0400
Received: from stinky.trash.net ([213.144.137.162]:59301 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbYGRR5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:57:40 -0400
Message-ID: <4880D995.4010606@trash.net>
Date: Fri, 18 Jul 2008 19:57:41 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] nf_nat_snmp_basic: fix compiler warning on 64-bit	arch-s
References: <4880A611.76E4.0078.0@novell.com>
In-Reply-To: <4880A611.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  net/ipv4/netfilter/nf_nat_snmp_basic.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.26/net/ipv4/netfilter/nf_nat_snmp_basic.c	2008-07-13 23:51:29.000000000 +0200
> +++ 2.6.26-netfilter-warning/net/ipv4/netfilter/nf_nat_snmp_basic.c	2008-07-15 14:51:28.000000000 +0200
> @@ -445,7 +445,7 @@ static unsigned char asn1_oid_decode(str
>  	size = eoc - ctx->pointer + 1;
>  
>  	/* first subid actually encodes first two subids */
> -	if (size < 2 || size > ULONG_MAX/sizeof(unsigned long))
> +	if (size < 2 || size > UINT_MAX/sizeof(unsigned long))

Thanks, I already have a similar fix queued.
