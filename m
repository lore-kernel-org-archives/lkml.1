Return-Path: <linux-kernel-owner+w=401wt.eu-S1764623AbZLQMSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764623AbZLQMSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764602AbZLQMSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:18:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:47311 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764577AbZLQMSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:18:47 -0500
Message-Id: <20091217121829.815779372@chello.nl>
References: <20091217121626.682772324@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 17 Dec 2009 13:16:27 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/6] sched: Move TASK_STATE_TO_CHAR_STR near the TASK_state bits
Content-Disposition: inline; filename=sched-state.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that we don't keep forgetting about it

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 include/linux/sched.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -193,6 +193,8 @@ print_cfs_rq(struct seq_file *m, int cpu
 #define TASK_WAKEKILL		128
 #define TASK_WAKING		256
 
+#define TASK_STATE_TO_CHAR_STR "RSDTtZX"
+
 /* Convenience macros for the sake of set_task_state */
 #define TASK_KILLABLE		(TASK_WAKEKILL | TASK_UNINTERRUPTIBLE)
 #define TASK_STOPPED		(TASK_WAKEKILL | __TASK_STOPPED)
@@ -2595,8 +2597,6 @@ static inline void mm_init_owner(struct 
 }
 #endif /* CONFIG_MM_OWNER */
 
-#define TASK_STATE_TO_CHAR_STR "RSDTtZX"
-
 #endif /* __KERNEL__ */
 
 #endif

-- 

