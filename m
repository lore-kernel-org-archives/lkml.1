Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbXGNFEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbXGNFEd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 01:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbXGNFE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 01:04:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:60000 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750877AbXGNFEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 01:04:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/WfE9t+LzWkELTTN2FjSxnq2AXSQmmj9mVRWYTuX
	THtIb54RWLQVhp
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
From: Mike Galbraith <efault@gmx.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <Pine.LNX.4.64.0707131728070.1817@scrub.home>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
	 <20070711211638.GE18767@one.firstfloor.org>
	 <20070711214649.GK14435@v2.random>
	 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0707130415520.1818@scrub.home>
	 <1184302024.6709.11.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0707131728070.1817@scrub.home>
Content-Type: text/plain
Date: Sat, 14 Jul 2007 07:04:16 +0200
Message-Id: <1184389456.6632.13.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 19:23 +0200, Roman Zippel wrote:
> Hi,
> 
> On Fri, 13 Jul 2007, Mike Galbraith wrote:
> 
> > > The new scheduler does _a_lot_ of heavy 64 bit calculations without any 
> > > attempt to scale that down a little...
> > 
> > See prio_to_weight[], prio_to_wmult[] and sysctl_sched_stat_granularity.
> > Perhaps more can be done, but "without any attempt..." isn't accurate.
> 
> Calculating these values at runtime would have been completely insane, the 
> alternative would be a crummy approximation, so using a lookup table is 
> actually a good thing. That's not the problem.

I meant see usage.

	-Mike



