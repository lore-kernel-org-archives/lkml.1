Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbZFDOUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbZFDOUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755915AbZFDOUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:20:35 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:10478 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbZFDOUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:20:33 -0400
Date: Thu, 4 Jun 2009 16:20:28 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH] Typo: ETIMEOUT -> ETIMEDOUT
Message-ID: <20090604162028.7919ff89@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 arch/arm/mach-sa1100/jornada720_ssp.c |    4 ++--
 drivers/net/qlge/qlge_main.c          |    2 +-
 drivers/net/usb/usbnet.c              |    2 +-
 drivers/staging/wlan-ng/hfa384x_usb.c |    2 +-
 kernel/rtmutex.c                      |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.30-rc8.orig/arch/arm/mach-sa1100/jornada720_ssp.c	2009-03-24 13:40:33.000000000 +0100
+++ linux-2.6.30-rc8/arch/arm/mach-sa1100/jornada720_ssp.c	2009-06-04 15:32:23.000000000 +0200
@@ -54,7 +54,7 @@ EXPORT_SYMBOL(jornada_ssp_reverse);
  * timeout after <timeout> rounds. Needs mcu running before its called.
  *
  * returns : %mcu output on success
- *	   : %-ETIMEOUT on timeout
+ *	   : %-ETIMEDOUT on timeout
  */
 int jornada_ssp_byte(u8 byte)
 {
@@ -82,7 +82,7 @@ EXPORT_SYMBOL(jornada_ssp_byte);
  * jornada_ssp_inout - decide if input is command or trading byte
  *
  * returns : (jornada_ssp_byte(byte)) on success
- *         : %-ETIMEOUT on timeout failure
+ *         : %-ETIMEDOUT on timeout failure
  */
 int jornada_ssp_inout(u8 byte)
 {
--- linux-2.6.30-rc8.orig/drivers/net/qlge/qlge_main.c	2009-04-08 08:53:10.000000000 +0200
+++ linux-2.6.30-rc8/drivers/net/qlge/qlge_main.c	2009-06-04 15:32:12.000000000 +0200
@@ -3174,7 +3174,7 @@ static int ql_adapter_reset(struct ql_ad
 
 	if (value & RST_FO_FR) {
 		QPRINTK(qdev, IFDOWN, ERR,
-			"ETIMEOUT!!! errored out of resetting the chip!\n");
+			"ETIMEDOUT!!! errored out of resetting the chip!\n");
 		status = -ETIMEDOUT;
 	}
 
--- linux-2.6.30-rc8.orig/drivers/net/usb/usbnet.c	2009-04-08 08:53:12.000000000 +0200
+++ linux-2.6.30-rc8/drivers/net/usb/usbnet.c	2009-06-04 15:32:03.000000000 +0200
@@ -398,7 +398,7 @@ static void rx_complete (struct urb *urb
 
 	/* stalls need manual reset. this is rare ... except that
 	 * when going through USB 2.0 TTs, unplug appears this way.
-	 * we avoid the highspeed version of the ETIMEOUT/EILSEQ
+	 * we avoid the highspeed version of the ETIMEDOUT/EILSEQ
 	 * storm, recovering as needed.
 	 */
 	case -EPIPE:
--- linux-2.6.30-rc8.orig/drivers/staging/wlan-ng/hfa384x_usb.c	2009-04-08 08:53:33.000000000 +0200
+++ linux-2.6.30-rc8/drivers/staging/wlan-ng/hfa384x_usb.c	2009-06-04 15:31:47.000000000 +0200
@@ -2424,7 +2424,7 @@ int hfa384x_drvr_ramdl_write(hfa384x_t *
 *	0		success
 *	>0		f/w reported error - f/w status code
 *	<0		driver reported error
-*	-ETIMEOUT	timout waiting for the cmd regs to become
+*	-ETIMEDOUT	timout waiting for the cmd regs to become
 *			available, or waiting for the control reg
 *			to indicate the Aux port is enabled.
 *	-ENODATA	the buffer does NOT contain a valid PDA.
--- linux-2.6.30-rc8.orig/kernel/rtmutex.c	2009-03-24 13:42:21.000000000 +0100
+++ linux-2.6.30-rc8/kernel/rtmutex.c	2009-06-04 15:31:40.000000000 +0200
@@ -875,7 +875,7 @@ EXPORT_SYMBOL_GPL(rt_mutex_lock_interrup
  * Returns:
  *  0 		on success
  * -EINTR 	when interrupted by a signal
- * -ETIMEOUT	when the timeout expired
+ * -ETIMEDOUT	when the timeout expired
  * -EDEADLK	when the lock would deadlock (when deadlock detection is on)
  */
 int


-- 
Jean Delvare
