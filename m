Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbXKVUUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbXKVUUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 15:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbXKVUUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 15:20:46 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:56087 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbXKVUUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 15:20:45 -0500
Date: Thu, 22 Nov 2007 21:20:44 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix plip 1
In-Reply-To: <Pine.LNX.4.64.0711222053170.15336@artax.karlin.mff.cuni.cz>
Message-ID: <Pine.LNX.4.64.0711222119500.15336@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0711222053170.15336@artax.karlin.mff.cuni.cz>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to add:
Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

> diff -u -r linux-2.6.24-rc2/drivers/net/plip.c linux-2.6.24-test/drivers/net/plip.c
> --- linux-2.6.24-rc2/drivers/net/plip.c	2007-11-06 22:57:46.000000000 +0100
> +++ linux-2.6.24-test/drivers/net/plip.c	2007-11-22 21:11:28.000000000 +0100
> @@ -663,7 +663,7 @@
>  	case PLIP_PK_DONE:
>  		/* Inform the upper layer for the arrival of a packet. */
>  		rcv->skb->protocol=plip_type_trans(rcv->skb, dev);
> -		netif_rx(rcv->skb);
> +		netif_rx_ni(rcv->skb);
>  		dev->last_rx = jiffies;
>  		dev->stats.rx_bytes += rcv->length.h;
>  		dev->stats.rx_packets++;
> 
