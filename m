Return-Path: <linux-kernel-owner+w=401wt.eu-S1751909AbXBVVWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbXBVVWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbXBVVWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:22:24 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:35174 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbXBVVWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:22:23 -0500
X-Originating-Ip: 74.109.98.130
Date: Thu, 22 Feb 2007 16:19:16 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org
Subject: [PATCH] Correct comment to refer to proper /proc file.
Message-ID: <Pine.LNX.4.64.0702221617130.7104@CPE00045a9c397f-CM001225dbafb6>
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


  Correct a comment that information is exported via, not /proc/rtc,
but /proc/driver/rtc.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/drivers/char/genrtc.c b/drivers/char/genrtc.c
index 23b25ad..ea05265 100644
--- a/drivers/char/genrtc.c
+++ b/drivers/char/genrtc.c
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
