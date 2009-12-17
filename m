Return-Path: <linux-kernel-owner+w=401wt.eu-S934866AbZLQMTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934866AbZLQMTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764646AbZLQMTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:19:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53808 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764644AbZLQMTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:19:07 -0500
Message-Id: <20091217121829.892737686@chello.nl>
References: <20091217121626.682772324@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 17 Dec 2009 13:16:28 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/6] sched: Add missing state chars to TASK_STATE_TO_CHAR_STR
Content-Disposition: inline; filename=sched-state-1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We grew 3 new task states since the last time someone touched it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 include/linux/sched.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -193,7 +193,7 @@ print_cfs_rq(struct seq_file *m, int cpu
 #define TASK_WAKEKILL		128
 #define TASK_WAKING		256
 
-#define TASK_STATE_TO_CHAR_STR "RSDTtZX"
+#define TASK_STATE_TO_CHAR_STR "RSDTtZXxKW"
 
 /* Convenience macros for the sake of set_task_state */
 #define TASK_KILLABLE		(TASK_WAKEKILL | TASK_UNINTERRUPTIBLE)

-- 

