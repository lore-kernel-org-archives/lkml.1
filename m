Return-Path: <linux-kernel-owner+w=401wt.eu-S934148AbXINQQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934148AbXINQQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761949AbXINQQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:16:12 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60631 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756661AbXINQQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:16:09 -0400
Date: Fri, 14 Sep 2007 18:16:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
Message-ID: <20070914161619.GM3563@stusta.de>
References: <20070907124800.GP16806@vanheusden.com> <p73fy1p9m57.fsf@bingen.suse.de> <1189371621.3526.28.camel@localhost.localdomain> <20070909210329.GE25798@one.firstfloor.org> <46E46190.6080607@garzik.org> <20070912224655.GC3563@stusta.de> <46EAA08F.30703@s5r6.in-berlin.de> <20070914151522.GL3563@stusta.de> <46EAAAC1.3050409@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46EAAAC1.3050409@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 05:37:37PM +0200, Stefan Richter wrote:
> Adrian Bunk wrote:
> > On Fri, Sep 14, 2007 at 04:54:07PM +0200, Stefan Richter wrote:
> >> The patch which is discussed here is specifically targeted towards users
> >> who are convinced that they can migrate to different drivers without
> >> reading Kconfig help texts.
> > 
> > Nothing about the patch is only about migration.
> > 
> > The same applies if you configure a kernel from scratch.
> > 
> > Do "make menuconfig" with the .config you are normally using, count the 
> > number of options that are visible, and ask yourself whether we can 
> > really expect users to read the help texts for every single option shown.
> > 
> > People mostly read help texts for options where they don't understand 
> > what this option is about - and "Serial ATA" therefore is an option that 
> > is likely to get enabled without the user looking at the help text.
> 
> If you create .config from scratch, then you can get away without
> reading help texts if you have a target with minimal hardware and
> protocols requirements and you know all the subsystems involved.
> 
> In all other cases, you theoretically need to read all help texts (minus
> the ones that don't appear because you deselect entire subsystems).  In
> practice, this takes too much time, hence you take an existing .config
> (yours or somebody else's) and go from there.

Kconfig let's you start with the defconfig when doing "make menuconfig" 
without any .config present, so in practice users start from the 
defconfig and then go through all menus at once enabling and disabling 
options to adapt the configurations to their needs.

Or they start from the "includes everything" .config of their 
distribution and remove everything they don't need.

> Whenever one enables an option for the first time, it would IMO be
> foolish to ignore its help text.

Then the number of non-foolish users is quite near to 0...

If you expect people to read several hundreds or thousands of help texts 
only for configuring a kernel then you are expecting something that is 
simply not realistic.

It is intuitive for a user to enable the "Serial ATA" menu and he might 
not expect to have to read the help text when he has SATA drivers, while 
having to enable anything in the "SCSI device support" menu is highly 
unintuitively when the user does not have SCSI hardware.

> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

