Return-Path: <linux-kernel-owner+w=401wt.eu-S1760882AbXE1HYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760882AbXE1HYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 03:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755315AbXE1HYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 03:24:14 -0400
Received: from ozlabs.org ([203.10.76.45]:58841 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbXE1HYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 03:24:13 -0400
From: Michael Neuling <mikey@neuling.org>
To: trivial@kernel.org
cc: linux-kernel@vger.kernel.org
X-GPG-Fingerprint: 9B25 DC2A C58D 2C8D 47C2  457E 0887 E86F 32E6 BE16
MIME-Version: 1.0
Subject: [PATCH] trivial: remove bogus comment from account_user_time 
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 21.4.1
Date: Mon, 28 May 2007 17:24:10 +1000
Message-ID: <2585.1180337050@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hardirq_offset is no longer needed.

Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 kernel/sched.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6-ozlabs/kernel/sched.c
===================================================================
--- linux-2.6-ozlabs.orig/kernel/sched.c
+++ linux-2.6-ozlabs/kernel/sched.c
@@ -3290,7 +3290,6 @@ static inline int expired_starving(struc
 /*
  * Account user cpu time to a process.
  * @p: the process that the cpu time gets accounted to
- * @hardirq_offset: the offset to subtract from hardirq_count()
  * @cputime: the cpu time spent in user space since the last update
  */
 void account_user_time(struct task_struct *p, cputime_t cputime)
