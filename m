Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbYI3KJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbYI3KJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 06:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbYI3KJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 06:09:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53424 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbYI3KJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 06:09:31 -0400
Date: Tue, 30 Sep 2008 12:08:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] RCU read sched
Message-ID: <20080930100829.GC7557@elte.hu>
References: <48E08B05.7030802@cn.fujitsu.com> <20080929082722.GB18663@elte.hu> <20080929150646.GD11245@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080929150646.GD11245@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> (probably already in -tip)
> 
> Add rcu_read_lock_sched() and rcu_read_unlock_sched() to rcupdate.h to match the
> recently added write-side call_rcu_sched() and rcu_barrier_sched(). They also
> match the no-so-recently-added synchronize_sched().
> 
> It will help following matching use of the update/read lock primitives. Those
> new read lock will replace preempt_disable()/enable() used in pair with
> RCU-classic synchronization.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Acked-by: Peter Zijlstra <peterz@infradead.org>
> CC: Paul E McKenney <paulmck@linux.vnet.ibm.com>

Paul, does this API extension look good to you?

i'll apply it to tip/core/rcu if yes.

	Ingo
