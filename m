Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbYCWPJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbYCWPJw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 11:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbYCWPJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 11:09:42 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:56185 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbYCWPJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 11:09:41 -0400
Date: Sun, 23 Mar 2008 20:39:39 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RT] [PATCH 3/3] Update sched_debug with new RT related stats
Message-ID: <20080323150939.GE15554@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
Mail-Followup-To: Ankita Garg <ankita@in.ibm.com>,
	linux-rt-users <linux-rt-users@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Gregory Haskins <ghaskins@novell.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20080323145029.GB15554@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080323145029.GB15554@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

o Update sched_debug to print values of the recently added fields to
rt_rq.


Signed-off-by: Ankita Garg <ankita@in.ibm.com> 

Index: linux-2.6.24.3/kernel/sched_debug.c
===================================================================
--- linux-2.6.24.3.orig/kernel/sched_debug.c	2008-03-23 19:09:35.000000000 +0530
+++ linux-2.6.24.3/kernel/sched_debug.c	2008-03-23 19:47:52.000000000 +0530
@@ -188,8 +188,12 @@
 	P(cpu_load[4]);
 #ifdef CONFIG_PREEMPT_RT
 	/* Print rt related rq stats */
+	SEQ_printf(m, "\nrt_rq\n");
 	P(rt.nr_running);
 	P(rt.nr_uninterruptible);
+	P(rt.nr_migratory);
+	P(rt.highest_prio);
+	P(rt.overloaded);
 # ifdef CONFIG_SCHEDSTATS
 	P(rto_schedule);
 	P(rto_schedule_tail);

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs, 
Bangalore, India   
