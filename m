Return-Path: <linux-kernel-owner+w=401wt.eu-S1764905AbXLQTq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764905AbXLQTq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045AbXLQTcC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:32:02 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3021 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761214AbXLQTb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:57 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Airlie <airlied@linux.ie>,
       Jonathan Buzzard <jonathan@buzzard.org.uk>,
       "Michael H. Warfield" <mhw@wittsend.com>,
       dri-devel@lists.sourceforge.net, tlinux-users@linux.toshiba-dme.co.jp
Subject: [PATCH] drivers/char/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:31 -0800
Message-Id: <1197919875-5288-32-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/char/drm/r300_reg.h    |    2 +-
 drivers/char/drm/via_dma.c     |    2 +-
 drivers/char/efirtc.c          |    2 +-
 drivers/char/epca.c            |    4 ++--
 drivers/char/hangcheck-timer.c |    2 +-
 drivers/char/hvcs.c            |    2 +-
 drivers/char/ip2/i2lib.c       |    2 +-
 drivers/char/ip2/ip2main.c     |    2 +-
 drivers/char/synclink.c        |    2 +-
 drivers/char/toshiba.c         |    2 +-
 10 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/char/drm/r300_reg.h b/drivers/char/drm/r300_reg.h
index 3ae57ec..fa194a4 100644
--- a/drivers/char/drm/r300_reg.h
+++ b/drivers/char/drm/r300_reg.h
@@ -584,7 +584,7 @@ USE OR OTHER DEALINGS IN THE SOFTWARE.
 #define R300_RE_FOG_START                     0x4298
 
 /* Not sure why there are duplicate of factor and constant values.
- * My best guess so far is that there are seperate zbiases for test and write.
+ * My best guess so far is that there are separate zbiases for test and write.
  * Ordering might be wrong.
  * Some of the tests indicate that fgl has a fallback implementation of zbias
  * via pixel shaders.
diff --git a/drivers/char/drm/via_dma.c b/drivers/char/drm/via_dma.c
index 75d6b74..7009dbd 100644
--- a/drivers/char/drm/via_dma.c
+++ b/drivers/char/drm/via_dma.c
@@ -400,7 +400,7 @@ static inline uint32_t *via_align_buffer(drm_via_private_t * dev_priv,
 }
 
 /*
- * This function is used internally by ring buffer mangement code.
+ * This function is used internally by ring buffer management code.
  *
  * Returns virtual pointer to ring buffer.
  */
diff --git a/drivers/char/efirtc.c b/drivers/char/efirtc.c
index 004141d..49233f5 100644
--- a/drivers/char/efirtc.c
+++ b/drivers/char/efirtc.c
@@ -18,7 +18,7 @@
  *
  * NOTES:
  *	- Locking is required for safe execution of EFI calls with regards
