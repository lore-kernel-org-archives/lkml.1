Return-Path: <linux-kernel-owner+w=401wt.eu-S932938AbYD3UVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbYD3UVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759052AbYD3UU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:20:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46202 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbYD3UU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:20:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Slow DOWN, please!!!
Date: Wed, 30 Apr 2008 22:20:35 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, jirislaby@gmail.com
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <20080430130058.6d3a74ff.akpm@linux-foundation.org>
In-Reply-To: <20080430130058.6d3a74ff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804302220.36398.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 30 of April 2008, Andrew Morton wrote:
> On Wed, 30 Apr 2008 21:36:57 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Wednesday, 30 of April 2008, David Miller wrote:
> > > 
> > > This is starting to get beyond frustrating for me.
> > > 
> > > Yesterday, I spent the whole day bisecting boot failures
> > > on my system due to the totally untested linux/bitops.h
> > > optimization, which I fully analyzed and debugged.
> > > 
> > > Today, I had hoped that I could get some work done of my
> > > own, but that's not the case.
> > > 
> > > Yet another bootup regression got added within the last 24
> > > hours.
> > > 
> > > I don't mind fixing the regression or two during the merge
> > > window but THIS IS ABSOLUTELY, FUCKING, REDICULIOUS!
> > > 
> > > The tree breaks every day, and it's becomming an extremely
> > > non-fun environment to work in.
> > > 
> > > We need to slow down the merging, we need to review things
> > > more, we need people to test their fucking changes!
> > 
> > Well, I must say I second that.
> 
> ooh, fun thread.
> 
> One of the main reasons for -mm (probably _the_ main reason) is to weed out
> other-developer-impacting regressions before they hit mainline and, umm,
> affect developers.
> 
> But there are implementation problems:
> 
> a) developers aren't testing -mm enough
> 
> b) -mm releases have become too slow, and (hence) too unstable
> 
> c) people are slamming changes into mainline which have never been seen
>    in -mm.  Lots of changes.

Yeah.

> So here's how we're going to fix David's problem:
> 
> - Everyone gets their stuff into linux-next.
> 
> - Lots of people _test_ linux-next.  Just once a week.

For this to happen, let's make the mainline change slower than once a day
after the merge window.
 
> Those two steps will improve the merge-window chaos a lot.  Things will get
> better.

Not until we make a rule that nothing that didn't went through linux-next is
mergeable unless it's an obvious bugfix that has no side effects.
 
> The remaining open problem is what do we do about the shiny new code which
> is getting slammed into the merge window?
> 
> Well, it's very easy to tell whether code which appears in the merge window
> was present in linux-next.
> 
> Our first way of preventing people from shoving inadequately-cooked code
> into the merge window is suasion (aka flaming their titties off).  If that
> proves insufficient and if we still have a sufficiently large problem that
> we need to do something about it then sure, let's reevaluate.

OK

> But one thing at a time.  For the 2.6.27 release let us concentrte on two
> things
> 
> - get your stuff into linux-next
> 
> - test linux-next.
> 
> If merge-window stability is still a problem after that then let's revisit?

I'll see you in the analogous thread during the next merge window. ;-)
