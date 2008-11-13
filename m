Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbYKMCof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbYKMCof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 21:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYKMCoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 21:44:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:25267 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbYKMCoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 21:44:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fqPRI1utz5SOBKFIf4WhFGa0Y/TvhQjaU7dp4XyY3LGhE40rqe0cA70t34CxLwXKxG
         DUYa0hD8of8cNtfG6XFQU6eeFW+CZWBFRR9HhmX04RYc33qpf5EZTPSvU5FKmYuZLbAR
         ROtkXi2sDuI0fPiDbPQfCCudMQ/Njm9RPZ4Jw=
Subject: [PATCH 1/2] hid: fix kworld fm700 radio hidquirks
From: Alexey Klimov <klimov.linux@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jirislaby@gmail.com>
Cc: Tobias Lorenz <tobias.lorenz@gmx.net>,
       Mauro Carvalho Chehab <mchehab@redhat.com>, linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LNX.1.10.0811130131190.32143@jikos.suse.cz>
References: <491B3E90.5020307@gmail.com>
	 <alpine.LNX.1.10.0811130131190.32143@jikos.suse.cz>
Content-Type: text/plain
Date: Thu, 13 Nov 2008 05:44:31 +0300
Message-Id: <1226544271.7246.12.camel@tux.localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes kworld fm700 usb-radio hidqurks that handled by
radio-si470x. Removes it from blacklist entry and places it in ignore
entry in hid/hid-core.c

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

---

diff -r 43cd5fe03c6b linux/drivers/hid/hid-core.c
--- a/linux/drivers/hid/hid-core.c	Thu Nov 13 05:08:59 2008 +0300
+++ b/linux/drivers/hid/hid-core.c	Thu Nov 13 05:12:13 2008 +0300
@@ -1265,7 +1265,6 @@
 	{ HID_USB_DEVICE(USB_VENDOR_ID_EZKEY, USB_DEVICE_ID_BTC_8193) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GENERIC_13BA, USB_DEVICE_ID_GENERIC_13BA_KBD_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_KWORLD, USB_DEVICE_ID_KWORLD_RADIO_FM700) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE_2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LABTEC, USB_DEVICE_ID_LABTEC_WIRELESS_KEYBOARD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER) },
@@ -1486,6 +1485,7 @@
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GTCO, USB_DEVICE_ID_GTCO_1007) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_IMATION, USB_DEVICE_ID_DISC_STAKKA) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KBGEAR, USB_DEVICE_ID_KBGEAR_JAMSTUDIO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_KWORLD, USB_DEVICE_ID_KWORLD_RADIO_FM700) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_GPEN_560) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_CASSY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_POCKETCASSY) },


-- 
Best regards, Klimov Alexey

