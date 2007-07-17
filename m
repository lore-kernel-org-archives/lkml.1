Return-Path: <linux-kernel-owner+w=401wt.eu-S1763822AbXGQQrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763822AbXGQQrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbXGQQrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:47:09 -0400
Received: from ananke.telenet-ops.be ([195.130.137.78]:41213 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbXGQQrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:47:07 -0400
Date: Tue, 17 Jul 2007 18:46:54 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jeff Dike <jdike@addtoit.com>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       zippel@linux-m68k.org, jdike@karaya.com, alan@lxorguk.ukuu.org.uk,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: uninline check_signature()
In-Reply-To: <20070717163328.GG7965@c2.user-mode-linux.org>
Message-ID: <Pine.LNX.4.64.0707171842590.10600@anakin>
References: <200707161802.l6GI2tNp007390@hera.kernel.org>
 <20070716221257.GA12230@osiris.ibm.com> <20070716152923.ce4a5c5a.akpm@linux-foundation.org>
 <alpine.LFD.0.999.0707161532190.20061@woody.linux-foundation.org>
 <20070716230307.GB12230@osiris.ibm.com> <Pine.LNX.4.64.0707171519300.10600@anakin>
 <20070717163328.GG7965@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Jeff Dike wrote:
> On Tue, Jul 17, 2007 at 03:22:16PM +0200, Geert Uytterhoeven wrote:
> > I saw this patch went in.
> > 
> > iomap_copy.o ues the raw I/O memory accessors, so it truly depends on
> > CONFIG_HAS_IOMEM.
> 
> This works for UML.

Of course. UML (and s390) doesn't have (a need for) I/O memory because it uses
paravirtualization for all drivers.

M68k uses I/O memory for all I/O (hence it sets CONFIG_HAS_IOMEM), but
many m68k machines don't have PCI or ISA (hence it doesn't set
CONFIG_PCI resp. CONFIG_ISA).

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
