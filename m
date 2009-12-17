Return-Path: <linux-kernel-owner+w=401wt.eu-S1763414AbZLQMcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763414AbZLQMcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:32:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759855AbZLQMbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:31:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:58049 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720AbZLQMbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:31:53 -0500
Date: Thu, 17 Dec 2009 12:31:04 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091217121829.892737686@chello.nl>
References: <20091217121829.892737686@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Add missing state chars to TASK_STATE_TO_CHAR_STR
Message-ID: <tip-44d90df6b757c59651ddd55f1a84f28132b50d29@git.kernel.org>
Git-Commit-ID: 44d90df6b757c59651ddd55f1a84f28132b50d29
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  44d90df6b757c59651ddd55f1a84f28132b50d29
Gitweb:     http://git.kernel.org/tip/44d90df6b757c59651ddd55f1a84f28132b50d29
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 17 Dec 2009 13:16:28 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Dec 2009 13:22:44 +0100

sched: Add missing state chars to TASK_STATE_TO_CHAR_STR

We grew 3 new task states since the last time someone touched
it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20091217121829.892737686@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c28ed1b..94858df 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -193,7 +193,7 @@ print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 #define TASK_WAKEKILL		128
 #define TASK_WAKING		256
 
-#define TASK_STATE_TO_CHAR_STR "RSDTtZX"
+#define TASK_STATE_TO_CHAR_STR "RSDTtZXxKW"
 
 /* Convenience macros for the sake of set_task_state */
 #define TASK_KILLABLE		(TASK_WAKEKILL | TASK_UNINTERRUPTIBLE)
