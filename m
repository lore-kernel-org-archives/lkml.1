Return-Path: <linux-kernel-owner+w=401wt.eu-S965453AbXCGT4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965453AbXCGT4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 14:56:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992532AbXCGT4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 14:56:03 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52524 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965502AbXCGT4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 14:56:01 -0500
Date: Wed, 7 Mar 2007 20:56:02 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Willy Tarreau <w@1wt.eu>
Cc: Bill Davidsen <davidsen@tmr.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.22 patch] the scheduled removal of OBSOLETE_OSS options
Message-ID: <20070307195601.GZ3441@stusta.de>
References: <20070305014956.GE3441@stusta.de> <45EDA8EE.1060308@tmr.com> <20070306175504.GW3441@stusta.de> <20070307062157.GJ943@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070307062157.GJ943@1wt.eu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 07:21:57AM +0100, Willy Tarreau wrote:
> On Tue, Mar 06, 2007 at 06:55:04PM +0100, Adrian Bunk wrote:
> > On Tue, Mar 06, 2007 at 12:46:22PM -0500, Bill Davidsen wrote:
> > > Adrian Bunk wrote:
> > > >This patch contains the scheduled removal of the OBSOLETE_OSS options 
> > > >for 2.6.22.
> > > >
> > > If these are drivers for which there are thought to be useful ALSA 
> > > drivers, would it be reasonable to leave a stub for a help file naming 
> > > the driver which claims to support the hardware?
> > > 
> > > I'm not objection to the removal of the drivers, just noting that 
> > > identifying the new drivers can be made easier.
> > 
> > People compiling their own kernels aren't completely dumb - if you know 
> > about people having problems finding the right ALSA driver for their 
> > hardware, please name the concrete problems so that we can improve the 
> > description and/or help text of these ALSA options.
> 
> Real problem is that we can expect several "sound does not work anymore"
> because people doing "make oldconfig" will get no warning at all about
> the removed options. Remember people complaining about keyboard not working ?

There already were two kernel releases where people had to say
explicitely "yes" to "Obsolete OSS drivers" with a quite clear help text
for getting these OSS drivers.

And did you complain when all the SATA options were renamed in 2.6.19
without any warnings in previous kernels and far more user-visible 
effects than some obsolete OSS drivers (and no driver for your hard 
disk even prevents booting)?

Or about the mess with the mes with the netfilter options when upgrading 
from 2.6.19 to 2.6.20?

If you didn't, this is the wrong patch to start complaining about...

> Perhaps the real problem is more Kconfig than OSS, but it would be fine if
> we found a solution to enumerate the list of options which have been removed
> when they do their make oldconfig.

Printing won't help - there are two many options (some even not user 
visible) that disappear with each kernel release.

> Regards,
> Willy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

