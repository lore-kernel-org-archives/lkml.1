Return-Path: <linux-kernel-owner+w=401wt.eu-S1755692AbZJJLkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbZJJLkJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 07:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbZJJLkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 07:40:07 -0400
Received: from r11na27.net.upc.cz ([94.113.108.27]:53321 "EHLO
	bimbo.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754229AbZJJLkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 07:40:06 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: alsa-devel@alsa-project.org, linux-sound@vger.kernel.org,
       linux-kernel@vger.kernel.org, tiwai@suse.de
Cc: Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] [snd-usb-audio] Add match for JMTek USB sound card
Date: Sat, 10 Oct 2009 13:15:29 +0200
Message-Id: <1255173329-20485-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.6.5.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Entry for JMTek LLC., SSS USB Headphone Set in the quirk table.
---
 sound/usb/usbquirks.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/sound/usb/usbquirks.h b/sound/usb/usbquirks.h
index f6f201e..e98ff4c 100644
--- a/sound/usb/usbquirks.h
+++ b/sound/usb/usbquirks.h
@@ -80,6 +80,19 @@
 	.bInterfaceClass = USB_CLASS_AUDIO,
 },
 
+/* JMTek, LLC. SSS USB Headphone Set */
+{
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
+		       USB_DEVICE_ID_MATCH_DEV_CLASS |
+		       USB_DEVICE_ID_MATCH_INT_CLASS |
+		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
+	.idVendor = 0x0c76,
+	.idProduct = 0x1605,
+	.bDeviceClass = USB_CLASS_PER_INTERFACE,
+	.bInterfaceClass = USB_CLASS_AUDIO,
+	.bInterfaceSubClass = USB_SUBCLASS_AUDIO_CONTROL
+},
+
 /*
  * Logitech QuickCam: bDeviceClass is vendor-specific, so generic interface
  * class matches do not take effect without an explicit ID match.
-- 
1.6.5.rc2

