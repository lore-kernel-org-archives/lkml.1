Return-Path: <linux-kernel-owner+w=401wt.eu-S1751832AbZLRLlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbZLRLlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 06:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbZLRLlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 06:41:51 -0500
Received: from mail.gmx.net ([213.165.64.20]:50120 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751022AbZLRLlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 06:41:40 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+MXHsheSKMqF4W3k8Y8kjqoyDcLsfQHocfokd3yI
	S/SezN6MiMugij
Subject: Re: x264 benchmarks BFS vs CFS
From: Mike Galbraith <efault@gmx.de>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Garrett-Glaser <darkshikari@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1261133658.14314.33.camel@localhost>
References: <1261042383.14314.0.camel@localhost>
	 <28f2fcbc0912170242r6d93dfb1j337558a829e21a75@mail.gmail.com>
	 <20091217105316.GB26010@elte.hu>  <1261047618.14314.6.camel@localhost>
	 <1261056647.10838.26.camel@marge.simson.net>
	 <1261133658.14314.33.camel@localhost>
Content-Type: text/plain
Date: Fri, 18 Dec 2009 12:41:36 +0100
Message-Id: <1261136496.15591.0.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 11:54 +0100, Kasper Sandberg wrote:
> On Thu, 2009-12-17 at 14:30 +0100, Mike Galbraith wrote:
> > On Thu, 2009-12-17 at 12:00 +0100, Kasper Sandberg wrote:
> > > On Thu, 2009-12-17 at 11:53 +0100, Ingo Molnar wrote:
> > > > * Jason Garrett-Glaser <darkshikari@gmail.com> wrote:
> > > > 
> > > > > On Thu, Dec 17, 2009 at 1:33 AM, Kasper Sandberg <lkml@metanurb.dk> wrote:
> > > > > > well well :) nothing quite speaks out like graphs..
> > > > > >
> > > > > > http://doom10.org/index.php?topic=78.0
> > > > > >
> > > > > >
> > > > > >
> > > > > > regards,
> > > > > > Kasper Sandberg
> > > > > 
> > > > > Yeah, I sent this to Mike a bit ago.  Seems that .32 has basically tied 
> > > > > it--and given the strict thread-ordering expectations of x264, you basically 
> > > > > can't expect it to do any better, though I'm curious what's responsible for 
> > > > > the gap in "veryslow", even with SCHED_BATCH enabled.
> > > > > 
> > > > > The most odd case is that of "ultrafast", in which CFS immediately ties BFS 
> > > > > when we enable SCHED_BATCH.  We're doing some further testing to see exactly 
> > > 
> > > Thats kinda besides the point.
> > > 
> > > all these tunables and weirdness is _NEVER_ going to work for people.
> > 
> > Fact is, it is working for a great number of people, the vast majority
> > of whom don't even know where the knobs are, much less what they do. 
> but not as great as it could be :)
> 
> > 
> > > now forgive me for being so blunt, but for a user, having to do
> > > echo x264 > /proc/cfs/gief_me_performance_on_app
> > > or
> > > echo some_benchmark > x264 > /proc/cfs/gief_me_performance_on_app
> > 
> > Theatrics noted.
> > 
> > > just isnt usable, bfs matches, even exceeds cfs on all accounts, with
> > > ZERO user tuning, so while cfs may be able to nearly match up with a ton
> > > of application specific stuff, that just doesnt work for a normal user.
> > 
> > Seems you haven't done much benchmarking.  BFS has strengths as well as
> > weaknesses, all schedulers do.
> yeah, BFS just has more strengths and fewer weaknesses than CFS :)
> > 
> > > not to mention that bfs does this whilst not loosing interactivity,
> > > something which cfs certainly cannot boast.
> > 
> > Not true.  I sent Con hard evidence of a severe problem area wrt
> > interactivity, and hard numbers showing other places where BFS needs
> > some work.  But hey, if BFS blows your skirt up, use it and be happy.
> Theatrics noted.
> 
> As for your point, well.. as far as i have heard, all you've come up
> with is COMPLETELY WORTHLESS use cases which nobody is ever EVAR going
> to do, and thus irellevant

Goodbye troll.

*PLONK*

