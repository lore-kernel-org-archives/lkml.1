Return-Path: <linux-kernel-owner+w=401wt.eu-S1754402AbYECUZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbYECUZc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 16:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbYECUZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 16:25:24 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:36471 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbYECUZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 16:25:24 -0400
Date: Sat, 3 May 2008 23:24:16 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
Message-ID: <20080503202416.GR5838@cs181133002.pp.htv.fi>
References: <20080430200340.GA13757@elte.hu> <20080430170125.ZZRA012@mailhub.coreip.homeip.net> <20080430211317.GA24633@elte.hu> <20080430230100.GK29330@cs181133002.pp.htv.fi> <20080501025234.GE27574@elte.hu> <20080501115923.GX29330@cs181133002.pp.htv.fi> <20080503191445.GF5292@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080503191445.GF5292@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 09:14:45PM +0200, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@stusta.de> wrote:
> 
> > On Thu, May 01, 2008 at 04:52:34AM +0200, Ingo Molnar wrote:
> > > 
> > > * Adrian Bunk <bunk@kernel.org> wrote:
> > > 
> > > > I would really appreciate it if you could send the error message 
> > > > and the .config but not quick kconfig patches that are often wrong 
> > > > and that you try to push through the maintainers as you tried 
> > > > here.
> > > 
> > > hey, sorry about invading your turf of trivial patches ;) I dont see 
> > > it as a problem that the thought process and the initial patch is 
> > > incomplete and ad-hoc. My preference is to work with people out in 
> > > the open, even on trivial issues. Dmitry is a capable maintainer who 
> > > understands his code very well and he'll resist me if i'm full of 
> > > it. Just like i resisted you when you were full of it. That's what 
> > > maintainers do, their job is to know their code.
> > > 
> > > And, occasionally, as in this case, i might end up being faced with 
> > > a bug in the code i maintain ;)
> > 
> > You completely miss my point.
> > 
> > You wrongly (and loudly) blamed Dmitry for something you broke 
> > yourself.
> 
> i didnt. Read what i wrote:
> 
> || no, you are wrong, read the current Kconfig rules again. If the user 
> || can create a .config that does not build, it is driver breakage. It 
> || always was, and has been in the past 15 years.
> ||
> || Kconfig might be extended to make dependencies easier to manage for 
> || developers but until that is implemented you have to craft your 
> || driver's dependencies with the current tools in a way that doesnt 
> || break the build.
> 
> and that's exactly what happens with Roman's patch: a Kconfig subsystem 
> design bug (its inability to properly propagate the dependencies of 
> select's) is worked around in the driver space: by the LEDS_CORE driver 
> config introduction and no user-visible.
> 
> Roman's patch is obviously cleaner than my hack (i just fixed a single 
> instantiation of the problem, while he changed the LEDS driver 
> dependency structure), but it's still a workaround for a Kconfig 
> subsystem bug and the same problem could reoccur elsewhere. It could hit 
> anytime dual dependencies are introduced in a driver accidentally.

Ingo, perhaps it helps if I put it in caps:

YOU TRIED TO PUSH AN INPUT PATCH FOR AN X86 BUG.

Roman's patch is better than adding a select, but your patch would have 
added the select in the completely wrong subsystem.

Why can't you admit the patch you tried to push was wrong?

> As Sam said it, fixing that Kconfig design bug would be "nice" - but 
> unfortunately the Kconfig subsystem is not actively developed anymore. 

Roman is still active.

> Would you like to volunteer for that? It would be a _very_ useful 
> contribution. One such fix could avoid hundreds or even thousands of 
> trivial problems in the future - it could avoid having to make hundreds 
> or thousands of trivial patches in the future.

Different to you I actually have some basic understanding how kconfig 
works.

I'm not even sure the semantics of "select follows dependencies" 
would actually be better than what we have today.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

