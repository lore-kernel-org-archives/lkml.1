Return-Path: <linux-kernel-owner+w=401wt.eu-S965657AbXDWHgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965657AbXDWHgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 03:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965663AbXDWHgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 03:36:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56982 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965657AbXDWHgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 03:36:46 -0400
Date: Mon, 23 Apr 2007 09:35:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch] CFS scheduler, -v5
Message-ID: <20070423073553.GA19742@elte.hu>
References: <20070420140457.GA14017@elte.hu> <20070423011229.GA20367@elte.hu> <20070423012509.GA25162@wotan.suse.de> <20070423025553.GA10407@elte.hu> <20070423032215.GC25162@wotan.suse.de> <20070423034310.GA19845@elte.hu> <20070423040600.GD25162@wotan.suse.de> <20070423071050.GD4518@elte.hu> <20070423072515.GA27012@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423072515.GA27012@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> > do need reinforcement and test results on the basic part: _can_ this 
> > design be interactive enough on the desktop? So far the feedback has 
> > been affirmative, but more testing is needed.
> 
> It seems to be fairly easy to make a scheduler interactive if the 
> timeslice is as low as that (not that I've released one for wider 
> testing, but just by my own observations). [...]

ok, i'll bite: please release such a scheduler that does that with 
5-8-10msec range timeslices :-)

	Ingo
