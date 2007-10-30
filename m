Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbXJ3Ide@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbXJ3Ide (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 04:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbXJ3Id0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 04:33:26 -0400
Received: from [222.73.24.84] ([222.73.24.84]:56012 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbXJ3IdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 04:33:25 -0400
Message-ID: <4726EBC8.1080806@cn.fujitsu.com>
Date: Tue, 30 Oct 2007 16:31:04 +0800
From: lizf <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] time: fix inconsistent function names in comments
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 kernel/time/tick-broadcast.c |    2 +-
 kernel/time/tick-sched.c     |    2 +-
 kernel/timer.c               |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 8cfb8b2..aa82d7b 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -508,7 +508,7 @@ static void tick_broadcast_clear_oneshot(int cpu)
 }
 
 /**
- * tick_broadcast_setup_highres - setup the broadcast device for highres
+ * tick_broadcast_setup_oneshot - setup the broadcast device
  */
 void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 10a1347..fa99734 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -323,7 +323,7 @@ ktime_t tick_nohz_get_sleep_length(void)
 EXPORT_SYMBOL_GPL(tick_nohz_get_sleep_length);
 
 /**
- * nohz_restart_sched_tick - restart the idle tick from the idle task
+ * tick_nohz_restart_sched_tick - restart the idle tick from the idle task
  *
  * Restart the idle tick when the CPU is woken up from idle
  */
diff --git a/kernel/timer.c b/kernel/timer.c
index fb4e67d..00e44e2 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -790,7 +790,7 @@ static unsigned long cmp_next_hrtimer_event(unsigned long now,
 }
 
 /**
- * next_timer_interrupt - return the jiffy of the next pending timer
+ * get_next_timer_interrupt - return the jiffy of the next pending timer
  * @now: current time (in jiffies)
  */
 unsigned long get_next_timer_interrupt(unsigned long now)
-- 
1.5.3.rc7

