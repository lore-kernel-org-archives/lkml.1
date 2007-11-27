Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbXK0MQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbXK0MQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 07:16:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbXK0MP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 07:15:57 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:47190 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbXK0MP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 07:15:56 -0500
Date: Tue, 27 Nov 2007 13:16:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>,
       kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>
Subject: [patch] More timer related cleanups
Message-ID: <20071127121633.GA2596@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was confused by FSEC = 10^15 NSEC statement, plus small whitespace
fixes. When there's copyright, there should be GPL.

Signed-off-by: Pavel Machek <pavel@suse.cz>


diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 53303f2..be5d5b6 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -16,7 +16,8 @@ #include <asm/io.h>
 #define HPET_MASK	CLOCKSOURCE_MASK(32)
 #define HPET_SHIFT	22
 
-/* FSEC = 10^-15 NSEC = 10^-9 */
+/* FSEC = 10^-15 
+   NSEC = 10^-9 */
 #define FSEC_PER_NSEC	1000000
 
 /*
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6309b27..7814db7 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -196,7 +196,7 @@ #endif /* CONFIG_HOTPLUG_CPU */
  * low exit latency (ie sit in a loop waiting for
  * somebody to say that they'd like to reschedule)
  */
-void cpu_idle (void)
+void cpu_idle(void)
 {
 	current_thread_info()->status |= TS_POLLING;
 	/* endless idle loop with no priority at all */
diff --git a/kernel/softirq.c b/kernel/softirq.c
index bd89bc4..8fe1ff4 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -3,7 +3,9 @@
  *
  *	Copyright (C) 1992 Linus Torvalds
  *
- * Rewritten. Old one was good in 2.2, but in 2.3 it was immoral. --ANK (990903)
+ *	Distribute under GPLv2.
+ *
+ *	Rewritten. Old one was good in 2.2, but in 2.3 it was immoral. --ANK (990903)
  */
 
 #include <linux/module.h>
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6fa66f7..31f02d0 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -9,7 +9,7 @@
  *
  *  Started by: Thomas Gleixner and Ingo Molnar
  *
- *  For licencing details see kernel-base/COPYING
+ *  Distribute under GPLv2.
  */
 #include <linux/cpu.h>
 #include <linux/err.h>
diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index c36bb7e..417da8c 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -26,7 +26,7 @@
  * the pid and cmdline from the owner process if applicable.
  *
  * Start/stop data collection:
- * # echo 1[0] >/proc/timer_stats
+ * # echo [1|0] >/proc/timer_stats
  *
  * Display the information collected so far:
  * # cat /proc/timer_stats



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
