Return-Path: <linux-kernel-owner+w=401wt.eu-S933211AbXGSXUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211AbXGSXUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 19:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756493AbXGSXU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 19:20:27 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:34663 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289AbXGSXU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 19:20:26 -0400
Date: Thu, 19 Jul 2007 23:05:18 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: 2.6.22-git* regression: Kconfig prompts without help text
In-Reply-To: <469FCE5E.80803@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0707192304450.18342@anakin>
References: <469BBDAD.2010908@s5r6.in-berlin.de>
 <Pine.LNX.4.64.0707181634100.5385@fbirervta.pbzchgretzou.qr>
 <20070718094119.4a26ae03.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0707181916410.5385@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0707192219380.18342@anakin> <469FCE5E.80803@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007, Stefan Richter wrote:
> Geert Uytterhoeven wrote:
> > On Wed, 18 Jul 2007, Jan Engelhardt wrote:
> >> Add some help texts to recently-introduced kconfig items
> >>
> >> Index: linux-2.6.23/drivers/macintosh/Kconfig
> >> ===================================================================
> >> --- linux-2.6.23.orig/drivers/macintosh/Kconfig
> >> +++ linux-2.6.23/drivers/macintosh/Kconfig
> >> @@ -3,6 +3,12 @@ menuconfig MACINTOSH_DRIVERS
> >>  	bool "Macintosh device drivers"
> >>  	depends on PPC || MAC || X86
> >>  	default y if (PPC_PMAC || MAC)
> >> +	---help---
> >> +	  Say Y here to get to see options for devices used with Macintosh
> >> +	  computers, both PPC and Intel based. This option alone does not add
> >                                   ^^^^^
> >> +	  any kernel code.
> >> +
> >> +	  If you say N, all options in this submenu will be skipped and disabled.
> > 
> > `MAC' is the symbol for m68k Macs.
> 
> OK, then this should read
> 
> 	  Say Y here to get to see options for devices used with Macintosh
> 	  computers. This option alone does not add any kernel code.
> 
> 	  If you say N, all options in this submenu will be skipped and disabled.
> 
> > From a quick look at drivers/macintosh/Kconfig, all of the entries are for m68k
> > and PPC Macs only.  The only thing that depends on X86 is the main menu...
> 
> There is one entry for all sorts of Macs, MAC_EMUMOUSEBTN.

You're right, I missed that one, as I used `grep depends' ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
