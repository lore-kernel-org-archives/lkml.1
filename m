Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924AbXBVVeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbXBVVeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbXBVVeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:34:19 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:35859 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbXBVVeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:34:18 -0500
X-Originating-Ip: 74.109.98.130
Date: Thu, 22 Feb 2007 16:31:00 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org
Subject: [PATCH][REVISED] Correct comments in genrtc.c to refer to correct
 /proc file.
Message-ID: <Pine.LNX.4.64.0702221628470.14015@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Correct documentation in genrtc.c to refer to the correct /proc
file that's used to export information: /proc/driver/rtc.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  oops ... scratch that last submission.

diff --git a/drivers/char/genrtc.c b/drivers/char/genrtc.c
index 23b25ad..63c12bd 100644
--- a/drivers/char/genrtc.c
+++ b/drivers/char/genrtc.c
@@ -12,7 +12,7 @@
  *
  *	This driver allows use of the real time clock (built into
  *	nearly all computers) from user space. It exports the /dev/rtc
- *	interface supporting various ioctl() and also the /proc/dev/rtc
+ *	interface supporting various ioctl() and also the /proc/driver/rtc
  *	pseudo-file for status information.
  *
  *	The ioctls can be used to set the interrupt behaviour where
@@ -377,7 +377,7 @@ static int gen_rtc_release(struct inode *inode, struct file *file)
 #ifdef CONFIG_PROC_FS

 /*
- *	Info exported via "/proc/rtc".
+ *	Info exported via "/proc/driver/rtc".
  */

 static int gen_rtc_proc_output(char *buf)

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
