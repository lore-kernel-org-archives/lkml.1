Return-Path: <linux-kernel-owner+w=401wt.eu-S1759110AbYC1V7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110AbYC1V7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 17:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756517AbYC1V7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 17:59:16 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:57844 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757383AbYC1V7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 17:59:15 -0400
Date: Fri, 28 Mar 2008 23:59:13 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Brownell <david-b@pacbell.net>
Cc: Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, rtc-linux@googlegroups.com,
       David Miller <davem@davemloft.net>
Subject: Re: Kconfig RTC selection (was: 2.6.25-rc7: Ugh.)
Message-ID: <20080328215913.GL32200@cs181133002.pp.htv.fi>
References: <20080327160700.GB828@suse.de> <200803281423.46981.david-b@pacbell.net> <20080328213349.GK32200@cs181133002.pp.htv.fi> <200803281445.08025.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803281445.08025.david-b@pacbell.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 02:45:07PM -0700, David Brownell wrote:
> On Friday 28 March 2008, Adrian Bunk wrote:
> > > > >   "JS_RTC" ... a SPARC32 thing
> > > > >       --> bug?? no "js-rtc.c" in the tree!  patch sent
> > > > 
> > > > Where's the bug?
> > > > js-rtc is built from rtc.c
> > > 
> > > In which case, just enable rtc.c ... a "egrep -r 'JS_RTC|js-rtc'"
> > > shows that it looks pretty pointless.
> > >...
> > 
> > grep for CONFIG_SUN_MOSTEK_RTC and you'll get the point.
> 
> Right:  it doesn't mention JS_RTC at all.  Whatever is up
> with that stuff, it's broken.

You miss the point, the point is:
  drivers/sbus/char/Makefile:obj-$(CONFIG_SUN_MOSTEK_RTC) += rtc.o

Two modules with the same name in one build are not allowed.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

