Return-Path: <linux-kernel-owner+w=401wt.eu-S1760181AbZJIBjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181AbZJIBjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 21:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760143AbZJIBi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 21:38:57 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:39898 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760132AbZJIBi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 21:38:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Rrprz9tEqeWNhzR8pFkD1EZ4zqm4wZXKK4dvy8Un9aTwqCm7f0foFexM6qInWJpzxf
         1u/twt7DWCzqbDni/VKly0hJmGwEB2KRn2AEbjlCws5ezfc3oRJvsPcoHLvzz/Bv5qH/
         /25f1onUluVT9HbQUA1d9Gp4NyQ6N9cfNbS/I=
From: Bruce Beare <bbeare1@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Manuel Gebele <forensixs@gmx.de>,
       Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org,
       Bruce Beare <bbeare@localhost.localdomain>,
       Bruce Beare <bbeare1@gmail.com>
Subject: [PATCH] Space required before ".member = ..." in structure defn/assignments.
Date: Thu,  8 Oct 2009 18:38:18 -0700
Message-Id: <1255052298-5856-1-git-send-email-bbeare1@gmail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <bbeare1@gmail.com>
References: <bbeare1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruce Beare <bbeare@localhost.localdomain>


Signed-off-by: Bruce Beare <bbeare1@gmail.com>
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
1.6.2.5

