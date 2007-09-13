Return-Path: <linux-kernel-owner+w=401wt.eu-S1758993AbXIMAr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993AbXIMAr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 20:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbXIMArS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 20:47:18 -0400
Received: from mylar.outflux.net ([69.93.193.226]:34927 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbXIMArS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 20:47:18 -0400
Date: Wed, 12 Sep 2007 17:47:10 -0700
From: Kees Cook <kees@ubuntu.com>
To: linux-kernel@vger.kernel.org, Ben Collins <bcollins@ubuntu.com>
Subject: [PATCH] usb: fix unterminated usn_device_id lists
Message-ID: <20070913004709.GL8183@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Ubuntu
X-HELO: gorgon.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch against 2.6.23-rc6 fixes a unterminated list of USB device ids.

Signed-off-by: Kees Cook <kees@ubuntu.com>
---
 linux-2.6.23-rc6/drivers/media/video/usbvision/usbvision-cards.c |    1 +
 1 file changed, 1 insertion(+)
---
diff -urp -x '*.o' linux-2.6.23-rc6~/drivers/media/video/usbvision/usbvision-cards.c linux-2.6.23-rc6/drivers/media/video/usbvision/usbvision-cards.c
--- linux-2.6.23-rc6~/drivers/media/video/usbvision/usbvision-cards.c	2007-09-11 23:17:19.000000000 -0700
+++ linux-2.6.23-rc6/drivers/media/video/usbvision/usbvision-cards.c	2007-09-12 17:26:46.000000000 -0700
@@ -1081,6 +1081,7 @@ struct usb_device_id usbvision_table [] 
 	{ USB_DEVICE(0x2304, 0x0301), .driver_info=PINNA_LINX_VD_IN_CAB_PAL },
 	{ USB_DEVICE(0x2304, 0x0419), .driver_info=PINNA_PCTV_BUNGEE_PAL_FM },
 	{ USB_DEVICE(0x2400, 0x4200), .driver_info=HPG_WINTV },
+	{ 0, },
 };
 
 MODULE_DEVICE_TABLE (usb, usbvision_table);


-- 
Kees Cook
