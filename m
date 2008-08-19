Return-Path: <linux-kernel-owner+w=401wt.eu-S1753011AbYHSKoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbYHSKoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 06:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbYHSKoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 06:44:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54414 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbYHSKoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 06:44:10 -0400
Message-Id: <20080819103844.459178947@chello.nl>
References: <20080819103301.787700742@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 19 Aug 2008 12:33:07 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Stefani Seibold <stefani@seibold.net>, Dario Faggioli <raistlin@linux.it>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 6/6] sched: disabled rt-bandwidth by default
Content-Disposition: inline; filename=sched-rt-bw-default-disable.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable bandwidth control by default.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -824,9 +824,9 @@ static __read_mostly int scheduler_runni
 
 /*
  * part of the period that we allow rt tasks to run in us.
- * default: 0.95s
+ * default: inf
  */
-int sysctl_sched_rt_runtime = 950000;
+int sysctl_sched_rt_runtime = -1;
 
 static inline u64 global_rt_period(void)
 {

-- 

