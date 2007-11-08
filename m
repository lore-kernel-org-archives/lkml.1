Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbXKHIu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbXKHIu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 03:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbXKHIuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 03:50:19 -0500
Received: from www.tglx.de ([62.245.132.106]:36680 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbXKHIuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 03:50:17 -0500
Date: Thu, 8 Nov 2007 09:49:11 +0100
From: =?ISO-8859-15?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Mark Lord <lkml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] r8169 fix regression on ASUS motherboards (updated)
Message-ID: <20071108094911.241bab27@dilbert.local>
In-Reply-To: <20071108002112.GD15367@electric-eye.fr.zoreil.com>
References: <4731E2AB.5080703@rtr.ca>
	<4731FDB7.8010505@rtr.ca>
	<20071107220455.GA15367@electric-eye.fr.zoreil.com>
	<47323A69.5050206@rtr.ca>
	<47323B6B.9000909@rtr.ca>
	<47324843.4050602@rtr.ca>
	<20071108002112.GD15367@electric-eye.fr.zoreil.com>
Organization: Linutronix
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 8 Nov 2007 01:21:12 +0100
schrieb Francois Romieu <romieu@fr.zoreil.com>:

> Mark Lord <lkml@rtr.ca> :
> [...]
> > I've now received a couple of private emails from people reporting
> > full success with this patch.
> 
> Ok, I have pushed the patch below for Jeff to pull at korg.
> 
> >From 1dd7681bc2ff171341ea5cae957f8ecb5c0c102e Mon Sep 17 00:00:00
> >2001
> From: Mark Lord <mlord@pobox.com>
> Date: Thu, 8 Nov 2007 01:03:04 +0100
> Subject: [PATCH] r8169: revert
> 7da97ec96a0934319c7fbedd3d38baf533e20640 (partly)
> 
> Various symptoms depending on the .config options:
> - the card stops working after some (short) time
> - the card does not work at all
> - the card disappears (nothing in lspci/dmesg)
> 
> A real power-off is needed to recover the card.

This patch fixes the same problem on my MSI board.

> 
> Signed-off-by: Mark Lord <mlord@pobox.com>
> Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

Acked-by: Hans J. Koch <hjk@linutronix.de>

> ---
>  drivers/net/r8169.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
> index 9dbab3f..a37cf82 100644
> --- a/drivers/net/r8169.c
> +++ b/drivers/net/r8169.c
> @@ -1328,6 +1328,7 @@ static void rtl_hw_phy_config(struct net_device
> *dev) break;
>  	case RTL_GIGA_MAC_VER_11:
>  	case RTL_GIGA_MAC_VER_12:
> +		break;
>  	case RTL_GIGA_MAC_VER_17:
>  		rtl8168b_hw_phy_config(ioaddr);
>  		break;
