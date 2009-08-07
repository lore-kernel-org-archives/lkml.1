Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbZHGErO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbZHGErO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 00:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbZHGErN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 00:47:13 -0400
Received: from szxga04-in.huawei.com ([119.145.14.67]:46441 "EHLO
	szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbZHGErM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 00:47:12 -0400
X-Greylist: delayed 806 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Aug 2009 00:47:12 EDT
Date: Fri, 07 Aug 2009 12:30:35 +0800
From: fangxiaozhi 00110321 <huananhu@huawei.com>
Subject: [PATCH 7/8]linux-usb:usb-storage fails to attach to Huawei Datacard
 cdrom device, fix kernel 2.6.31-rc4
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, zihan@huawei.com, greg@kroah.com
Message-id: <fa3ec44c288d2.288d2fa3ec44c@huawei.com>
MIME-version: 1.0
X-Mailer: iPlanet Messenger Express 5.2 HotFix 2.14 (built Aug  8 2006)
Content-type: text/plain; charset=us-ascii
Content-language: zh-CN
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-Accept-Language: zh-CN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: fangxiaozhi <huananhu@huawei.com>
1. This patch is based on the kernel of 2.6.31-rc4 
2. In this patch, we always make the return value of function usb_stor_huawei_e220_init to be zero. Then it will not prevent usb-storage driver from attaching to the CDROM device of Huawei Datacard.
Signed-off-by: fangxiaozhi <huananhu@huawei.com>

----------------------------------------------------------------------------------------------------------------
--- linux-2.6.31-rc4-orig/drivers/usb/storage/initializers.c	2009-07-23 10:32:59.000000000 +0800
+++ linux-2.6.31-rc4/drivers/usb/storage/initializers.c	2009-08-05 06:35:47.000000000 +0800
@@ -102,5 +102,5 @@ int usb_stor_huawei_e220_init(struct us_
 				      USB_TYPE_STANDARD | USB_RECIP_DEVICE,
 				      0x01, 0x0, NULL, 0x0, 1000);
 	US_DEBUGP("Huawei mode set result is %d\n", result);
-	return (result ? 0 : -ENODEV);
+	return 0;
 }



******************************************************************************************
 This email and its attachments contain confidential information from HUAWEI, which is intended only for the person or entity whose address is listed above. Any use of the information contained here in any way (including, but not limited to, total or partial disclosure, reproduction, or dissemination) by persons other than the intended recipient(s) is prohibited. If you receive this email in error, please notify the sender by phone or email
 immediately and delete it!
 *****************************************************************************************
