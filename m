Return-Path: <linux-kernel-owner+w=401wt.eu-S1030686AbXEKTnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030686AbXEKTnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762876AbXEKTl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:41:26 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:45931 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762853AbXEKTlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:41:24 -0400
Message-ID: <4644C6E0.60309@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:41:20 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dhowells@redhat.com, trivial@kernel.org
Subject: [PATCH] spelling fixes: arch/frv/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in arch/frv/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/frv/kernel/irq.c       |    2 +-
 arch/frv/kernel/semaphore.c |    2 +-
 arch/frv/kernel/time.c      |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/frv/kernel/irq.c b/arch/frv/kernel/irq.c
index c7e59dc..206eba5 100644
--- a/arch/frv/kernel/irq.c
+++ b/arch/frv/kernel/irq.c
@@ -134,7 +134,7 @@ static struct irq_chip frv_cpu_pic = {
 };
 
 /*
- * handles all normal device IRQ's
+ * handles all normal device IRQs
  * - registers are referred to by the __frame variable (GR28)
  * - IRQ distribution is complicated in this arch because of the many PICs, the
  *   way they work and the way they cascade
diff --git a/arch/frv/kernel/semaphore.c b/arch/frv/kernel/semaphore.c
index 8e182ce..7ee3a14 100644
--- a/arch/frv/kernel/semaphore.c
+++ b/arch/frv/kernel/semaphore.c
@@ -139,7 +139,7 @@ void __up(struct semaphore *sem)
 	waiter = list_entry(sem->wait_list.next, struct sem_waiter, list);
 
 	/* We must be careful not to touch 'waiter' after we set ->task = NULL.
-	 * It is an allocated on the waiter's stack and may become invalid at
+	 * It is allocated on the waiter's stack and may become invalid at
 	 * any time after that point (due to a wakeup from another source).
 	 */
 	list_del_init(&waiter->list);
diff --git a/arch/frv/kernel/time.c b/arch/frv/kernel/time.c
index ed588d7..2923afa 100644
--- a/arch/frv/kernel/time.c
+++ b/arch/frv/kernel/time.c
@@ -63,7 +63,7 @@ static irqreturn_t timer_interrupt(int irq, void *dummy)
 	/*
 	 * Here we are in the timer irq handler. We just have irqs locally
 	 * disabled but we don't know if the timer_bh is running on the other
-	 * CPU. We need to avoid to SMP race with it. NOTE: we don' t need
+	 * CPU. We need to avoid to SMP race with it. NOTE: we don't need
 	 * the irq version of write_lock because as just said we have irq
 	 * locally disabled. -arca
 	 */
@@ -123,7 +123,7 @@ void time_init(void)
 
 	/* FIX by dqg : Set to zero for platforms that don't have tod */
 	/* without this time is undefined and can overflow time_t, causing  */
-	/* very stange errors */
+	/* very strange errors */
 	year = 1980;
 	mon = day = 1;
 	hour = min = sec = 0;
-- 
1.5.0.1

-- 
Simon Arlott