- *	  to interrrupts and SMP.
+ *	  to interrupts and SMP.
  *
  * TODO (December 1999):
  * 	- provide the API to set/get the WakeUp Alarm (different from the
diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index ffcecde..ffd747c 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -1797,7 +1797,7 @@ static unsigned termios2digi_c(struct channel *ch, unsigned cflag)
 	res |= cflag & ((CBAUD ^ CBAUDEX) | PARODD | PARENB | CSTOPB | CSIZE);
 	/*
 	 * This gets a little confusing. The Digi cards have their own
-	 * representation of c_cflags controling baud rate. For the most part
+	 * representation of c_cflags controlling baud rate. For the most part
 	 * this is identical to the Linux implementation. However; Digi
 	 * supports one rate (76800) that Linux doesn't. This means that the
 	 * c_cflag entry that would normally mean 76800 for Digi actually means
@@ -2068,7 +2068,7 @@ static int info_ioctl(struct tty_struct *tty, struct file *file,
 		{
 			/*
 			 * This call is made by the apps to complete the
-			 * initilization of the board(s). This routine is
+			 * initialization of the board(s). This routine is
 			 * responsible for setting the card to its initial
 			 * state and setting the drivers control fields to the
 			 * sutianle settings for the card in question.
diff --git a/drivers/char/hangcheck-timer.c b/drivers/char/hangcheck-timer.c
index 0e8ceea..712d9f2 100644
--- a/drivers/char/hangcheck-timer.c
+++ b/drivers/char/hangcheck-timer.c
@@ -26,7 +26,7 @@
  * The hangcheck-timer driver uses the TSC to catch delays that
  * jiffies does not notice.  A timer is set.  When the timer fires, it
  * checks whether it was delayed and if that delay exceeds a given
- * margin of error.  The hangcheck_tick module paramter takes the timer
+ * margin of error.  The hangcheck_tick module parameter takes the timer
  * duration in seconds.  The hangcheck_margin parameter defines the
  * margin of error, in seconds.  The defaults are 60 seconds for the
  * timer and 180 seconds for the margin of error.  IOW, a timer is set
diff --git a/drivers/char/hvcs.c b/drivers/char/hvcs.c
index 69d8866..59a9f7a 100644
--- a/drivers/char/hvcs.c
+++ b/drivers/char/hvcs.c
@@ -850,7 +850,7 @@ static int __devexit hvcs_remove(struct vio_dev *dev)
 	if (!hvcsd)
 		return -ENODEV;
 
-	/* By this time the vty-server won't be getting any more interrups */
+	/* By this time the vty-server won't be getting any more interrupts */
 
 	spin_lock_irqsave(&hvcsd->lock, flags);
 
diff --git a/drivers/char/ip2/i2lib.c b/drivers/char/ip2/i2lib.c
index e46120d..d6567b3 100644
--- a/drivers/char/ip2/i2lib.c
+++ b/drivers/char/ip2/i2lib.c
@@ -661,7 +661,7 @@ i2QueueCommands(int type, i2ChanStrPtr pCh, int timeout, int nCommands,
 		if (!in_interrupt()) {
 			schedule_timeout_interruptible(1);	// short nap
 		} else {
-			// we cannot sched/sleep in interrrupt silly
+			// we cannot sched/sleep in interrupt silly
 			return 0;   
 		}
 		if (signal_pending(current)) {
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index e04e66c..0f49ccf 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -1251,7 +1251,7 @@ ip2_poll(unsigned long arg)
 
 	// Just polled boards, IRQ = 0 will hit all non-interrupt boards.
 	// It will NOT poll boards handled by hard interrupts.
-	// The issue of queued BH interrups is handled in ip2_interrupt().
+	// The issue of queued BH interrupts is handled in ip2_interrupt().
 	ip2_polled_interrupt();
 
 	PollTimer.expires = POLL_TIMEOUT;
diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index 905d1f5..d010ed9 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -1544,7 +1544,7 @@ static void mgsl_isr_receive_data( struct mgsl_struct *info )
 
 /* mgsl_isr_misc()
  * 
- * 	Service a miscellaneos interrupt source.
+ * 	Service a miscellaneous interrupt source.
  * 	
  * Arguments:		info		pointer to device extension (instance data)
  * Return Value:	None
diff --git a/drivers/char/toshiba.c b/drivers/char/toshiba.c
index 5422f99..ce5ebe3 100644
--- a/drivers/char/toshiba.c
+++ b/drivers/char/toshiba.c
@@ -505,7 +505,7 @@ static int __init toshiba_init(void)
 	if (tosh_probe())
 		return -ENODEV;
 
-	printk(KERN_INFO "Toshiba System Managment Mode driver v" TOSH_VERSION "\n");
+	printk(KERN_INFO "Toshiba System Management Mode driver v" TOSH_VERSION "\n");
 
 	/* set the port to use for Fn status if not specified as a parameter */
 	if (tosh_fn==0x00)
-- 
1.5.3.7.949.g2221a6

