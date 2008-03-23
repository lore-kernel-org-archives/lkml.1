Return-Path: <linux-kernel-owner+w=401wt.eu-S1761006AbYCWOyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761006AbYCWOyv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 10:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759177AbYCWOyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 10:54:43 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:60313 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbYCWOym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 10:54:42 -0400
Date: Sun, 23 Mar 2008 20:24:41 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RT] [PATCH 2/3] Initialize rt.nr_running & rt.nr_unterruptible
Message-ID: <20080323145441.GD15554@in.ibm.com>
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

o Initialize rt.nr_running and rt.nr_uninterruptible fields explicitly.


Signed-off-by: Ankita Garg <ankita@in.ibm.com> 

Index: linux-2.6.24.3/kernel/sched.c
===================================================================
--- linux-2.6.24.3.orig/kernel/sched.c	2008-03-23 19:13:16.000000000 +0530
+++ linux-2.6.24.3/kernel/sched.c	2008-03-23 19:13:40.000000000 +0530
@@ -7333,6 +7333,8 @@
 		rq->cpu = i;
 		rq->migration_thread = NULL;
 		INIT_LIST_HEAD(&rq->migration_queue);
+		rq->rt.nr_running = 0;
+		rq->rt.nr_uninterruptible = 0;
 		rq->rt.highest_prio = MAX_RT_PRIO;
 		rq->rt.overloaded = 0;
 		rq_attach_root(rq, &def_root_domain);

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs, 
Bangalore, India   
