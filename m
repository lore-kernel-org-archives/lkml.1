Return-Path: <linux-kernel-owner+w=401wt.eu-S1760204AbZDWV1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204AbZDWV1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758609AbZDWV1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:27:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47003 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbZDWV1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:27:17 -0400
Date: Thu, 23 Apr 2009 23:22:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ptrace: tracehook_unsafe_exec: remove the stale comment
Message-ID: <20090423212250.GA22537@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tracehook_unsafe_exec() doesn't need task_lock(), remove the old comment.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- PTRACE/include/linux/tracehook.h~	2009-04-06 00:03:42.000000000 +0200
+++ PTRACE/include/linux/tracehook.h	2009-04-23 23:20:20.000000000 +0200
@@ -142,8 +142,6 @@ static inline void tracehook_report_sysc
  * @task:		current task doing exec
  *
  * Return %LSM_UNSAFE_* bits applied to an exec because of tracing.
- *
- * Called with task_lock() held on @task.
  */
 static inline int tracehook_unsafe_exec(struct task_struct *task)
 {

