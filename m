Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbYIIHLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbYIIHLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbYIIHLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:11:24 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:54347 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbYIIHLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:11:23 -0400
Date: Tue, 9 Sep 2008 09:11:20 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Adrian Bunk <bunk@kernel.org>, Greg Ungerer <gerg@snapgear.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [2.6 patch] m68k: remove the dead PCI code
In-Reply-To: <200809082206.08031.jbarnes@virtuousgeek.org>
Message-ID: <Pine.LNX.4.64.0809090911100.12608@anakin>
References: <20080819134718.GH8852@cs181140183.pp.htv.fi>
 <20080831161016.GE3695@cs181140183.pp.htv.fi> <Pine.LNX.4.64.0809061422510.4138@anakin>
 <200809082206.08031.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008, Jesse Barnes wrote:
> On Saturday, September 06, 2008 5:23 am Geert Uytterhoeven wrote:
> > On Sun, 31 Aug 2008, Adrian Bunk wrote:
> > > This patch removes the no longer used m68k PCI code.
> > >
> > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > >
> > > --- a/include/asm-m68k/pci.h
> > > +++ b/include/asm-m68k/pci.h
> > >
> > > -/* The PCI address space does equal the physical memory
> > > - * address space.  The networking and block device layers use
> > > - * this boolean for bounce buffer decisions.
> > > - */
> >
> > I'd like to keep this comment, as the #define is still there.
> > Is that OK for you?
> >
> > >  #define PCI_DMA_BUS_IS_PHYS	(1)
> 
> Btw, I'm assuming you'll be queuing this up, Geert.  Let me know if you want 
> to do otherwise...

Yes, I will.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
