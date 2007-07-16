Return-Path: <linux-kernel-owner+w=401wt.eu-S1764622AbXGPMNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764622AbXGPMNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 08:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbXGPMNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 08:13:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57689 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618AbXGPMNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 08:13:09 -0400
Date: Mon, 16 Jul 2007 14:12:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: James Bruce <bruce@andrew.cmu.edu>, Thomas Gleixner <tglx@linutronix.de>,
       Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
Message-ID: <20070716121246.GA17880@elte.hu>
References: <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org> <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184355835.12353.321.camel@chaos> <469B0D9E.3030402@andrew.cmu.edu> <20070716070610.GA10907@elte.hu> <Pine.LNX.4.64.0707161213500.1817@scrub.home> <20070716112037.GA6895@elte.hu> <Pine.LNX.4.64.0707161331570.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707161331570.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> On Mon, 16 Jul 2007, Ingo Molnar wrote:
> 
> > > As soon as you add another loop the difference changes again, 
> > > while it's always correct to say it gets 25% more cpu time [...]
> > 
> > yep, and i'll add the relative effect to the comment too.
> 
> Why did you cut off the rest of the sentence?

(no need to become hostile, i answered to that portion of your sentence 
separately, which was logically detached from the other portion of your 
sentence. I marked the cut with the '[...]' sign. )

> To illustrate the problem a little different: a task with a nice level 
> -20 got around 700% more cpu time (or 8 times more), now it gets 8500% 
> more cpu time (or 86.7 times more). You don't think that change to the 
> nice levels is a little drastic?

This was discussed on lkml in detail, see the CFS threads. It has been a 
common request for nice levels to be more logical (i.e. to make them 
universal and to detach them from HZ) and for them to be more effective 
as well.

	Ingo
