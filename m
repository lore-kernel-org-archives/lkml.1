Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbYKKMns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbYKKMns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 07:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbYKKMnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 07:43:39 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:53232 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbYKKMni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 07:43:38 -0500
Date: Tue, 11 Nov 2008 18:13:23 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Balbir Singh <balbir@in.ibm.com>
Subject: sched: removed unneeded defintion
Message-ID: <20081111124323.GA4684@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: removed unneeded defintion

This function no longer exists, so remove the defintion.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

---
 include/linux/sched.h |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6-tip/include/linux/sched.h
===================================================================
--- linux-2.6-tip.orig/include/linux/sched.h	2008-11-10 23:17:53.000000000 +0530
+++ linux-2.6-tip/include/linux/sched.h	2008-11-10 23:21:45.000000000 +0530
@@ -258,8 +258,6 @@ static inline int select_nohz_load_balan
 }
 #endif
 
-extern unsigned long rt_needs_cpu(int cpu);
-
 /*
  * Only dump TASK_* tasks. (0 for all tasks)
  */

-- 
regards,
Dhaval
