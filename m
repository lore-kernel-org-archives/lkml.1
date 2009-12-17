Return-Path: <linux-kernel-owner+w=401wt.eu-S964999AbZLQMbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964999AbZLQMbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763643AbZLQMbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:31:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:41408 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762170AbZLQMbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:31:25 -0500
Date: Thu, 17 Dec 2009 12:30:48 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091217121829.815779372@chello.nl>
References: <20091217121829.815779372@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Move TASK_STATE_TO_CHAR_STR near the TASK_state bits
Message-ID: <tip-733421516b42c44b9e21f1793c430cc801ef8324@git.kernel.org>
Git-Commit-ID: 733421516b42c44b9e21f1793c430cc801ef8324
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  733421516b42c44b9e21f1793c430cc801ef8324
Gitweb:     http://git.kernel.org/tip/733421516b42c44b9e21f1793c430cc801ef8324
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 17 Dec 2009 13:16:27 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Dec 2009 13:22:43 +0100

sched: Move TASK_STATE_TO_CHAR_STR near the TASK_state bits

So that we don't keep forgetting about it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20091217121829.815779372@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 973b2b8..c28ed1b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -193,6 +193,8 @@ print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 #define TASK_WAKEKILL		128
 #define TASK_WAKING		256
 
+#define TASK_STATE_TO_CHAR_STR "RSDTtZX"
+
 /* Convenience macros for the sake of set_task_state */
 #define TASK_KILLABLE		(TASK_WAKEKILL | TASK_UNINTERRUPTIBLE)
 #define TASK_STOPPED		(TASK_WAKEKILL | __TASK_STOPPED)
@@ -2595,8 +2597,6 @@ static inline void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
 }
 #endif /* CONFIG_MM_OWNER */
 
-#define TASK_STATE_TO_CHAR_STR "RSDTtZX"
-
 #endif /* __KERNEL__ */
 
 #endif
