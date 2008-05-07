Return-Path: <linux-kernel-owner+w=401wt.eu-S1763552AbYEGHSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763552AbYEGHSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbYEGHSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:18:06 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:44767 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001AbYEGHSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:18:04 -0400
Date: Wed, 7 May 2008 09:17:56 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Simek <monstr@seznam.cz>
cc: Arnd Bergmann <arnd@arndb.de>, John Williams <john.williams@petalogix.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca
Subject: Re: [PATCH 36/56] microblaze_v2: dma support
In-Reply-To: <48214B36.9060307@seznam.cz>
Message-ID: <Pine.LNX.4.64.0805070917111.6341@anakin>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <200805061324.06282.arnd@arndb.de> <48205B0D.70202@seznam.cz>
 <200805061736.18180.arnd@arndb.de> <48214B36.9060307@seznam.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008, Michal Simek wrote:
> struct scatterlist {
> #ifdef CONFIG_DEBUG_SG
>        unsigned long     sg_magic; /* 32 bit */
> #endif
>        unsigned long     page_link; /* 32 bit */

On 64-bit platforms, `unsigned long' is 64-bit, too.

>        dma_addr_t        dma_address; /* 32/64 bit */
>        unsigned int      length;  /* 32 bit */
>        unsigned int      offset; /* 32 bit */
> };
> 
> #define sg_dma_address(sg)      ((sg)->dma_address)
> #define sg_dma_len(sg)          ((sg)->length)
> 
> Is it OK now? This will moved to asm-generic too.

Ack.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
