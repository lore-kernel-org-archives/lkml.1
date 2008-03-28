Return-Path: <linux-kernel-owner+w=401wt.eu-S1758382AbYC1Wg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382AbYC1Wg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 18:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbYC1Wgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 18:36:50 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55997 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911AbYC1Wgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 18:36:49 -0400
Date: Sat, 29 Mar 2008 00:36:47 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Brownell <david-b@pacbell.net>
Cc: Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, rtc-linux@googlegroups.com,
       David Miller <davem@davemloft.net>
Subject: Re: Kconfig RTC selection (was: 2.6.25-rc7: Ugh.)
Message-ID: <20080328223647.GM32200@cs181133002.pp.htv.fi>
References: <20080327160700.GB828@suse.de> <200803281445.08025.david-b@pacbell.net> <20080328215913.GL32200@cs181133002.pp.htv.fi> <200803281518.36139.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200803281518.36139.david-b@pacbell.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 03:18:35PM -0700, David Brownell wrote:
> On Friday 28 March 2008, Adrian Bunk wrote:
> 
> > > > grep for CONFIG_SUN_MOSTEK_RTC and you'll get the point.
> > > 
> > > Right:  it doesn't mention JS_RTC at all.  Whatever is up
> > > with that stuff, it's broken.
> > 
> > You miss the point, the point is:
> >   drivers/sbus/char/Makefile:obj-$(CONFIG_SUN_MOSTEK_RTC) += rtc.o
> > 
> > Two modules with the same name in one build are not allowed.
> 
> It gets uglier and uglier.  So if that abortion is really
> needed, it'd make more sense to rename the MOSTEK code.
> If that's not fixed, its Kconfig should mention needing
> the JS_RTC thing instead of the "real" legacy rtc.c ...

The Mostek code does not need drivers/char/rtc.c

JS_RTC is only needed for some unusual sparc machines.

> Glad I got rid of my JavaStation ages ago, but I liked
> the idea of having a real builtin coffee cup holder.  :)
>...

I'm not sure, but the JavaStation might actually be one of these unusual 
machines...

> - Dave

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

