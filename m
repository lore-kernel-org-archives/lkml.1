Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbZAKEBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbZAKEBk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 23:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbZAKEBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 23:01:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44543 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbZAKEBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 23:01:30 -0500
Date: Sun, 11 Jan 2009 05:01:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] RT scheduler updates for tip
Message-ID: <20090111040121.GD28520@elte.hu>
References: <493939B1.40506@novell.com> <20081208143228.GF14856@elte.hu> <20081208161246.GB4570@elte.hu> <493E8246.1090309@novell.com> <20081212113415.GH32640@elte.hu> <20081212114952.GA16976@elte.hu> <4958EEB6.5020105@novell.com> <49591331.9080403@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49591331.9080403@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gregory Haskins <ghaskins@novell.com> wrote:

> Gregory Haskins wrote:
> > Ingo Molnar wrote:
> >   
> >> * Ingo Molnar <mingo@elte.hu> wrote:
> >>
> >>     
> >>>
> >>> Could you send a delta fix against cpus4096 for that bug you fixed?
> >>>     
> >>>       
> 
> Hi Ingo,
>   I have rebased the series against tip/cpus4096 as of today.  I
> built/boot this kernel for both SMP/UP on a 4-way x86_64 box, and they
> look sane.  Let me know if they still look broken to you.
> 
> The following changes since commit 6092848a2a23b660150a38bc06f59d75838d70c8:
>   Sergio Luis (1):
>         x86: mark get_cpu_leaves() with __cpuinit annotation
> 
> are available in the git repository at:
> 
>  
> git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/linux-2.6-hacks.git
> sched/latest
> 
> Gregory Haskins (11):
>       sched: cleanup inc/dec_rt_tasks
>       sched: track the next-highest priority on each runqueue
>       sched: use highest_prio.curr for pull threshold
>       sched: use highest_prio.next to optimize pull operations
>       sched: only try to push a task on wakeup if it is migratable
>       sched: pull only one task during NEWIDLE balancing to limit
> critical section
>       sched: make double-lock-balance fair
>       sched: add sched_class->needs_post_schedule() member
>       plist: fix PLIST_NODE_INIT to work with debug enabled
>       sched: create "pushable_tasks" list to limit pushing to one attempt
>       RT: fix push_rt_task() to handle dequeue_pushable properly
> 
>  include/linux/init_task.h |    1 +
>  include/linux/plist.h     |    9 +-
>  include/linux/sched.h     |    2 +
>  kernel/sched.c            |   89 +++++++++++--
>  kernel/sched_rt.c         |  324
> +++++++++++++++++++++++++++++++--------------
>  5 files changed, 311 insertions(+), 114 deletions(-)

pulled into tip/sched/rt, thanks Gregory!

	Ingo
