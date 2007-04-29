Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbXD2HnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbXD2HnZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 03:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbXD2HnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 03:43:25 -0400
Received: from gw.goop.org ([64.81.55.164]:55414 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958AbXD2HnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 03:43:24 -0400
Message-ID: <46344CA5.6000900@goop.org>
Date: Sun, 29 Apr 2007 00:43:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Subject: Re: [PATCH 22/25] xen: xen-netfront: use skb.cb for storing private
 data
References: <20070423215638.563901986@goop.org> <20070423215713.550883195@goop.org> <20070424014528.GA27789@gondor.apana.org.au> <462D88EF.9030007@goop.org> <20070424055731.GA30018@gondor.apana.org.au> <46327706.80508@goop.org> <20070427223742.GA2742@gondor.apana.org.au> <463286D9.7090609@goop.org> <20070428062839.GA6535@gondor.apana.org.au>
In-Reply-To: <20070428062839.GA6535@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> BTW, the version I posted to you is missing the following line.
>   
> --- linux-2.6.20.i386/drivers/xen/core/skbuff.c	2007-04-28 15:30:16.000000000 +1000
> +++ build-2.6.20.i386/drivers/xen/core/skbuff.c	2007-04-28 15:30:52.000000000 +1000
> @@ -89,6 +89,7 @@
>  	skb->h.raw = (unsigned char *)skb->nh.iph + 4*skb->nh.iph->ihl;
>  	if (skb->h.raw >= skb->tail)
>  		goto out;
> +	skb->csum_start = skb->h.raw - skb->head;
>  	switch (skb->nh.iph->protocol) {
>  	case IPPROTO_TCP:
>  		skb->csum_offset = offsetof(struct tcphdr, check);
>   

drivers/xen/core/skbuff.c?  What's that?

    J
