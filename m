Return-Path: <linux-kernel-owner+w=401wt.eu-S1759792AbXGQIun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759792AbXGQIun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758834AbXGQIuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:50:32 -0400
Received: from hoboe2bl1.telenet-ops.be ([195.130.137.73]:60856 "EHLO
	hoboe2bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759486AbXGQIua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:50:30 -0400
Date: Tue, 17 Jul 2007 10:50:18 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       zippel@linux-m68k.org, jdike@karaya.com, alan@lxorguk.ukuu.org.uk,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: uninline check_signature()
In-Reply-To: <alpine.LFD.0.999.0707161532190.20061@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707171049080.10600@anakin>
References: <200707161802.l6GI2tNp007390@hera.kernel.org>
 <20070716221257.GA12230@osiris.ibm.com> <20070716152923.ce4a5c5a.akpm@linux-foundation.org>
 <alpine.LFD.0.999.0707161532190.20061@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007, Linus Torvalds wrote:
> On Mon, 16 Jul 2007, Andrew Morton wrote:
> > No, no revert, please.  If the architecture doesn't support readb() then we
> > need some reliable way of working that out within Kconfig.
> 
> Isn't that CONFIG_HAS_IOMEM?

No, having memory mapped I/O doesn't mean you have PCI.
How to access memory mapped I/O depends on the bus behind the device.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
