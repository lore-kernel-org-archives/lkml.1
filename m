Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbYECVZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbYECVZg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbYECVZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:25:28 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:38679 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbYECVZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:25:28 -0400
Date: Sun, 4 May 2008 00:24:29 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
Message-ID: <20080503212429.GT5838@cs181133002.pp.htv.fi>
References: <20080430200340.GA13757@elte.hu> <20080430170125.ZZRA012@mailhub.coreip.homeip.net> <20080430211317.GA24633@elte.hu> <20080430230100.GK29330@cs181133002.pp.htv.fi> <20080501025234.GE27574@elte.hu> <20080501115923.GX29330@cs181133002.pp.htv.fi> <20080503191445.GF5292@elte.hu> <20080503202416.GR5838@cs181133002.pp.htv.fi> <20080503210300.GA10979@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080503210300.GA10979@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 11:03:00PM +0200, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
>...
> > > As Sam said it, fixing that Kconfig design bug would be "nice" - but 
> > > unfortunately the Kconfig subsystem is not actively developed 
> > > anymore.
> > 
> > Roman is still active.
> 
> great, does this mean we'll see fixes for select's misbehavior, along 
> the lines of Sam's suggestions?

In the case of the problem here it would have turned one problem into 
another, and Roman's patch is the correct solution no matter whether 
you change the semantics of select or not.

> at minimum a warning needs to be emitted by the kconfig tool if such 
> incomplete selects are used. I've stopped counting the number of times 
> such issues have broken the build and have held up kernel development. 

It might held up your randconfig compiles.

Actual kernel development isn't much affected.

Before you started your randconfig builds and sending (often buggy) 
kconfig patches like crazy there wasn't a problem (and Toralf's 
randconfig builds already catched these problems in the past).

> All the information is already in the Kconfig files for the kconfig 
> tool/subsystem to make an intelligent decision. It's just not fully 
> used, and the burden of fixing these problems is pushed back to the 
> developers who create the Kconfig files.

That's nonsense.

Describe the semantics you want for "bool selects tristate", and no 
matter which you choose I'll tell you a case where it breaks.

You've shown with another of your recent kconfig patches that you don't 
even understand how "depends on" works, and you are _very_ far from 
making claims like the one you just made.

Please accept the fact that while I'm (at least at the moment) not 
qualified to make any deeply technical remarks on e.g. the CPU scheduler 
or x86 details, you are (at least at the moment) not qualified to make 
any deeply technical remarks on kconfig.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

