Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbXGRGpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbXGRGpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 02:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbXGRGpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 02:45:19 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:35367 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbXGRGpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 02:45:18 -0400
Date: Wed, 18 Jul 2007 08:45:05 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Dike <jdike@addtoit.com>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>, jdike@karaya.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: uninline check_signature()
In-Reply-To: <alpine.LFD.0.999.0707171338290.27353@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707180844330.23024@anakin>
References: <200707161802.l6GI2tNp007390@hera.kernel.org>
 <20070716221257.GA12230@osiris.ibm.com> <20070716152923.ce4a5c5a.akpm@linux-foundation.org>
 <alpine.LFD.0.999.0707161532190.20061@woody.linux-foundation.org>
 <20070716230307.GB12230@osiris.ibm.com> <Pine.LNX.4.64.0707171519300.10600@anakin>
 <20070717163328.GG7965@c2.user-mode-linux.org> <Pine.LNX.4.64.0707171842590.10600@anakin>
 <alpine.LFD.0.999.0707171102040.19166@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707172225260.23024@anakin>
 <alpine.LFD.0.999.0707171338290.27353@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Linus Torvalds wrote:
> On Tue, 17 Jul 2007, Geert Uytterhoeven wrote:
> > OR I'll have to disable HAS_IOMEM on m68k, and invent a new Kconfig
> > symbol for lots of other stuff that currently depends on HAS_IOMEM...
> 
> Well, as far as I'm concerned, you could also make all drivers that 
> actually need "check_signature()" do a Kconfig level
> 
> 	select CHECK_SIGNATURE
> 
> along with a
> 
> 	config CHECK_SIGNATURE
> 		bool
> 		default n
> 
> in lib/Kconfig, and thus make it totally independent of any hw/bus 
> features at all, and simply depend on whether it is needed or not. I'd be 
> ok with that, and it's certainly "correct" too.
> 
> Hmm?

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> ;-)

(will cook a patch when I find a timeslot)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
