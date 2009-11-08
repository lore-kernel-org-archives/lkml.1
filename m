Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbZKHK2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbZKHK2L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 05:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbZKHK2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 05:28:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:54707 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbZKHK2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 05:28:07 -0500
Date: Sun, 8 Nov 2009 10:27:35 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, randy.dunlap@oracle.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, randy.dunlap@oracle.com, mingo@elte.hu
In-Reply-To: <4AF4B1BC.8020604@oracle.com>
References: <4AF4B1BC.8020604@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix kernel-doc function parameter name
Message-ID: <tip-968c86458a5975efa7a95f832a4ec9fb21471137@git.kernel.org>
Git-Commit-ID: 968c86458a5975efa7a95f832a4ec9fb21471137
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  968c86458a5975efa7a95f832a4ec9fb21471137
Gitweb:     http://git.kernel.org/tip/968c86458a5975efa7a95f832a4ec9fb21471137
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Fri, 6 Nov 2009 15:31:08 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 11:26:25 +0100

sched: Fix kernel-doc function parameter name

Fix variable name in sched.c kernel-doc notation.

Fixes this DocBook warning:

 Warning(kernel/sched.c:2008): No description found for parameter
 'p' Warning(kernel/sched.c:2008): Excess function parameter 'k'
 description in 'kthread_bind'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
LKML-Reference: <4AF4B1BC.8020604@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 28dd4f4..7d7d5fc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1994,7 +1994,7 @@ static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 
 /**
  * kthread_bind - bind a just-created kthread to a cpu.
- * @k: thread created by kthread_create().
+ * @p: thread created by kthread_create().
  * @cpu: cpu (might not be online, must be possible) for @k to run on.
  *
  * Description: This function is equivalent to set_cpus_allowed(),
