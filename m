Return-Path: <linux-kernel-owner+w=401wt.eu-S1758387AbYE0TVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387AbYE0TVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 15:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755693AbYE0TVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 15:21:36 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:60196 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480AbYE0TVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 15:21:36 -0400
Date: Tue, 27 May 2008 22:18:48 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       vatsa <vatsa@in.ibm.com>
Subject: Re: [RFC: 2.6 patch] let GROUP_SCHED depend on BROKEN
Message-ID: <20080527191848.GB11310@cs181133002.pp.htv.fi>
References: <20080527085830.GA20938@cs181133002.pp.htv.fi> <1211888849.12349.28.camel@twins> <20080527130828.GC20938@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805271527060.3295@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805271527060.3295@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 07:30:42PM +0200, Thomas Gleixner wrote:
> On Tue, 27 May 2008, Adrian Bunk wrote:
> > On Tue, May 27, 2008 at 01:47:29PM +0200, Peter Zijlstra wrote:
> > >...
> > > FYI your attitude in the past few weeks is getting on my nerves - you
> > > act all self important but have not made a single contribution to the
> > > kernel above the level of a janitor-newbie.
> > 
> > Not a single contribution to the kernel above the level of a 
> > janitor-newbie?
> > 
> > http://article.gmane.org/gmane.linux.kernel/676733
> > http://lkml.org/lkml/2008/5/14/498
> > http://lkml.org/lkml/2008/4/28/561
> > ...
> 
> Adrian, do you really believe that the above is substantial ? 

Whether they are substantial one might dispute, but in my opinion these 
are "above the level of a janitor-newbie".

E.g. how many newbies on the janitors list know how to fix bugs 
involving complicated kconfig dependencies (like bools mixed with 
tristates and selects)?

>...
> Following your book-keeper logic we have to mark HIBERNATE, SUSPEND,
> NOHZ, HIGHRES, TSC and tons of other things BROKEN as well.

My personal opinion (I did put an RFC into the subject) is that 
something that gets offered to kconfig users must be worth it.

If it would bring real benefits in it's current state or if it was just
the usual shaking-out of bugs after merging (I remember NOHZ caused
quite a few issues, and also recent stuff like PAT or snd_pcsp caused
problems that had to be fixed) problems were kind of unavoidable.

And e.g. both HIBERNATE/SUSPEND and GROUP_SCHED have some history of 
causing regressions and resulting in people debugging and bisecting for 
finding the cause of some regression (even Rafael spent some time 
bisecting a 2.6.24-git group scheduling regression).

For HIBERNATE/SUSPEND the value for users is clear.
And no matter how many regressions it causes it is therefore worth it.

But how big is the value of GROUP_SCHED in it's current state for users?

And Peter said "group scheduling is horribly complex and was never 
feature complete", so regular breakages are kind of expected until
it is feature complete.

>...
> > Awaiting your apology
> 
> For what ? For telling the truth ?

If someone says most of my contributions are janitorial stuff that's 
the truth.

But Peter claiming not a single contribution I did was above the level 
of a janitor-newbie is not the truth.

> Thanks,
> 
> 	tglx

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

