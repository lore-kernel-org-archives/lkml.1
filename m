Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143Ab0AVSS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab0AVSS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 13:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756078Ab0AVSSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 13:18:25 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:48328 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab0AVSSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 13:18:24 -0500
From: Himanshu Chauhan <himanshu@symmetricore.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] USB-IP: Small clean up based on previous comments.
Date: Fri, 22 Jan 2010 23:50:37 +0530
Message-Id: <1264184437-6971-2-git-send-email-himanshu@symmetricore.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1264184437-6971-1-git-send-email-himanshu@symmetricore.com>
References: <1264184437-6971-1-git-send-email-himanshu@symmetricore.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to take a look at usb-ip to get it into mainline.
This is a small patch (my first patch ever) in this regard.

Please let me know the comments.

Thanks

Regards
Himanshu

---
 drivers/staging/usbip/usbip_common.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index ddb6f5f..57c0ff5 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -55,10 +55,7 @@ static ssize_t show_flag(struct device *dev, struct device_attribute *attr,
 static ssize_t store_flag(struct device *dev, struct device_attribute *attr,
 		const char *buf, size_t count)
 {
-	unsigned long flag;
-
-	sscanf(buf, "%lx", &flag);
-	usbip_debug_flag = flag;
+	sscanf(buf, "%lx", &usbip_debug_flag);
 
 	return count;
 }
-- 
1.6.3.3

