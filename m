Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbYC1VGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbYC1VGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 17:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbYC1VGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 17:06:46 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52146 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046AbYC1VGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 17:06:45 -0400
Date: Fri, 28 Mar 2008 23:06:43 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Brownell <david-b@pacbell.net>
Cc: Mark Lord <lkml@rtr.ca>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rtc-linux@googlegroups.com, David Miller <davem@davemloft.net>
Subject: Re: Kconfig RTC selection (was: 2.6.25-rc7: Ugh.)
Message-ID: <20080328210643.GJ32200@cs181133002.pp.htv.fi>
References: <20080327160700.GB828@suse.de> <200803280249.42193.david-b@pacbell.net> <47ECF70A.2060600@rtr.ca> <200803281304.39022.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803281304.39022.david-b@pacbell.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 01:04:38PM -0700, David Brownell wrote:
> [ CC's trimmed a bit ]
> 
> On Friday 28 March 2008, Mark Lord wrote:
> > > +# These legacy RTC drivers just cause too many conflicts with the generic
> > > +# RTC framework ... let's not even try to coexist any more.
> > ...
> > 
> > Thanks, David.  Could you perhaps also update the option descriptions
> > to clearly indicate which set of RTCs are the new ones, and which are
> > the old ones that are going away someday?
> 
> Hmm, I thought that would be clear from context.
> "These" (drivers/char) legacy RTC drivers (old),
> vs generic RTC framework (toplevel driver Kconfig).
> 
> Admittedly the *previous* Kconfig was troublesome,
> at the UI level (vs. those comments outside the GUI).
> 
> 
> A more general issue seems to be what to do with
> those legacy RTC drivers.  Few of them seem to
> have maintainers.  I don't want to own them, and
> I doubt Alessandro does either.  If their Kconfig
> is going to change, I'd rather just see them all
> flagged as deprecated ... with plans to delete them.
> 
> The RTCs in question being:
> 
>   "RTC" ... replaced by new "rtc-cmos"
> 	--> ready to deprecate now ?

The only reason against killing it immediately seems to be SND_RTCTIMER.

>   "JS_RTC" ... a SPARC32 thing
> 	--> bug?? no "js-rtc.c" in the tree!  patch sent

Where's the bug?
js-rtc is built from rtc.c

>...
>   "DS1302" ... M32R-specific, "rtc-ds1302" should replace it
> 	--> ready to deprecate now?
>...

Kconfig currently offers rtc-ds1302 only for an sh platform...

> - Dave

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

