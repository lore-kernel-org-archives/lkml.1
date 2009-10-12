Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbZJLGxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbZJLGxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 02:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbZJLGxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 02:53:49 -0400
Received: from [195.39.106.218] ([195.39.106.218]:49720 "EHLO
	trurl.localdomain" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753655AbZJLGxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 02:53:48 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Oct 2009 02:53:48 EDT
From: Lubomir Rintel <lkundrak@v3.sk>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-sound@vger.kernel.org,
       linux-kernel@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] Add match for JMTek USB sound card
Date: Mon, 12 Oct 2009 08:42:40 +0200
Message-Id: <1255329761-24449-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <s5hbpkdf7ft.wl%tiwai@suse.de>
References: <s5hbpkdf7ft.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Entry for JMTek LLC., SSS USB Headphone Set in the quirk table.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
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
1.6.2.5

