Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbYIWQIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbYIWQIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 12:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYIWQIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 12:08:15 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:53601 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbYIWQIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 12:08:14 -0400
Message-ID: <48D91464.9010501@nortel.com>
Date: Tue, 23 Sep 2008 10:08:04 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] sched: trivial fix for incorrect comments
References: <48D3C9FF.20504@nortel.com> <20080922110049.GA5987@elte.hu>
In-Reply-To: <20080922110049.GA5987@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Sep 2008 16:08:05.0882 (UTC) FILETIME=[903A75A0:01C91D96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Chris Friesen <cfriesen@nortel.com> wrote:
> 
>> From: Chris Friesen    <cfriesen@nortel.com>
>>
>> A couple of the comments for the conditional definitions in sched.c are
>> incorrect.  Here's a trivial patch fixing them up.
> 
> looks good to me, but the patch is whitespace corrupted. Please see 
> Documentation/email-clients.txt about how to send plain-text patches.
> 
> 	Ingo
> 

Actually, I thought I was following the procedures in there.  It turns out 
that older Thunderbird requires an external editor, disabling 
format=flowed, and a line wrap of 0.  The email clients doc makes it sound
like if you use an external editor you don't need the other parts.  With
current Thunderbird the external editor is still not sufficient by itself,
but isn't required if the other two items are configured properly.

Here's another try.

---
From: Chris Friesen <cfriesen@nortel.com>
Subject: [PATCH] sched: trivial fix for incorrect comments

A couple of the comments for the conditional definitions in sched.c are
incorrect.  Here's a trivial patch fixing them up.

Signed-off-by: Chris Friesen <cfriesen@nortel.com>
Approval token "Nortel-02-July-2008-01"
---
 kernel/sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index cc1f81b..8ddca50 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -298,9 +298,9 @@ static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
 static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
 static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
 #endif /* CONFIG_RT_GROUP_SCHED */
-#else /* !CONFIG_FAIR_GROUP_SCHED */
+#else /* !CONFIG_USER_SCHED */
 #define root_task_group init_task_group
-#endif /* CONFIG_FAIR_GROUP_SCHED */
+#endif /* CONFIG_USER_SCHED */
 
 /* task_group_lock serializes add/remove of task groups and also changes to
  * a task group's cpu shares.

