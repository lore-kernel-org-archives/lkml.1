Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbZA3KXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbZA3KXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbZA3KS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:18:27 -0500
Received: from mout.perfora.net ([74.208.4.195]:54076 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417AbZA3KS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:18:26 -0500
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
	scheduling
From: Nathanael Hoyle <nhoyle@hoyletech.com>
To: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1233306223.4495.159.camel@laptop>
References: <1233294584.28741.2.camel@localhost>
	 <1233305433.4495.154.camel@laptop>  <1233306030.17301.36.camel@localhost>
	 <1233306223.4495.159.camel@laptop>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 05:18:20 -0500
Message-Id: <1233310700.7816.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/gW7+GHE+LHX98jVs9NqEcs0v4PZRkQwTVIAI
 m95n7sEwhAgQW8fZnDVHklDu+hj8Ju/4okItIgXVv1HCbXEibc
 lVsOUdKWmGRlEJ2OfJ6elZnEMs1lWuk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 10:03 +0100, Peter Zijlstra wrote:
> On Fri, 2009-01-30 at 04:00 -0500, Nathanael Hoyle wrote:
> > On Fri, 2009-01-30 at 09:50 +0100, Peter Zijlstra wrote:
> > > On Fri, 2009-01-30 at 00:49 -0500, Nathanael Hoyle wrote:
> > > > 
> > > > 1) Is my problem 'expected' based on others' understanding of the
> > > > current design of the scheduler, or do I have a one-off problem to
> > > > troubleshoot here?
> > > 
> > > What kernel are you running (or did my eye glance over that detail in
> > > your longish email) ?
> > > 
> > 
> > I didn't include it, I should have:
> > 
> > $ uname -a
> > Linux nightmare 2.6.27-gentoo-r7-nhoyle #2 SMP Wed Jan 28 19:04:37 EST
> > 2009 x86_64 Intel(R) Core(TM)2 Quad CPU Q9450 @ 2.66GHz GenuineIntel
> > GNU/Linux
> 
> Ah, then please do as Mike suggested, try 28.2 or 29-rc3, if you still
> have trouble with those, please let us know.
> 

Ok, I'm now running:

Linux nightmare 2.6.28.2-nhoyle #1 SMP Fri Jan 30 04:50:03 EST 2009
x86_64 Intel(R) Core(TM)2 Quad CPU Q9450 @ 2.66GHz GenuineIntel
GNU/Linux

Initial conclusion is that whatever defects were corrected (non
SCHED_IDLE specific defects that is), the newer kernel version does the
trick.  Video playback is as smooth as ever when running foldingathome
at simple nice 19 priority.

I am not sure that I can perceive a difference so far in testing that
versus using SCHED_IDLE. I will probably continue to use the latter
anyhow, as that represents more accurately the semantics that I'm trying
to achieve.

I had previously tried upgrading my kernel version in case that would
fix it, but even the latest available kernels in the portage tree for
Gentoo are older than 2.6.28.2. The 'stable' ones were all still 2.6.27.
I have had some concerns about Gentoo as a distro for some time, but it
still allows me more freedom and perfomance optimization than do most
other distros.  I'll leave that at that for now to avoid starting any
religous wars over distros.

Once I downloaded and built the latest vanilla 2.6.28.2 sources from
kernel.org though, everything seems improved, as mentioned above.

Thanks to each of you who responded for all the help. I will continue to
experiment over the next week or so and provide feedback if I see
anything further unusual, but so far things seem good.

-Nathanael

