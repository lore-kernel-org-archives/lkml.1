Return-Path: <linux-kernel-owner+w=401wt.eu-S1762354AbYEBJBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762354AbYEBJBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 05:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757726AbYEBJBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 05:01:41 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55157 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164AbYEBJBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 05:01:40 -0400
Date: Fri, 2 May 2008 12:00:49 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RFC: starting a kernel-testers group for newbies
Message-ID: <20080502090049.GC2003@cs181133002.pp.htv.fi>
References: <200804302136.58005.rjw@sisk.pl> <20080430131537.1f7a0914.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org> <20080501003125.GM29330@cs181133002.pp.htv.fi> <20080430000338.50548884@infradead.org> <20080501113038.GW29330@cs181133002.pp.htv.fi> <20080430072013.7c3b30b1@infradead.org> <20080501132159.GC29330@cs181133002.pp.htv.fi> <20080501084919.8ac6dbdd.akpm@linux-foundation.org> <20080430181338.6180a972@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080430181338.6180a972@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 06:13:38PM -0700, Arjan van de Ven wrote:
> On Thu, 1 May 2008 08:49:19 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > Granted that compared to x86 there's not a sizable portion of users 
> > > crazy enough to run Linux on powerpc machines...
> > 
> > Another fallacy which Arjan is pushing (even though he doesn't appear
> > to have realised it) is "all hardware is the same".
> 
> no I'm pushing "some classes of hardware are much more popular/relevant
> than others".

"popular/relevant" is hard to define.

E.g. if we'd go after "popular" we should only keep architectures like 
ARM and x86 and ditch architectures like ia64 and s390 that have puny 
userbases.

And how would you define "relevant"?

> > Well, it isn't.  And most of our bugs are hardware-specific.  So, I'd
> > venture, most of our bugs don't affect most people.  So, over time, by
> > Arjan's "important to enough people" observation we just get more and
> > more and more unfixed bugs.
> 
> I did not say "most people". I believe "most people" aren't hitting
> bugs right now (or there would be a lot more screaming).
> What I do believe is that *within the bugs that hit*, even the hardware
> specific ones, there's a clear prioritization by how many people hit
> the bug (or have the hardware in general).

If your "or have the hardware in general" is meant seriously you have to
convince people that ARM must become a very high priority.

No matter whether one supports your "there's a clear prioritization" 
view or not it anyway doesn't currently work since the areas covered by 
people testing -rc kernels don't even remotely map the most popular 
hardware in the field.

> > And I believe this effect has been occurring.
> 
> > And please stop regaling us with this kerneloops.org stuff.  It just
> > isn't very interesting, useful or representative when considering the
> > whole problem.  Very few kernel bugs result in a trace, and when they
> > do they are usually easy to fix and, because of this, they will get
> > fixed, often quickly.  I expect
> > netdevwatchdogeth0transmittimedout.org would tell a different story.
> 
> now that's a fallacy of your own.. if you care about that one, it's 1)
> trivial to track and/or 2) could contain a WARN_ON_ONCE(), at which
> point it's automatically tracked. (and more useful information I
> suspect, since it suddenly has a full backtrace including driver info
> in it)
> By your argument we should work hard to make sure we're better at
> creating traces for cases we detect something goes wrong.
> (I would not argue against that fwiw)
>...

kerneloops.org catches the easiest to solve bugs (there's a trace) and 
helps in getting them fixed.

That's a very good thing.

And if we get more bugs into this easy to resolve state that would be 
even better.

But it's only a small part of the complete picture of incoming bug 
reports.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

