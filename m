Return-Path: <linux-kernel-owner+w=401wt.eu-S1765395AbZLQVW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765395AbZLQVW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 16:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765360AbZLQVW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 16:22:57 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:14619 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765357AbZLQVW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 16:22:56 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=w4iE+TBsmj5y1WloLYF40w==:17 a=pGLkceISAAAA:8 a=x1oE7adPAAAA:8
 a=z7mH6uBVGvqxVWCMyBsA:9 a=QaWZU7upW0whEbWhz8EA:7
 a=5SeBxeHEhDFbtPf2gDi3gwj4414A:4 a=MSl-tDqOz04A:10 a=TE5l_RiVrn7TzTvB:21
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-kernel@vger.kernel.org
Subject: Re: x264 benchmarks BFS vs CFS
Date: Thu, 17 Dec 2009 14:22:54 -0700
User-Agent: KMail/1.12.4 (Linux/2.6.31-1-amd64; KDE/4.3.4; x86_64; ; )
References: <1261042383.14314.0.camel@localhost> <20091217105316.GB26010@elte.hu> <1261047618.14314.6.camel@localhost>
In-Reply-To: <1261047618.14314.6.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912171422.54836.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu December 17 2009, Kasper Sandberg wrote:
> On Thu, 2009-12-17 at 11:53 +0100, Ingo Molnar wrote:
> > * Jason Garrett-Glaser <darkshikari@gmail.com> wrote:
> > > On Thu, Dec 17, 2009 at 1:33 AM, Kasper Sandberg <lkml@metanurb.dk> 
wrote:
> > > > well well :) nothing quite speaks out like graphs..
> > > >
> > > > http://doom10.org/index.php?topic=78.0
> > > >
> > > >
> > > >
> > > > regards,
> > > > Kasper Sandberg
> > >
> > > Yeah, I sent this to Mike a bit ago.  Seems that .32 has basically
> > > tied it--and given the strict thread-ordering expectations of x264,
> > > you basically can't expect it to do any better, though I'm curious
> > > what's responsible for the gap in "veryslow", even with SCHED_BATCH
> > > enabled.
> > >
> > > The most odd case is that of "ultrafast", in which CFS immediately
> > > ties BFS when we enable SCHED_BATCH.  We're doing some further
> > > testing to see exactly
> 
> Thats kinda besides the point.
> 
> all these tunables and weirdness is _NEVER_ going to work for people.
> 
> now forgive me for being so blunt, but for a user, having to do
> echo x264 > /proc/cfs/gief_me_performance_on_app
> or
> echo some_benchmark > x264 > /proc/cfs/gief_me_performance_on_app
> 
> just isnt usable, bfs matches, even exceeds cfs on all accounts, with
> ZERO user tuning, so while cfs may be able to nearly match up with a ton
> of application specific stuff, that just doesnt work for a normal user.
> 
> not to mention that bfs does this whilst not loosing interactivity,
> something which cfs certainly cannot boast.
> 
> <snip>

Strange, I seem to recall that BFS needs you to run apps with some silly 
schedtool program to get media apps to not skip while doing other tasks. (I 
don't have to tweak CFS at all)

> > Thanks,
> >
> > 	Ingo



-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
