Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab0CKKFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 05:05:00 -0500
Received: from mail.gmx.net ([213.165.64.20]:44073 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756432Ab0CKKE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 05:04:58 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19g+vokx/pgKvRs8q1demmmjxElP52fnjTZ3aMIAg
	4zL+hueqxna+l7
Subject: Re: [patch 12/12] sched: remove AFFINE_WAKEUPS feature
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1268300950.6785.27.camel@marge.simson.net>
References: <1268300950.6785.27.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 11 Mar 2010 11:04:50 +0100
Message-Id: <1268301890.6785.50.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: remove AFFINE_WAKEUPS feature

Disabling affine wakeups is too horrible to contemplate.  Remove it.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched_fair.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1433,8 +1433,7 @@ static int select_task_rq_fair(struct ta
 	int sync = wake_flags & WF_SYNC;
 
 	if (sd_flag & SD_BALANCE_WAKE) {
-		if (sched_feat(AFFINE_WAKEUPS) &&
-		    cpumask_test_cpu(cpu, &p->cpus_allowed))
+		if (cpumask_test_cpu(cpu, &p->cpus_allowed))
 			want_affine = 1;
 		new_cpu = prev_cpu;
 	}


