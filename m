Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYJHVxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYJHVxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 17:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbYJHVxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 17:53:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56910 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbYJHVxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 17:53:06 -0400
Date: Wed, 8 Oct 2008 23:53:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: What's new in sched.git for v2.6.28
Message-ID: <20081008215300.GA18634@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


the scheduler family of trees had 4 topic trees active during the past 3 
months of the v2.6.28 development cycle:

   sched/core
   sched/cpu-hotplug
   sched/cpusets
   sched/rt

   31 files changed, 688 insertions(+), 487 deletions(-)

38 commits from 18 authors - see the shortlog below.

	Ingo

---------------->
Amit K. Arora (1):
      sched: minor optimizations in wake_affine and select_task_rq_fair

Andrew Morton (1):
      sched: clarify ifdef tangle

Bharata B Rao (2):
      sched: call resched_task() conditionally from new task wake up path
      sched: maintain only task entities in cfs_rq->tasks list

Chris Friesen (1):
      sched: fix list traversal to use _rcu variant

Claudio Scordino (1):
      sched: new documentation about CFS

Dario Faggioli (1):
      sched_rt.c: resch needed in rt_rq_enqueue() for the root rt_rq

Frederic Weisbecker (1):
      cpusets: scan_for_empty_cpusets(), cpuset doesn't seem to be so const

Gautham R Shenoy (1):
      sched: fix __load_balance_iterator() for cfq with only one task

Ingo Molnar (3):
      sched: clean up __might_sleep()
      sched: extract walk_tg_tree(), fix
      sched: turn off WAKEUP_OVERLAP

Joe Korty (1):
      make might_sleep() display the oopsing process

Kevin Diggs (1):
      sched: add kernel doc for the completion, fix kernel-doc-nano-HOWTO.txt

Krzysztof Helt (1):
      sched: compilation fix with gcc 3.4.6

Li Zefan (1):
      sched: remove redundant code in cpu_cgroup_create()

Manfred Spraul (2):
      kernel/cpu.c: Move the CPU_DYING notifiers
      kernel/cpu.c: create a CPU_STARTING cpu_chain notifier

Martin Steigerwald (1):
      CFS scheduler: documentation about scheduling policies

Oleg Nesterov (3):
      sched: do_wait_for_common: use signal_pending_state()
      wait_task_inactive(): don't consider task->nivcsw
      wait_task_inactive: "improve" the returned value for ->nvcsw == 0

Peter Zijlstra (12):
      sched: rt-bandwidth for user grouping interface
      sched: rt-bandwidth accounting fix
      sched: rt-bandwidth group disable fixes
      sched: extract walk_tg_tree()
      sched: rt-bandwidth fixes
      sched: wakeup preempt when small overlap
      sched: rework wakeup preemption
      sched: fixlet for group load balance
      sched: add some comments to the bandwidth code
      sched: more sanity checks on the bandwidth settings
      sched: fixup buddy selection
      sched: sync wakeups vs avg_overlap

Richard Kennedy (3):
      sched: reorder signal_struct to remove 8 bytes on 64 bit builds
      sched: reorder struct sched_rt_entity to remove padding on 64 bit builds
      reorder struct prop_local_single to remove padding on 64 bit builds

