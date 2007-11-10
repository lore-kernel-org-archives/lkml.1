Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbXKJLu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbXKJLu1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 06:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbXKJLuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 06:50:18 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:40664 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751278AbXKJLuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 06:50:17 -0500
Date: Sat, 10 Nov 2007 12:49:53 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: ARM defconfig bogosity in current git
Message-ID: <20071110114953.GL26163@stusta.de>
References: <20071110080629.GA18520@linux-sh.org> <20071110091057.GA10446@flint.arm.linux.org.uk> <20071110112632.GQ8087@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071110112632.GQ8087@pengutronix.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 12:26:32PM +0100, Robert Schwebel wrote:
> On Sat, Nov 10, 2007 at 09:10:57AM +0000, Russell King wrote:
> > > diff --git a/arm/configs/netx_defconfig b/arm/configs/netx_defconfig
> > > new file mode 100644
> > > index 0000000..57f32f3
> > > --- /dev/null
> > > +++ b/arm/configs/netx_defconfig
> > > 
> > > ...
> > > 
> > > Isn't there something in Documentation/ about -p1 being a good idea
> > > precisely so this sort of silliness is avoided?
> > 
> > -p1 doesn't avoid this when the patch just contains new files.
> > Unfortunately, you have to rely both on people spotting such things
> > and whoever's generating the patch doing the right thing.
> > 
> > There will be times when things slip through though.
> > 
> > > Currently this breaks tab completion on arch/, which is very much a
> > > regression ;-)
> > 
> > Robert?
> 
> Aaargh, that came from a broken script changing the patch from p0 to p1...
> Please simply revert that patch, I'll send a new and correct one.

You should also check what you sent - the contents of this file was 
exactly the same as arch/arm/configs/netx_defconfig is since one year.

> Sorry for the noise.
> 
> Robert

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

