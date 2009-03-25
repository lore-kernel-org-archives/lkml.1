Return-Path: <linux-kernel-owner+w=401wt.eu-S1763244AbZCYPsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763244AbZCYPsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 11:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762882AbZCYPrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 11:47:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44856 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760264AbZCYPru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:47:50 -0400
Message-Id: <20090325154538.916038098@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 25 Mar 2009 11:45:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [PATCH 0/3 v2] [GIT PULL] remove unlikelys
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

The differences between v1 and v2 is that I only included the non
controversial patches. I also modified the change log of pre_schedule_rt
to include the annotated branch profiler output.

I just did a force push, so please use ssh, or verify that only these
three patches are present.

Thanks,

-- Steve

Please pull the latest annotate-branch/cleanups tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
annotate-branch/cleanups


Steven Rostedt (3):
      sched: remove unlikely in pre_schedule_rt
      sched: remove unlikelys from sched_move_task
      mm: remove unlikelys for unlock in rmap.c

----
 kernel/sched.c    |    4 ++--
 kernel/sched_rt.c |    2 +-
 mm/rmap.c         |    8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)
-- 
