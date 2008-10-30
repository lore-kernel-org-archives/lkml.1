Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbYJ3QSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbYJ3QSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbYJ3QSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:18:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:8573 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093AbYJ3QST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:18:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=pToAy+RxvtpMVjoixzg/j+x3BhC6PsTvpIFPKLL1fKDnHPmGw5nScGuIHr1fQ56ebb
         GPjC8IXaBPElr9y6M06dC7RHToHa7gJ0YqjcV4k8qcq8F0LJg1FEDEx6MKTVMh9JewCZ
         9vFonqioK7jd7nT1Kxwmo5zqXzKVhH0vr1Nh0=
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@suse.cz>
Subject: [PATCH 1/7] w35und: inline DRIVER_AUTHOR and DRIVER_DESC macros
Date: Thu, 30 Oct 2008 18:12:01 +0200
Message-Id: <1225383127-16406-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They're used in one place so we can inline them.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/wbusb.c   |    4 ++--
 drivers/staging/winbond/wbusb_s.h |    3 ---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 40bb77c..67847c8 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -11,8 +11,8 @@
 #include "wbhal_f.h"
 #include "wblinux_f.h"
 
-MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_AUTHOR("Original by: Jeff Lee<YY_Lee@issc.com.tw> Adapted to 2.6.x by Costantino Leandro (Rxart Desktop) <le_costantino@pixartargentina.com.ar>");
+MODULE_DESCRIPTION("IS89C35 802.11bg WLAN USB Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.1");
 
diff --git a/drivers/staging/winbond/wbusb_s.h b/drivers/staging/winbond/wbusb_s.h
index 1aa8ab1..1de9360 100644
--- a/drivers/staging/winbond/wbusb_s.h
+++ b/drivers/staging/winbond/wbusb_s.h
@@ -28,9 +28,6 @@ typedef struct _RW_CONTEXT
 	void*			pCallBackFunctionParameter;
 } RW_CONTEXT, *PRW_CONTEXT;
 
-#define DRIVER_AUTHOR "Original by: Jeff Lee<YY_Lee@issc.com.tw> Adapted to 2.6.x by Costantino Leandro (Rxart Desktop) <le_costantino@pixartargentina.com.ar>"
-#define DRIVER_DESC   "IS89C35 802.11bg WLAN USB Driver"
-
 typedef struct _WBUSB {
 	u32	IsUsb20;
 	struct usb_device *udev;
-- 
1.5.3.7

