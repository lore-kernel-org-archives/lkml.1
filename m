Return-Path: <linux-kernel-owner+w=401wt.eu-S932904AbXGSU0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904AbXGSU0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760078AbXGSU0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:26:34 -0400
Received: from asia.telenet-ops.be ([195.130.137.74]:51857 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760013AbXGSU0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:26:33 -0400
Date: Thu, 19 Jul 2007 22:26:26 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: 2.6.22-git* regression: Kconfig prompts without help text
In-Reply-To: <Pine.LNX.4.64.0707181916410.5385@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0707192219380.18342@anakin>
References: <469BBDAD.2010908@s5r6.in-berlin.de>
 <Pine.LNX.4.64.0707181634100.5385@fbirervta.pbzchgretzou.qr>
 <20070718094119.4a26ae03.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0707181916410.5385@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007, Jan Engelhardt wrote:
> Add some help texts to recently-introduced kconfig items
> 
> Index: linux-2.6.23/drivers/macintosh/Kconfig
> ===================================================================
> --- linux-2.6.23.orig/drivers/macintosh/Kconfig
> +++ linux-2.6.23/drivers/macintosh/Kconfig
> @@ -3,6 +3,12 @@ menuconfig MACINTOSH_DRIVERS
>  	bool "Macintosh device drivers"
>  	depends on PPC || MAC || X86
>  	default y if (PPC_PMAC || MAC)
> +	---help---
> +	  Say Y here to get to see options for devices used with Macintosh
> +	  computers, both PPC and Intel based. This option alone does not add
                                  ^^^^^
> +	  any kernel code.
> +
> +	  If you say N, all options in this submenu will be skipped and disabled.

`MAC' is the symbol for m68k Macs.

>From a quick look at drivers/macintosh/Kconfig, all of the entries are for m68k
and PPC Macs only.  The only thing that depends on X86 is the main menu...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
