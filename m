Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbZJLI4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbZJLI4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 04:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755066AbZJLI4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 04:56:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:46303 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053AbZJLI4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 04:56:10 -0400
Date: Mon, 12 Oct 2009 08:54:49 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, randy.dunlap@oracle.com,
       jaswinderrajput@gmail.com, akpm@linux-foundation.org,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, randy.dunlap@oracle.com,
       jaswinderrajput@gmail.com, akpm@linux-foundation.org,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AD29070.7070002@oracle.com>
References: <4AD29070.7070002@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix missing kernel-doc notation
Message-ID: <tip-e17b38bf9e70d74f3739a600db75240078ac1407@git.kernel.org>
Git-Commit-ID: e17b38bf9e70d74f3739a600db75240078ac1407
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 12 Oct 2009 08:54:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e17b38bf9e70d74f3739a600db75240078ac1407
Gitweb:     http://git.kernel.org/tip/e17b38bf9e70d74f3739a600db75240078ac1407
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Sun, 11 Oct 2009 19:12:00 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Oct 2009 10:50:06 +0200

sched: Fix missing kernel-doc notation

The following htmldocs warnings:

  Warning(kernel/sched.c:685): No description found for parameter 'cpu'
  Warning(kernel/sched.c:3676): No description found for parameter 'sd'

Trigger because new parameters were added to update_rq_clock() and
update_group_power() without updating the kernel-doc notation.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4AD29070.7070002@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e3f8f4f..789001d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -676,6 +676,7 @@ inline void update_rq_clock(struct rq *rq)
 
 /**
  * runqueue_is_locked
+ * @cpu: the processor in question.
  *
  * Returns true if the current cpu runqueue is locked.
  * This interface allows printk to be called with the runqueue lock
@@ -3660,6 +3661,7 @@ static void update_group_power(struct sched_domain *sd, int cpu)
 
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
+ * @sd: The sched_domain whose statistics are to be updated.
  * @group: sched_group whose statistics are to be updated.
  * @this_cpu: Cpu for which load balance is currently performed.
  * @idle: Idle status of this_cpu
