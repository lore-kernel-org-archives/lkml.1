Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbYEALbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbYEALbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 07:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbYEALb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 07:31:26 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:57023 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbYEALbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 07:31:25 -0400
Date: Thu, 1 May 2008 14:30:38 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RFC: starting a kernel-testers group for newbies
Message-ID: <20080501113038.GW29330@cs181133002.pp.htv.fi>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <20080430131537.1f7a0914.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org> <20080501003125.GM29330@cs181133002.pp.htv.fi> <20080430000338.50548884@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080430000338.50548884@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 12:03:38AM -0700, Arjan van de Ven wrote:
> On Thu, 1 May 2008 03:31:25 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Wed, Apr 30, 2008 at 01:31:08PM -0700, Linus Torvalds wrote:
> > > 
> > > 
> > > On Wed, 30 Apr 2008, Andrew Morton wrote:
> > > > 
> > > > <jumps up and down>
> > > > 
> > > > There should be nothing in 2.6.x-rc1 which wasn't in 2.6.x-mm1!
> > > 
> > > The problem I see with both -mm and linux-next is that they tend to
> > > be better at finding the "physical conflict" kind of issues (ie the
> > > merge itself fails) than the "code looks ok but doesn't actually
> > > work" kind of issue.
> > > 
> > > Why?
> > > 
> > > The tester base is simply too small.
> > > 
> > > Now, if *that* could be improved, that would be wonderful, but I'm
> > > not seeing it as very likely.
> > > 
> > > I think we have fairly good penetration these days with the regular
> > > -git tree, but I think that one is quite frankly a *lot* less scary
> > > than -mm or -next are, and there it has been an absolutely huge
> > > boon to get the kernel into the Fedora test-builds etc (and I
> > > _think_ Ubuntu and SuSE also started something like that).
> > > 
> > > So I'm very pessimistic about getting a lot of test coverage before
> > > -rc1.
> > > 
> > > Maybe too pessimistic, who knows?
> > 
> > First of all:
> > I 100% agree with Andrew that our biggest problems are in reviewing
> > code and resolving bugs, not in finding bugs (we already have far too
> > many unresolved bugs).
> 
> I would argue instead that we don't know which bugs to fix first.
> We're never going to fix all bugs, and to be honest, that's ok.
>...

That might be OK.

But our current status quo is not OK:

Check Rafael's regressions lists asking yourself
"How many regressions are older than two weeks?" 

The kernel Bugzilla curerntly knows about 212 open regression bugs.
(And many more have not made it into Bugzilla.)

We have unmaintained and de facto unmaintained parts of the kernel where 
even issues that might be easy to fix don't get fixed.

>...
> So there's a few things we (and you / janitors) can do over time to get better data on what issues
> people hit: 
> 1) Get automated collection of issues more wide spread. The wider our net the better we know which
>    issues get hit a lot, and plain the more data we have on when things start, when they stop, etc etc.
>    Especially if you get a lot of testers in your project, I'd like them to install the client for easy reporting
>    of issues.
> 2) We should add more WARN_ON()s on "known bad" conditions. If it WARN_ON()'s, we can learn about it via
>    the automated collection. And we can then do the statistics to figure out which ones happen a lot.
> 3) We need to get persistent-across-reboot oops saving going; there's some venues for this

No disagreement on this, its just a different issue than our bug fixing 
problem.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

