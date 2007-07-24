Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbXGXTEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbXGXTEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbXGXTDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:03:46 -0400
Received: from www.osadl.org ([213.239.205.134]:55282 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755430AbXGXTDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:03:45 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
To: linux-kernel@vger.kernel.org
Subject: [RT-PATCH] v2.6.23-rc1-rt0 Add missing header in sch_generic.c
Date: Tue, 24 Jul 2007 21:03:41 +0200
User-Agent: KMail/1.9.5
Organization: Linutronix
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-rt-users@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707242103.41880.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

v2.6.23-rc1-rt0 adds an msleep(1) in net/sched/sch_generic.c
without including the neceessary header. This patches fixes it.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

----
Index: linux-2.6.23-rc/net/sched/sch_generic.c
===================================================================
--- linux-2.6.23-rc.orig/net/sched/sch_generic.c	2007-07-24 20:09:18.000000000 +0200
+++ linux-2.6.23-rc/net/sched/sch_generic.c	2007-07-24 20:10:13.000000000 +0200
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/rcupdate.h>
 #include <linux/list.h>
+#include <linux/delay.h>
 #include <net/pkt_sched.h>
 
 /* Main transmission queue. */
