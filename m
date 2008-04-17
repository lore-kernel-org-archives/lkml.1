Return-Path: <linux-kernel-owner+w=401wt.eu-S1762337AbYDQKs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762337AbYDQKs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758841AbYDQKsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 06:48:46 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:47244 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756434AbYDQKsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 06:48:45 -0400
Date: Thu, 17 Apr 2008 13:48:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: [2.6 patch] ARM: always select HAVE_IDE
Message-ID: <20080417104836.GH1677@cs181133002.pp.htv.fi>
References: <20080414141659.GF6695@cs181133002.pp.htv.fi> <20080415221002.GL1677@cs181133002.pp.htv.fi> <20080415223928.GH5676@flint.arm.linux.org.uk> <200804160126.11116.bzolnier@gmail.com> <20080417093753.GF1677@cs181133002.pp.htv.fi> <20080417095916.GD1449@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080417095916.GD1449@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 10:59:16AM +0100, Russell King wrote:
> On Thu, Apr 17, 2008 at 12:37:53PM +0300, Adrian Bunk wrote:
> > Any objections against the patch below?
> 
> Let's look at the rest of the situation surrounding HAVE_IDE first.
> It's something of a mess:
> 
> avr32, m68knommu, ppc, s390 and v850 do not have asm/ide.h
> 
> avr32, m68knommu, ppc, v850 all set HAVE_IDE, arch/s390/Kconfig contains
> no reference.
> 
> avr32 supports PATA (which is IDE).
> 
> Everything else provides an asm/ide.h and sets HAVE_IDE.
> 
> So:
> 
> Q1. Do avr32, m68knommu, ppc, v850 have IDE support or do they not?

avr32 is fixed in 2.6.25 (no more HAVE_IDE)
m68knommu I'll check
ppc arch will be removed in 2 months
v850 arch is completely hosed, and I'm already trying to get it removed

> Q2. Should avr32, m68knommu, ppc, v850 supply an asm/ide.h header?
> Q3. Is it worth supporting HAVE_IDE for all kernel architectures when
>     its just one (s390) which supports neither IDE nor ATA - or would
>     something more generic covering both be appropriate.
> 
> -- 
> Russell King

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

