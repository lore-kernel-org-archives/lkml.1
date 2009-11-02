Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbZKBQ7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbZKBQ7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbZKBQ7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:59:38 -0500
Received: from xylophone.i-cable.com ([203.83.115.99]:39586 "HELO
	xylophone.i-cable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755871AbZKBQ7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:59:37 -0500
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Nov 2009 11:59:36 EST
From: Zhang Le <r0bertz@gentoo.org>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, smurf@smurf.noris.de,
       Zhang Le <r0bertz@gentoo.org>
Subject: [PATCH] USB: option.c: add support for D-Link DWM-162-U5
Date: Tue,  3 Nov 2009 00:51:22 +0800
Message-Id: <1257180682-28534-1-git-send-email-r0bertz@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add D-Link DWM-162-U5 device id 1e0e:ce16 into option driver. The device
has 4 interfaces, of which 1 is handled by storage and the other 3 by
option driver.

The device appears first as CD-only 05c6:2100 device and must be
switched to 1e0e:ce16 mode either by using "eject CD" or usb_modeswitch.

The MessageContent for usb_modeswitch.conf is:
"55534243e0c26a85000000000000061b000000020000000000000000000000"

Signed-off-by: Zhang Le <r0bertz@gentoo.org>
---
 drivers/usb/serial/option.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 0101548..ad1db27 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -584,6 +584,7 @@ static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H20_4519) },
 	{ USB_DEVICE(TOSHIBA_VENDOR_ID, TOSHIBA_PRODUCT_HSDPA_MINICARD ) }, /* Toshiba 3G HSDPA == Novatel Expedite EU870D MiniCard */
 	{ USB_DEVICE(ALINK_VENDOR_ID, 0x9000) },
+	{ USB_DEVICE(ALINK_VENDOR_ID, 0xce16) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ALINK_VENDOR_ID, ALINK_PRODUCT_3GU, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X060S) },
 	{ } /* Terminating entry */
-- 
1.6.5.1

