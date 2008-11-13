Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbYKMCov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbYKMCov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 21:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbYKMCog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 21:44:36 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:22058 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbYKMCoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 21:44:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wp1GL2Oua7yRnQbi9FGJItMgcnrMrw9njFYudnF3qOlOlytuhLhioeVn3tlwLx46XX
         ouZA5S9At7eS7qdijwRm5hrRJ0es35XxqttaK5TFs/PeWOcod3YTTtdcf17BLE6S6w1t
         WRehLdUEoxyUUWD4c5AtFpjMepZP/owJZ3oNs=
Subject: [PATCH 2/2] hid: fix radio-mr800 hidquirks
From: Alexey Klimov <klimov.linux@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jirislaby@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LNX.1.10.0811130131190.32143@jikos.suse.cz>
References: <491B3E90.5020307@gmail.com>
	 <alpine.LNX.1.10.0811130131190.32143@jikos.suse.cz>
Content-Type: text/plain
Date: Thu, 13 Nov 2008 05:44:50 +0300
Message-Id: <1226544290.7246.14.camel@tux.localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes radio-mr800 hidqurks. Removes it from blacklist entry
and places it in ignore entry in hid/hid-core.c

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

---

diff -r f8813f2b16f7 linux/drivers/hid/hid-core.c
--- a/linux/drivers/hid/hid-core.c	Thu Nov 13 05:39:06 2008 +0300
+++ b/linux/drivers/hid/hid-core.c	Thu Nov 13 05:40:26 2008 +0300
@@ -1252,7 +1252,6 @@
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_JIS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_AVERMEDIA, USB_DEVICE_ID_AVER_FM_MR800) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BRIGHT, USB_DEVICE_ID_BRIGHT_ABNT2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHERRY, USB_DEVICE_ID_CHERRY_CYMOTION) },
@@ -1408,6 +1407,7 @@
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ALCOR, USB_DEVICE_ID_ALCOR_USBRS232) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUS, USB_DEVICE_ID_ASUS_LCM)},
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUS, USB_DEVICE_ID_ASUS_LCM2)},
+	{ HID_USB_DEVICE(USB_VENDOR_ID_AVERMEDIA, USB_DEVICE_ID_AVER_FM_MR800) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BERKSHIRE, USB_DEVICE_ID_BERKSHIRE_PCWD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CIDC, 0x0103) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYGNAL, USB_DEVICE_ID_CYGNAL_RADIO_SI470X) },


> 
-- 
Best regards, Klimov Alexey

