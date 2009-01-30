Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbZA3Lon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbZA3Lon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 06:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbZA3Lns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 06:43:48 -0500
Received: from www.tglx.de ([62.245.132.106]:40347 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340AbZA3Lnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 06:43:47 -0500
Message-Id: <20090130114306.923820819@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 30 Jan 2009 11:43:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <cbe@osadl.org>,
       Carsten Emde <C.Emde@osadl.org>
Subject: [patch-rt 3/5] trace: fix typo in kernel/trace/Kconfig
References: <20090130114230.100052140@linutronix.de>
Content-Disposition: inline; filename=typo-in-kernel-trace-kconfig.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed confusing Kconfig label of WAKEUP_LATENCY_HIST

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

--- linux-2.6.26.8-rt13/kernel/trace/Kconfig-orig	2009-01-25 23:06:19.000000000 +0100
+++ linux-2.6.26.8-rt13/kernel/trace/Kconfig	2009-01-25 23:05:07.000000000 +0100
@@ -183,7 +183,7 @@
 	  preemption off timings to create a histogram of latencies.
 
 config WAKEUP_LATENCY_HIST
-	bool "Interrupts off critical timings histogram"
+	bool "Wakeup latency histogram"
 	select TRACING
 	select MARKERS
 	help



