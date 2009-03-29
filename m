Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbZC2Ez3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbZC2Ez3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 00:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZC2EzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 00:55:11 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:36929 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbZC2EzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 00:55:09 -0400
Date: Sat, 28 Mar 2009 21:52:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: [PATCH] sched: fix errors in struct & function comments
Message-Id: <20090328215247.daaad3f3.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A01020A.49CEFECD.0105:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc errors in sched.c:  the structs don't have
kernel-doc notation and the short function description needs to
be one line only.

Error(kernel/sched.c:3197): cannot understand prototype: 'struct sd_lb_stats '
Error(kernel/sched.c:3228): cannot understand prototype: 'struct sg_lb_stats '
Error(kernel/sched.c:3375): duplicate section name 'Description'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- linux-2.6.29-git4.orig/kernel/sched.c
+++ linux-2.6.29-git4/kernel/sched.c
@@ -3190,7 +3190,7 @@ static int move_one_task(struct rq *this
 	return 0;
 }
 /********** Helpers for find_busiest_group ************************/
-/**
+/*
  * sd_lb_stats - Structure to store the statistics of a sched_domain
  * 		during load balancing.
  */
@@ -3222,7 +3222,7 @@ struct sd_lb_stats {
 #endif
 };
 
-/**
+/*
  * sg_lb_stats - stats of a sched_group required for load_balancing
  */
 struct sg_lb_stats {
@@ -3360,16 +3360,17 @@ static inline void update_sd_power_savin
 }
 
 /**
- * check_power_save_busiest_group - Check if we have potential to perform
- *	some power-savings balance. If yes, set the busiest group to be
- *	the least loaded group in the sched_domain, so that it's CPUs can
- *	be put to idle.
- *
+ * check_power_save_busiest_group - see if there is potential for some power-savings balance
  * @sds: Variable containing the statistics of the sched_domain
  *	under consideration.
  * @this_cpu: Cpu at which we're currently performing load-balancing.
  * @imbalance: Variable to store the imbalance.
  *
+ * Description:
+ * Check if we have potential to perform some power-savings balance.
+ * If yes, set the busiest group to be the least loaded group in the
+ * sched_domain, so that it's CPUs can be put to idle.
+ *
  * Returns 1 if there is potential to perform power-savings balance.
  * Else returns 0.
  */
