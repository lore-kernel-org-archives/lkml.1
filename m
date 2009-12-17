Return-Path: <linux-kernel-owner+w=401wt.eu-S1764640AbZLQMS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764640AbZLQMS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764629AbZLQMSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:18:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:47314 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764627AbZLQMSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:18:51 -0500
Message-Id: <20091217121829.970166036@chello.nl>
References: <20091217121626.682772324@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 17 Dec 2009 13:16:29 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/6] sched: Update task_state_arraypwith new states
Content-Disposition: inline; filename=sched-state-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neglected because its hidden... (who reads comments anyway)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 fs/proc/array.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/proc/array.c
===================================================================
--- linux-2.6.orig/fs/proc/array.c
+++ linux-2.6/fs/proc/array.c
@@ -138,9 +138,12 @@ static const char *task_state_array[] = 
 	"S (sleeping)",		/*  1 */
 	"D (disk sleep)",	/*  2 */
 	"T (stopped)",		/*  4 */
-	"T (tracing stop)",	/*  8 */
+	"t (tracing stop)",	/*  8 */
 	"Z (zombie)",		/* 16 */
-	"X (dead)"		/* 32 */
+	"X (dead)",		/* 32 */
+	"x (dead)",		/* 64 */
+	"K (wakekill)",		/* 128 */
+	"W (waking)",		/* 256 */
 };
 
 static inline const char *get_task_state(struct task_struct *tsk)

-- 

