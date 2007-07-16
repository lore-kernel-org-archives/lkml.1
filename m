Return-Path: <linux-kernel-owner+w=401wt.eu-S1759965AbXGPMmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965AbXGPMmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 08:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbXGPMmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 08:42:46 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4551 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbXGPMmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 08:42:45 -0400
Date: Mon, 16 Jul 2007 14:42:30 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: James Bruce <bruce@andrew.cmu.edu>, Thomas Gleixner <tglx@linutronix.de>,
       Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
In-Reply-To: <20070716121246.GA17880@elte.hu>
Message-ID: <Pine.LNX.4.64.0707161427100.1817@scrub.home>
References: <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184355835.12353.321.camel@chaos>
 <469B0D9E.3030402@andrew.cmu.edu> <20070716070610.GA10907@elte.hu>
 <Pine.LNX.4.64.0707161213500.1817@scrub.home> <20070716112037.GA6895@elte.hu>
 <Pine.LNX.4.64.0707161331570.1817@scrub.home> <20070716121246.GA17880@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 16 Jul 2007, Ingo Molnar wrote:

> > > > As soon as you add another loop the difference changes again, 
> > > > while it's always correct to say it gets 25% more cpu time [...]
> > > 
> > > yep, and i'll add the relative effect to the comment too.
> > 
> > Why did you cut off the rest of the sentence?
> 
> (no need to become hostile, i answered to that portion of your sentence 
> separately, which was logically detached from the other portion of your 
> sentence. I marked the cut with the '[...]' sign. )

Could you please stop with these accusations?
Could you please point me to the mail with the separate answer?

> > To illustrate the problem a little different: a task with a nice level 
> > -20 got around 700% more cpu time (or 8 times more), now it gets 8500% 
> > more cpu time (or 86.7 times more). You don't think that change to the 
> > nice levels is a little drastic?
> 
> This was discussed on lkml in detail, see the CFS threads.

Which are quite big, so I skipped most of it, a more precise pointer would 
be appreciated.

> It has been a 
> common request for nice levels to be more logical (i.e. to make them 
> universal and to detach them from HZ) and for them to be more effective 
> as well.

Huh? What has this to do with HZ? The scheduler used ticks internally, but 
it's irrelevant to what the user sees via the nice levels.
So the question still stands that this change may be a little drastic, as 
you changed the nice levels of _all_ users, not just of those who were 
previously interested in CFS.

bye, Roman
