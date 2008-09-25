Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbYIYNdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbYIYNdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 09:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYIYNdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 09:33:04 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:47801 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665AbYIYNdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 09:33:03 -0400
Date: Thu, 25 Sep 2008 16:31:59 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@snapgear.com>, jbarnes@virtuousgeek.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [2.6 patch] m68k: remove the dead PCI code
Message-ID: <20080925133159.GC9566@cs181140183.pp.htv.fi>
References: <20080819134718.GH8852@cs181140183.pp.htv.fi> <48B24E2C.9060703@snapgear.com> <20080825204333.GA13027@cs181140183.pp.htv.fi> <48B77764.6060607@snapgear.com> <20080829070103.GD16462@cs181140183.pp.htv.fi> <Pine.LNX.4.64.0808290929280.22326@anakin> <20080831161016.GE3695@cs181140183.pp.htv.fi> <Pine.LNX.4.64.0809061422510.4138@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0809061422510.4138@anakin>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2008 at 02:23:50PM +0200, Geert Uytterhoeven wrote:
> On Sun, 31 Aug 2008, Adrian Bunk wrote:
> > This patch removes the no longer used m68k PCI code.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> > --- a/include/asm-m68k/pci.h
> > +++ b/include/asm-m68k/pci.h
> 
> > -/* The PCI address space does equal the physical memory
> > - * address space.  The networking and block device layers use
> > - * this boolean for bounce buffer decisions.
> > - */
> 
> I'd like to keep this comment, as the #define is still there.
> Is that OK for you?

Sorry for the late answer.

That's fine for me.

> >  #define PCI_DMA_BUS_IS_PHYS	(1)
> 
> Gr{oetje,eeting}s,
> 
> 						Geert

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

