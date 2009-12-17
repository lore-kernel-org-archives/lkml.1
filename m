Return-Path: <linux-kernel-owner+w=401wt.eu-S1764163AbZLQMcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764163AbZLQMcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764036AbZLQMcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:32:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:58072 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759072AbZLQMcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:32:08 -0500
Date: Thu, 17 Dec 2009 12:31:21 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091217121829.970166036@chello.nl>
References: <20091217121829.970166036@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Update task_state_arraypwith new states
Message-ID: <tip-464763cf1c6df632dccc8f2f4c7e50163154a2c0@git.kernel.org>
Git-Commit-ID: 464763cf1c6df632dccc8f2f4c7e50163154a2c0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  464763cf1c6df632dccc8f2f4c7e50163154a2c0
Gitweb:     http://git.kernel.org/tip/464763cf1c6df632dccc8f2f4c7e50163154a2c0
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 17 Dec 2009 13:16:29 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Dec 2009 13:22:45 +0100

sched: Update task_state_arraypwith new states

Neglected because its hidden... (who reads comments anyway)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20091217121829.970166036@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/proc/array.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 4badde1..96361e8 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -138,9 +138,12 @@ static const char *task_state_array[] = {
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
