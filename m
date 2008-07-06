Return-Path: <linux-kernel-owner+w=401wt.eu-S1758167AbYGFUOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbYGFUOk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 16:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbYGFUOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 16:14:32 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:43199 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbYGFUOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 16:14:31 -0400
Date: Sun, 6 Jul 2008 23:13:46 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v2] gpiolib: Allow user-selection
Message-ID: <20080706201346.GG21669@cs181140183.pp.htv.fi>
References: <200807031233.04229.mb@bu3sch.de> <20080706195212.GF21669@cs181140183.pp.htv.fi> <200807062201.25194.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200807062201.25194.mb@bu3sch.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2008 at 10:01:24PM +0200, Michael Buesch wrote:
> On Sunday 06 July 2008 21:52:12 Adrian Bunk wrote:
>...
> So well. I'm not sure what you're talking about. Care to make
> a better helptext?

Sorry, the problem wasn't the help text but me being blind.

Please ignore my comment.

> > > --- linux-next.orig/arch/arm/configs/am200epdkit_defconfig	2008-07-03 11:31:05.000000000 +0200
> > > +++ linux-next/arch/arm/configs/am200epdkit_defconfig	2008-07-03 11:36:14.000000000 +0200
> > > @@ -668,7 +668,7 @@
> > >  #
> > >  # CONFIG_SPI is not set
> > >  # CONFIG_SPI_MASTER is not set
> > > -CONFIG_HAVE_GPIO_LIB=y
> > > +CONFIG_ARCH_REQUIRE_GPIOLIB=y
> > >...
> > 
> > Please don't do this kind of defconfig updates - it doesn't bring any
> > advantage but can create tons of patch conflicts.
> > 
> > The next time a defconfig gets updated it will anyway automatically be
> > fixed, and for defconfigs that aren't updated it doesn't create any
> > problems to keep them as they are today until they might one day get
> > updated.
> 
> So will the auto-regenerated defconfig result in CONFIG_ARCH_REQUIRE_GPIOLIB=y
> or CONFIG_ARCH_REQUIRE_GPIOLIB=n? I thought it would result in =n, as the
> option defaults to n. So I changed all defconfigs.
> 
> (I think these (sub)archs should "select" the option in their Kconfig, but I
> didn't want to go down that way).

A defconfig is just a normal .config and cannot override any dependencies.

CONFIG_ARCH_REQUIRE_GPIOLIB is not user visible and defaults to n, so if 
no option select's it then even using a defconfig that has it enabled 
will result in a .config that has it disabled.

> Greetings Michael.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

