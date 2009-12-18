Return-Path: <linux-kernel-owner+w=401wt.eu-S1753065AbZLRK4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbZLRK4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 05:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbZLRK4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 05:56:16 -0500
Received: from fom01.emnet.dk ([89.249.14.84]:47195 "EHLO fom01.emnet.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbZLRK4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 05:56:15 -0500
X-AuditID: 59f90e54-b7bd7ae000001243-df-4b2b5fcd74e3
Subject: Re: x264 benchmarks BFS vs CFS
From: Kasper Sandberg <lkml@metanurb.dk>
To: tfjellstrom@shaw.ca
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200912171422.54836.tfjellstrom@shaw.ca>
References: <1261042383.14314.0.camel@localhost>
	 <20091217105316.GB26010@elte.hu> <1261047618.14314.6.camel@localhost>
	 <200912171422.54836.tfjellstrom@shaw.ca>
Content-Type: text/plain
Date: Fri, 18 Dec 2009 11:56:09 +0100
Message-Id: <1261133769.14314.35.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAARIa7Dg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 14:22 -0700, Thomas Fjellstrom wrote:
> On Thu December 17 2009, Kasper Sandberg wrote:
> > On Thu, 2009-12-17 at 11:53 +0100, Ingo Molnar wrote:
> > > * Jason Garrett-Glaser <darkshikari@gmail.com> wrote:
> > > > On Thu, Dec 17, 2009 at 1:33 AM, Kasper Sandberg <lkml@metanurb.dk> 
> wrote:
> > > > > well well :) nothing quite speaks out like graphs..
> > > > >
> > > > > http://doom10.org/index.php?topic=78.0
> > > > >
> > > > >
> > > > >
> > > > > regards,
> > > > > Kasper Sandberg
> > > >
> > > > Yeah, I sent this to Mike a bit ago.  Seems that .32 has basically
> > > > tied it--and given the strict thread-ordering expectations of x264,
> > > > you basically can't expect it to do any better, though I'm curious
> > > > what's responsible for the gap in "veryslow", even with SCHED_BATCH
> > > > enabled.
> > > >
> > > > The most odd case is that of "ultrafast", in which CFS immediately
> > > > ties BFS when we enable SCHED_BATCH.  We're doing some further
> > > > testing to see exactly
> > 
> > Thats kinda besides the point.
> > 
> > all these tunables and weirdness is _NEVER_ going to work for people.
> > 
> > now forgive me for being so blunt, but for a user, having to do
> > echo x264 > /proc/cfs/gief_me_performance_on_app
> > or
> > echo some_benchmark > x264 > /proc/cfs/gief_me_performance_on_app
> > 
> > just isnt usable, bfs matches, even exceeds cfs on all accounts, with
> > ZERO user tuning, so while cfs may be able to nearly match up with a ton
> > of application specific stuff, that just doesnt work for a normal user.
> > 
> > not to mention that bfs does this whilst not loosing interactivity,
> > something which cfs certainly cannot boast.
> > 
> > <snip>
> 
> Strange, I seem to recall that BFS needs you to run apps with some silly 
> schedtool program to get media apps to not skip while doing other tasks. (I 
> don't have to tweak CFS at all)
You recall incorrectly
> 
> > > Thanks,
> > >
> > > 	Ingo
> 
> 
> 

