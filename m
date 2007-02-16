Return-Path: <linux-kernel-owner+w=401wt.eu-S1751300AbXBPMDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbXBPMDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 07:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbXBPMDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 07:03:11 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59049 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751300AbXBPMDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 07:03:10 -0500
Date: Fri, 16 Feb 2007 13:03:12 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [git patches] libata updates (mostly fixes)
Message-ID: <20070216120312.GL13958@stusta.de>
References: <20070215233411.GA10782@havoc.gtf.org> <Pine.LNX.4.64.0702151546130.20368@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702151546130.20368@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 03:48:04PM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 15 Feb 2007, Jeff Garzik wrote:
> > 
> > diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
> > index db185f3..d51f0f1 100644
> > --- a/arch/ia64/Kconfig
> > +++ b/arch/ia64/Kconfig
> > @@ -22,6 +22,7 @@ config IA64
> >  
> >  config 64BIT
> >  	bool
> > +	select ATA_NONSTANDARD if ATA
> >  	default y
> 
> Ok, this is just _strange_.
> 
> Tying ATA_NONSTANDARD into ia64 by tying it to the 64BIT config variable 
> may work (well, I _assume_ it does), but it's just psychedelic.
> 
> How about adding a separate config entry like
> 
> 	config IA64_ATA
> 		bool
> 		depends on ATA
> 		select ATA_NONSTANDARD
> 		default y
> 
> which kind of makes sense when you squint just the right way..


What about simply providing asm/libata-portmap.h on all architectures 
instead of this ATA_NONSTANDARD trickery?


> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

