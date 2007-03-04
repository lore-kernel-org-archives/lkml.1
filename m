Return-Path: <linux-kernel-owner+w=401wt.eu-S1751612AbXCDMrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbXCDMrP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 07:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbXCDMrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 07:47:15 -0500
Received: from mail.queued.net ([207.210.101.209]:3057 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbXCDMrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 07:47:14 -0500
Message-ID: <45EABFD1.9010800@debian.org>
Date: Sun, 04 Mar 2007 07:47:13 -0500
From: Andres Salomon <dilinger@debian.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] hrtimers: fix HRTIMER_CB_IRQSAFE_NO_SOFTIRQ description
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------040307020600030402070109"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040307020600030402070109
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The description for HRTIMER_CB_IRQSAFE_NO_SOFTIRQ is backwards; "NO
SOFTIRQ" sounds a whole lot like it means it must not be run in a
softirq.   :)

(Resending; forgot to sign off)

Signed-off-by: Andres Salomon <dilinger@debian.org>

--------------040307020600030402070109
Content-Type: text/x-patch;
 name="hrtimer1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hrtimer1.patch"

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 3bef961..b9f163d 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -47,7 +47,7 @@ enum hrtimer_restart {
  *	HRTIMER_CB_IRQSAFE:		Callback may run in hardirq context
  *	HRTIMER_CB_IRQSAFE_NO_RESTART:	Callback may run in hardirq context and
  *					does not restart the timer
- *	HRTIMER_CB_IRQSAFE_NO_SOFTIRQ:	Callback must run in softirq context
+ *	HRTIMER_CB_IRQSAFE_NO_SOFTIRQ:	Callback must run in hardirq context
  *					Special mode for tick emultation
  */
 enum hrtimer_cb_mode {

--------------040307020600030402070109--
