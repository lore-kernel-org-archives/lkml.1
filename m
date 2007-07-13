Return-Path: <linux-kernel-owner+w=401wt.eu-S934758AbXGMSNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934758AbXGMSNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760440AbXGMSNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:13:07 -0400
Received: from deeprooted.net ([216.254.16.51]:38938 "EHLO paris.hilman.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759669AbXGMSNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:13:06 -0400
X-Greylist: delayed 1236 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jul 2007 14:13:06 EDT
Message-Id: <20070713175229.063244111@mvista.com>
References: <20070713175214.336577416@mvista.com>
User-Agent: quilt/0.45-1
Date: Fri, 13 Jul 2007 10:52:19 -0700
From: Kevin Hilman <khilman@mvista.com>
To: tglx@linutronix.de, mingo@elte.hu
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -rt 5/6] ARM: Fix save_stack_trace() prototype
Content-Disposition: inline; filename=arm-stacktrace.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kevin Hilman <khilman@mvista.com>
---
 arch/arm/lib/stacktrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/arm/lib/stacktrace.c
===================================================================
--- linux-2.6.orig/arch/arm/lib/stacktrace.c
+++ linux-2.6/arch/arm/lib/stacktrace.c
@@ -1,7 +1,7 @@
 #include <linux/sched.h>
 #include <linux/stacktrace.h>
 
-void save_stack_trace(struct stack_trace *trace, struct task_struct *task)
+void save_stack_trace(struct stack_trace *trace)
 {
 }
 

--
