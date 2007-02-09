Return-Path: <linux-kernel-owner+w=401wt.eu-S1946634AbXBIQiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946634AbXBIQiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946633AbXBIQiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:38:08 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51657 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946635AbXBIQiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:38:06 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] trivial __user annotations - rtc-dev
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HFYlB-0006k4-Jq@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:38:05 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/rtc/rtc-dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index 94d3df6..82f2ac8 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -305,7 +305,7 @@ static int rtc_dev_ioctl(struct inode *inode, struct file *file,
 
 	case RTC_IRQP_READ:
 		if (ops->irq_set_freq)
-			err = put_user(rtc->irq_freq, (unsigned long *) arg);
+			err = put_user(rtc->irq_freq, (unsigned long __user *)uarg);
 		break;
 
 	case RTC_IRQP_SET:
-- 
1.5.0-rc2.GIT


