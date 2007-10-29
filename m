Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbXJ2Ujt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbXJ2Ujt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbXJ2Ujl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:39:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55785 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbXJ2Ujk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:39:40 -0400
Date: Mon, 29 Oct 2007 21:39:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] scheduler fixes
Message-ID: <20071029203923.GA9314@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

it contains 7 commits: 3 (small) fixes, 1 code cleanup and 3 style 
cleanups - all fallout of recent merges.

[ There is one commit that is borderline for post-rc1 inclusion: "sched:
  report CPU usage in CFS cgroup directories" which completes/fixes 
  cgroup CPU accounting by introducing a small piece of new code. It's 
  only relevant to cgroups which is a new feature in 2.6.24 so there are 
  no regression/compatibility worries, so i included it. ]

Thanks,

	Ingo

------------------>
Adrian Bunk (1):
      sched: make kernel/sched.c:account_guest_time() static

Ingo Molnar (2):
      sched: fix style of swap() macro in kernel/sched_fair.c
      sched: fix style in kernel/sched.c

James Bottomley (1):
      sched: fix incorrect assumption that cpu 0 exists

Paul Menage (1):
      sched: report CPU usage in CFS cgroup directories

Peter Zijlstra (1):
      sched: keep utime/stime monotonic

Srivatsa Vaddagiri (1):
      sched: move rcu_head to task_group struct

 fs/proc/array.c       |    3 +-
 include/linux/sched.h |    1 
 kernel/fork.c         |    1 
 kernel/sched.c        |   70 +++++++++++++++++++++++++++++++++++---------------
 kernel/sched_fair.c   |    2 -
 5 files changed, 54 insertions(+), 23 deletions(-)
