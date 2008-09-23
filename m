Return-Path: <linux-kernel-owner+w=401wt.eu-S1751621AbYIWKPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbYIWKPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 06:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbYIWKPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 06:15:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47071 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbYIWKPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 06:15:02 -0400
Date: Tue, 23 Sep 2008 12:14:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Steigerwald <ms@teamix.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] CFS scheduler: documentation about scheduling policies
Message-ID: <20080923101444.GA6849@elte.hu>
References: <200809231101.41624.ms@teamix.de> <20080923091159.GE31189@elte.hu> <200809231153.04035.ms@teamix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809231153.04035.ms@teamix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Steigerwald <ms@teamix.de> wrote:

> Am Dienstag, 23. September 2008 schrieb Ingo Molnar:
> > * Martin Steigerwald <ms@teamix.de> wrote:
> > > The documentation about the CFS scheduler is scarse when it comes to
> > > scheduling policies. This patch adds a chapter about the scheduling
> > > policies it supports. Peter Zijlstra provided most of the information for
> > > it in
> > >
> > > http://marc.info/?l=linux-kernel&m=122210038326356&w=2
> > >
> > > This patch is based on 2.6.27-rc7.
> > >
> > > Signed-off-by: Martin Steigerwald <ms@teamix.de>
> >
> > looks good to me - but could you please do the patch against the latest
> > scheduler tree, which has already updated this file (and which made your
> > patch not apply cleanly):
> >
> >   http://people.redhat.com/mingo/tip.git/README
> 
> Should I use 
> 
> checkout -b tip-latest tip/master
> 
> as described in the README or tip/sched/devel or even something else?

tip/master should be fine - it has sched/devel integrated. I'll sort out 
any cross-topic impact.

> I am new to git. I know Bazaar quite well however, so I am not 
> compeltely new to DVCS.

the -tip tree, maintained by Thomas Gleixner, H. Peter Anvin and myself 
is a "forest of trees" based on Linus's very latest -git tree. Currently 
it's a collection of more than 180 topic trees. Most topic trees are 
based on upstream -git, some topic trees are based on each other and 
tip/master has them all integrated together.

there are a few main themes within -tip: tip/x86/* are all the currently 
active x86 topics - all changes that are for v2.6.28. tip/sched/* are 
the pending scheduler changes. tip/timers/* are timer changes, 
tip/tracing/* are tracing patches, etc.

Unless you are a high-volume patch submitter or a maintainer of a given 
topic tree it's not necessary for you to know/follow/interpret the 
internal structure of -tip - you can send patches against tip/master and 
we'll sort the patch out into the right topic branch. (and resolve 
conflicts, if any)

Generally tip/master is not supposed to break in any way anytime: it 
must build and boot on all hardware, no ifs and when. So it's not a 
development tree in the classic sense, i.e. temporary breakages and 
user-visible transition periods are not accepted. We do a lot of 
automated testing against tip/master so it should be fine for daily 
desktop use and daily development work. I use latest tip/master on about 
7 x86 boxes at the moment.

The individual topic trees are development trees, and might contain bugs 
at times - but we filter those out and only represent/merge a 
known-stable version of each sub-tree in tip/master.

At least that's the theory - it's still a high-flux tree with multiple 
updates every day and has an average of ~15 new commits added per day, 
24/7. If you see a problem with it then please report it.

	Ingo
