Return-Path: <linux-kernel-owner+w=401wt.eu-S1752276AbXDQEO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbXDQEO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 00:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbXDQEO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 00:14:27 -0400
Received: from mx1.suse.de ([195.135.220.2]:34087 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbXDQEO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 00:14:26 -0400
Date: Tue, 17 Apr 2007 06:14:20 +0200
From: Nick Piggin <npiggin@suse.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Williams <pwil3058@bigpond.net.au>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417041420.GF25513@wotan.suse.de>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net> <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <1176782489.13059.15.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176782489.13059.15.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 06:01:29AM +0200, Mike Galbraith wrote:
> On Tue, 2007-04-17 at 05:40 +0200, Nick Piggin wrote:
> > On Tue, Apr 17, 2007 at 04:29:01AM +0200, Mike Galbraith wrote:
>  
> > > Yup, and progress _is_ happening now, quite rapidly.
> > 
> > Progress as in progress on Ingo's scheduler. I still don't know how we'd
> > decide when to replace the mainline scheduler or with what.
> > 
> > I don't think we can say Ingo's is better than the alternatives, can we?
> 
> No, that would require massive performance testing of all alternatives.
> 
> > If there is some kind of bakeoff, then I'd like one of Con's designs to
> > be involved, and mine, and Peter's...
> 
> The trouble with a bakeoff is that it's pretty darn hard to get people
> to test in the first place, and then comes weighting the subjective and
> hard performance numbers.  If they're close in numbers, do you go with
> the one which starts the least flamewars or what?

I don't know how you'd do it. I know you wouldn't count people telling you
how good they are (getting people to tell you how bad they are, and whether
others do better in a given situation might be slightly move viable).

But we have to choose somehow. I'd hope that is going to be based solely
on the results and technical properties of the code, so... if we were to
somehow determine that the results are exactly the same, we'd go for the
the simpler one, wouldn't we?


> > Maybe the progress is that more key people are becoming open to the idea
> > of changing the scheduler.
> 
> Could be.  All was quiet for quite a while, but when RSDL showed up, it
> aroused enough interest to show that scheduling woes is on folks radar.

Well I know people have had woes with the scheduler for ever (I guess that
isn't going to change :P). I think people generally lost a bit of interest
in trying to improve the situation because of the upstream problem.
