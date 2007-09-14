Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbXINTGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbXINTGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 15:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbXINTGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 15:06:00 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58831 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755688AbXINTF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 15:05:59 -0400
Date: Fri, 14 Sep 2007 21:06:09 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       James Bottomley <james.bottomley@steeleye.com>,
       linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <andi@firstfloor.org>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] SCSI: split Kconfig menu into two
Message-ID: <20070914190609.GN3563@stusta.de>
References: <1189371621.3526.28.camel@localhost.localdomain> <20070909210329.GE25798@one.firstfloor.org> <46E46190.6080607@garzik.org> <20070912224655.GC3563@stusta.de> <46EAA08F.30703@s5r6.in-berlin.de> <20070914151522.GL3563@stusta.de> <46EAAAC1.3050409@s5r6.in-berlin.de> <tkrat.d922469e152fe0f3@s5r6.in-berlin.de> <tkrat.913e8b183cdf7888@s5r6.in-berlin.de> <20070914190033.GA4003@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070914190033.GA4003@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 09:00:33PM +0200, Sam Ravnborg wrote:
> Hi Stefan.
> 
> Such a patch really calls for some minimal unifacation among
> the architectures.
> 
> > 
> >  arch/alpha/Kconfig            |    2 
> >  arch/arm/Kconfig              |    2 
> >  arch/avr32/Kconfig            |    2 
> >  arch/blackfin/Kconfig         |    2 
> >  arch/cris/Kconfig             |    2 
> >  arch/frv/Kconfig              |    2 
> >  arch/i386/Kconfig             |    2 
> >  arch/ia64/Kconfig             |    2 
> >  arch/m32r/Kconfig             |    2 
> >  arch/m68k/Kconfig             |    2 
> >  arch/m68knommu/Kconfig        |    2 
> >  arch/mips/Kconfig             |    2 
> >  arch/parisc/Kconfig           |    2 
> >  arch/powerpc/Kconfig          |    2 
> >  arch/ppc/Kconfig              |    2 
> >  arch/s390/Kconfig             |    2 
> >  arch/sh/Kconfig               |    2 
> >  arch/sh64/Kconfig             |    2 
> >  arch/sparc/Kconfig            |    2 
> >  arch/sparc64/Kconfig          |    2 
> >  arch/um/Kconfig               |    2 
> >  arch/v850/Kconfig             |    2 
> >  arch/x86_64/Kconfig           |    4 
> >  arch/xtensa/Kconfig           |    2 
> 
> 
> Exactly the same change for all architectures.
> IT would be good to introduce a common file that contains
> some of the shared stuff from the different architectures.
> We could start out simple with:
> 
> arch/Kconfig.arch:
>...

Stefan simply shouldn't move it out of drivers/Kconfig.

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

