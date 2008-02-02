Return-Path: <linux-kernel-owner+w=401wt.eu-S1765578AbYBBJBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765578AbYBBJBk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757926AbYBBJBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:01:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56026 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbYBBJBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:01:30 -0500
Date: Sat, 2 Feb 2008 10:01:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, akpm@osdl.org,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] add support for dynamic ticks and preempt rcu
Message-ID: <20080202090113.GA17348@elte.hu>
References: <Pine.LNX.4.58.0802020123070.21975@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0802020123070.21975@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> [
>   Resending this patch because no one commented on it (besides Paul)
>   and I'm thinking it got lost in the noise.
>   Without this patch, preempt RCU is broken when NO_HZ is configured.
> ]

i've added it a few days ago and it's already in the sched-devel.git 
tree:

 git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git

	Ingo
