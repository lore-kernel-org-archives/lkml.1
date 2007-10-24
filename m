Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbXJXQdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbXJXQdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759357AbXJXQXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:23:51 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33381 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757345AbXJXQXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:23:50 -0400
Date: Wed, 24 Oct 2007 18:24:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] unexport kernel/pid.c:task_*
Message-ID: <20071024162419.GG30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the following unused EXPORT_SYMBOL's:
- task_pid_nr_ns
- task_tgid_nr_ns
- task_pgrp_nr_ns
- task_session_nr_ns

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 kernel/pid.c |    4 ----
 1 file changed, 4 deletions(-)

8fd7ba197fac407ae18c69798098be65096efdaf 
diff --git a/kernel/pid.c b/kernel/pid.c
index b09d7c9..a805a26 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -443,25 +443,21 @@ pid_t task_pid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
 {
 	return pid_nr_ns(task_pid(tsk), ns);
 }
-EXPORT_SYMBOL(task_pid_nr_ns);
 
 pid_t task_tgid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
 {
 	return pid_nr_ns(task_tgid(tsk), ns);
 }
-EXPORT_SYMBOL(task_tgid_nr_ns);
 
 pid_t task_pgrp_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
 {
 	return pid_nr_ns(task_pgrp(tsk), ns);
 }
-EXPORT_SYMBOL(task_pgrp_nr_ns);
 
 pid_t task_session_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
 {
 	return pid_nr_ns(task_session(tsk), ns);
 }
-EXPORT_SYMBOL(task_session_nr_ns);
 
 /*
  * Used by proc to find the first pid that is greater then or equal to nr.

