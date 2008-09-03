Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbYICHXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbYICHXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 03:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbYICHW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 03:22:56 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:53603 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbYICHWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 03:22:55 -0400
Date: Wed, 3 Sep 2008 09:22:52 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Greg Ungerer <gerg@snapgear.com>, jbarnes@virtuousgeek.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [2.6 patch] m68k: remove the dead PCI code
In-Reply-To: <20080831161016.GE3695@cs181140183.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0809030922280.17860@anakin>
References: <20080819134718.GH8852@cs181140183.pp.htv.fi> <48B24E2C.9060703@snapgear.com>
 <20080825204333.GA13027@cs181140183.pp.htv.fi> <48B77764.6060607@snapgear.com>
 <20080829070103.GD16462@cs181140183.pp.htv.fi> <Pine.LNX.4.64.0808290929280.22326@anakin>
 <20080831161016.GE3695@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Aug 2008, Adrian Bunk wrote:
> On Fri, Aug 29, 2008 at 09:31:43AM +0200, Geert Uytterhoeven wrote:
> > On Fri, 29 Aug 2008, Adrian Bunk wrote:
> > > On Fri, Aug 29, 2008 at 02:13:24PM +1000, Greg Ungerer wrote:
> > > > Adrian Bunk wrote:
> > > >> A patch for removing the comempci code is below.
> > > >>
> > > >> It's a bit suspicious that asm/elia.h is now removed since comempci.c  
> > > >> was the only user. What's the sttus of the eLIA platform?
> > > >
> > > > Only ever a handful where made, and that was in 1999.
> > > > I doubt anyone could ever use the PCI interface on it
> > > > in any useful way.
> > > 
> > > So I can send a patch to remove the platform?
> > > 
> > > >> But COMEMPCI fails with a different error - this init/main.o build 
> > > >> error is present for CONFIG_PCI=y, CONFIG_COMEMPCI=n, so the dependency 
> > > >> of PCI on BROKEN is still required (unless it gets fixed).
> > > >
> > > > Unless I am mistaken there is now no need for the CONFIG_PCI option
> > > > if selecting m68knommu. The only m68knommu platforms that had PCI
> > > > as far as I know where those that use the comempci part.
> > > 
> > > That implies I can also kill the m68k PCI code since m68knommu will 
> > > never use it?
> > 
> > Sure. If the FreeScale guys ever forward-port their ColdFire/MMU code to
> > current mainline, we can readd it.
> 
> Patch (on top of my Hades removal patch) is below.
> 
> cu
> Adrian
> 
> 
> <--  snip    -->
> 
> 
> This patch removes the no longer used m68k PCI code.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Thanks! Will queue for 2.6.28, too.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
