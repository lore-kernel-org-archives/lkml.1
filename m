Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbZA1Vqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbZA1Vqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbZA1Vpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:45:50 -0500
Received: from www.tglx.de ([62.245.132.106]:45173 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389AbZA1Vpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:45:49 -0500
Message-Id: <20090128212709.371517363@linutronix.de>
References: <20090128211912.300823284@linutronix.de>
User-Agent: quilt/0.46-1
Date: Wed, 28 Jan 2009 21:29:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Carsten Emde <carsten.emde@osadl.org>
Subject: [patch-rt 4/4] sched: mark SCHED_HRTICK broken
Content-Disposition: inline;
	filename=do-not-configure-sched-hrtick-since-it-is-currently-broken.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SCHED_HRTICK is broken and not yet fixed in mainline. WTF is it still
enabled in -rt ?

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Tested-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/Kconfig.hz |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.26/kernel/Kconfig.hz
===================================================================
--- linux-2.6.26.orig/kernel/Kconfig.hz
+++ linux-2.6.26/kernel/Kconfig.hz
@@ -55,4 +55,4 @@ config HZ
 	default 1000 if HZ_1000
 
 config SCHED_HRTICK
-	def_bool HIGH_RES_TIMERS && X86
+	def_bool HIGH_RES_TIMERS && X86 && BROKEN

-- 

