Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbZCMFJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbZCMFJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758032AbZCMFF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:05:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34741 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758040AbZCMFFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:05:24 -0400
Message-Id: <20090313050521.766183674@goodmis.org>
References: <20090313050446.277065036@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 13 Mar 2009 01:04:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/4] softirq: no need to have SOFTIRQ in softirq name
Content-Disposition: inline; filename=0004-softirq-no-need-to-have-SOFTIRQ-in-softirq-name.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

It is redundant to have 'SOFTIRQ' in the softirq names.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/softirq.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index a5e8123..65ff3e3 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -55,9 +55,8 @@ static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp
 static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 
 char *softirq_to_name[NR_SOFTIRQS] = {
-	"HI_SOFTIRQ", "TIMER_SOFTIRQ", "NET_TX_SOFTIRQ", "NET_RX_SOFTIRQ",
-	"BLOCK_SOFTIRQ", "TASKLET_SOFTIRQ", "SCHED_SOFTIRQ", "HRTIMER_SOFTIRQ",
-	"RCU_SOFTIRQ"
+	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK",
+	"TASKLET", "SCHED", "HRTIMER",	"RCU"
 };
 
 /*
-- 
1.6.1.3

-- 
