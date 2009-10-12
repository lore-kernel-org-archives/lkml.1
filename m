Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122AbZJLCOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbZJLCOf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 22:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbZJLCOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 22:14:31 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:62822 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbZJLCOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 22:14:30 -0400
Message-ID: <4AD29070.7070002@oracle.com>
Date: Sun, 11 Oct 2009 19:12:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
CC: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] sched: fix missing kernel-doc notation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4AD290C7.005B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] sched: fix htmldocs sched.c
From:	Jaswinder Singh Rajput <jaswinder@kernel.org>
Date:	Thu, 24 Sep 2009 19:08:50 +0530

fix the following htmldocs warnings:

  Warning(kernel/sched.c:685): No description found for parameter 'cpu'
  Warning(kernel/sched.c:3676): No description found for parameter 'sd'

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 2f76e06..f0d1375 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -676,6 +676,7 @@ inline void update_rq_clock(struct rq *rq)
 
 /**
  * runqueue_is_locked
+ * @cpu: the processor in question.
  *
  * Returns true if the current cpu runqueue is locked.
  * This interface allows printk to be called with the runqueue lock
@@ -3658,6 +3659,7 @@ static void update_group_power(struct sched_domain *sd, int cpu)
 
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
+ * @sd: The sched_domain whose statistics are to be updated.
  * @group: sched_group whose statistics are to be updated.
  * @this_cpu: Cpu for which load balance is currently performed.
  * @idle: Idle status of this_cpu
---
