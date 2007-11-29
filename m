Return-Path: <linux-kernel-owner+w=401wt.eu-S1760018AbXK2HjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018AbXK2HjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 02:39:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759144AbXK2HiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 02:38:09 -0500
Received: from [222.73.24.84] ([222.73.24.84]:64187 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759006AbXK2HiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 02:38:06 -0500
Message-ID: <474E6BCA.6060201@cn.fujitsu.com>
Date: Thu, 29 Nov 2007 15:35:38 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       trivial@kernel.org
Subject: [PATCH 5/6] time: delete comments that refer to noexistent symbols
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Function do_timer_interrupt_hook() don't take argument regs,
and structure hrtimer_sleeper don't have member cb_pending.
So delete comments refering to these symbols.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 include/asm-x86/mach-voyager/do_timer.h |    1 -
 include/linux/hrtimer.h                 |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/mach-voyager/do_timer.h b/include/asm-x86/mach-voyager/do_timer.h
index bc2b589..9e5a459 100644
--- a/include/asm-x86/mach-voyager/do_timer.h
+++ b/include/asm-x86/mach-voyager/do_timer.h
@@ -6,7 +6,6 @@
 
 /**
  * do_timer_interrupt_hook - hook into timer tick
- * @regs:     standard registers from interrupt
  *
  * Call the pit clock event handler. see asm/i8253.h
  **/
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 0a23302..d42c6be 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -149,7 +149,6 @@ struct hrtimer_sleeper {
  * @get_time:		function to retrieve the current time of the clock
  * @get_softirq_time:	function to retrieve the current time from the softirq
  * @softirq_time:	the time when running the hrtimer queue in the softirq
- * @cb_pending:		list of timers where the callback is pending
  * @offset:		offset of this clock to the monotonic base
  * @reprogram:		function to reprogram the timer event
  */
-- 
1.5.3.rc7

