Return-Path: <linux-kernel-owner+w=401wt.eu-S1753717AbYJNOPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbYJNOPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 10:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYJNOOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 10:14:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42101 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156AbYJNOOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 10:14:36 -0400
Date: Tue, 14 Oct 2008 11:10:23 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Jiri Kosina <jikos@jikos.cz>, LKML <linux-kernel@vger.kernel.org>
Cc: Douglas Landgraf <dougsland@gmail.com>,
       Alexey Klimov <klimov.linux@gmail.com>
Subject: [PATCH 3/3] Don't let Avermedia Radio FM800 be detected as a normal
 HID device
Message-ID: <20081014111023.04c8a059@pedra.chehab.org>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on an original patch from Alexey Klimov <klimov.linux@gmail.com>,
against kernel version 2.6.27.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/hid/hid-core.c |    1 +
 drivers/hid/hid-ids.h  |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 1fc1d5c..58f99ff 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1251,6 +1251,7 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_JIS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_AVERMEDIA, USB_DEVICE_ID_AVER_FM_MR800) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BRIGHT, USB_DEVICE_ID_BRIGHT_ABNT2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHERRY, USB_DEVICE_ID_CHERRY_CYMOTION) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 078ede0..b609128 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -96,6 +96,9 @@
 #define USB_DEVICE_ID_ATEN_4PORTKVM	0x2205
 #define USB_DEVICE_ID_ATEN_4PORTKVMC	0x2208
 
+#define USB_VENDOR_ID_AVERMEDIA		0x07ca
+#define USB_DEVICE_ID_AVER_FM_MR800	0xb800
+
 #define USB_VENDOR_ID_BELKIN           0x050d
 #define USB_DEVICE_ID_FLIP_KVM         0x3201
 
-- 
1.5.5.1

