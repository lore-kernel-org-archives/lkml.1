Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbZIXWjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbZIXWjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 18:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbZIXWjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 18:39:52 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:52634 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbZIXWjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 18:39:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=SV0ZIhJXN0tLrw3D6rGdXuGDFhu0mKAwIFNGG3JYCg6ih3H3ro8iMsSU64vKcbQmmB
         5ne+qG2usBnX9AHTArKR3G/hu1Np854qZOC5RBpP4LYCNmF0yzLOju6wcDnvzs267JZx
         0nDEPrW6L9Z2nJ2+NhNvHfp9lliw0hEMP37Xk=
Message-ID: <4ABBF538.3080409@gmail.com>
Date: Thu, 24 Sep 2009 15:39:52 -0700
From: Bruce Jones <brucej97223@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: gregkh@suse.de
CC: forensixs@gmx.de, mithlesh@linsyssoft.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: cleanup formatting in drivers/vmk80xx.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up formatting of a struct initializer, as per the
standard conventions.

Signed-off-by: Bruce Jones <brucej@linux.com>
---
 drivers/staging/comedi/drivers/vmk80xx.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index c335040..c34a0b9 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -76,18 +76,18 @@ enum {
 };
 
 static struct usb_device_id vmk80xx_id_table[] = {
-	{USB_DEVICE(0x10cf, 0x5500),.driver_info = DEVICE_VMK8055},
-	{USB_DEVICE(0x10cf, 0x5501),.driver_info = DEVICE_VMK8055},
-	{USB_DEVICE(0x10cf, 0x5502),.driver_info = DEVICE_VMK8055},
-	{USB_DEVICE(0x10cf, 0x5503),.driver_info = DEVICE_VMK8055},
-	{USB_DEVICE(0x10cf, 0x8061),.driver_info = DEVICE_VMK8061},
-	{USB_DEVICE(0x10cf, 0x8062),.driver_info = DEVICE_VMK8061},
-	{USB_DEVICE(0x10cf, 0x8063),.driver_info = DEVICE_VMK8061},
-	{USB_DEVICE(0x10cf, 0x8064),.driver_info = DEVICE_VMK8061},
-	{USB_DEVICE(0x10cf, 0x8065),.driver_info = DEVICE_VMK8061},
-	{USB_DEVICE(0x10cf, 0x8066),.driver_info = DEVICE_VMK8061},
-	{USB_DEVICE(0x10cf, 0x8067),.driver_info = DEVICE_VMK8061},
-	{USB_DEVICE(0x10cf, 0x8068),.driver_info = DEVICE_VMK8061},
+	{USB_DEVICE(0x10cf, 0x5500), .driver_info = DEVICE_VMK8055},
+	{USB_DEVICE(0x10cf, 0x5501), .driver_info = DEVICE_VMK8055},
+	{USB_DEVICE(0x10cf, 0x5502), .driver_info = DEVICE_VMK8055},
+	{USB_DEVICE(0x10cf, 0x5503), .driver_info = DEVICE_VMK8055},
+	{USB_DEVICE(0x10cf, 0x8061), .driver_info = DEVICE_VMK8061},
+	{USB_DEVICE(0x10cf, 0x8062), .driver_info = DEVICE_VMK8061},
+	{USB_DEVICE(0x10cf, 0x8063), .driver_info = DEVICE_VMK8061},
+	{USB_DEVICE(0x10cf, 0x8064), .driver_info = DEVICE_VMK8061},
+	{USB_DEVICE(0x10cf, 0x8065), .driver_info = DEVICE_VMK8061},
+	{USB_DEVICE(0x10cf, 0x8066), .driver_info = DEVICE_VMK8061},
+	{USB_DEVICE(0x10cf, 0x8067), .driver_info = DEVICE_VMK8061},
+	{USB_DEVICE(0x10cf, 0x8068), .driver_info = DEVICE_VMK8061},
 	{}			/* terminating entry */
 };
 
-- 
1.6.5.rc2
