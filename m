Return-Path: <linux-kernel-owner+w=401wt.eu-S932225AbYDOWLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225AbYDOWLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 18:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757375AbYDOWLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 18:11:15 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:58374 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbYDOWLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 18:11:14 -0400
Date: Wed, 16 Apr 2008 01:10:02 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: [2.6 patch] PCMCIA mustn't select HAVE_IDE
Message-ID: <20080415221002.GL1677@cs181133002.pp.htv.fi>
References: <20080414141659.GF6695@cs181133002.pp.htv.fi> <20080414175344.GA15028@uranus.ravnborg.org> <200804152215.34904.bzolnier@gmail.com> <20080415212326.GF1677@cs181133002.pp.htv.fi> <20080415212822.GE5676@flint.arm.linux.org.uk> <20080415214203.GF5676@flint.arm.linux.org.uk> <20080415215223.GK1677@cs181133002.pp.htv.fi> <20080415220344.GG5676@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080415220344.GG5676@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 11:03:45PM +0100, Russell King wrote:
> On Wed, Apr 16, 2008 at 12:52:23AM +0300, Adrian Bunk wrote:
>...
> So this is a only impacting ARM wrt. PCMCIA, and given that ARM supplies
> an asm/ide.h, it's _entirely_ reasonable that if a platform has PCMCIA
> then it supports IDE.
> 
> > We could simply always select HAVE_IDE on arm instead of manually 
> > setting which platforms could possibly get IDE support (e.g. are there
> > any boards with PCI slots for which HAVE_IDE is currently not 
> > selected?).
> 
> You could, if there was a demand for it.  As no one has added that,
> I conclude that its less common for people to stick an IDE controller
> into a PCI backplane.

People can always enable code for stuff they don't use.

But instead of having 14 ARM platforms plus PCMCIA (which is offered 
unconditionally on all ARM platforms...) select HAVE_IDE it's simpler
to select it once for all ARM platforms.

> In fact, there are only three classes of ARM platforms which have PCI
> selected but not HAVE_IDE - IOP13xx, IXP2000, and Orion.  I suspect
> the only reason they don't select it because they now use the ATA code
> rather than the old IDE code - that's certainly true of Orion.

The libata options are offered unconditionally on all platforms...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

