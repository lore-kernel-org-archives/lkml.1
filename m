Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbYISPtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbYISPtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 11:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbYISPt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 11:49:27 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:50853 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbYISPt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 11:49:27 -0400
Message-ID: <48D3C9FF.20504@nortel.com>
Date: Fri, 19 Sep 2008 09:49:19 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: [patch] sched: trivial fix for incorrect comments
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Sep 2008 15:49:23.0271 (UTC) FILETIME=[49729D70:01C91A6F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Friesen    <cfriesen@nortel.com>

A couple of the comments for the conditional definitions in sched.c are
incorrect.  Here's a trivial patch fixing them up.


Signed-off-by: Chris Friesen <cfriesen@nortel.com>
Approval token "Nortel-02-July-2008-01"

---

diff --git a/kernel/sched.c b/kernel/sched.c
index cc1f81b..8ddca50 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -298,9 +298,9 @@ static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) 
____cacheline_aligned_in_smp;
  static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
  static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) 
____cacheline_aligned_in_smp;
  #endif /* CONFIG_RT_GROUP_SCHED */
-#else /* !CONFIG_FAIR_GROUP_SCHED */
+#else /* !CONFIG_USER_SCHED */
  #define root_task_group init_task_group
-#endif /* CONFIG_FAIR_GROUP_SCHED */
+#endif /* CONFIG_USER_SCHED */

  /* task_group_lock serializes add/remove of task groups and also 
changes to
   * a task group's cpu shares.
