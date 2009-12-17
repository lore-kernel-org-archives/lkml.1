Return-Path: <linux-kernel-owner+w=401wt.eu-S1760440AbZLQBoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760440AbZLQBoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758643AbZLQBnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:43:31 -0500
Received: from kroah.org ([198.145.64.141]:47847 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763595AbZLQBUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:06 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:00 2009
Message-Id: <20091217011600.862764776@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhang Le <r0bertz@gentoo.org>
Subject: [23/90] USB: option.c: add support for D-Link DWM-162-U5
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhang Le <r0bertz@gentoo.org>

commit 54a8e144acad6506920f385f4ef2779664f05b21 upstream.

Add D-Link DWM-162-U5 device id 1e0e:ce16 into option driver.  The device
has 4 interfaces, of which 1 is handled by storage and the other 3 by
option driver.

The device appears first as CD-only 05c6:2100 device and must be switched
to 1e0e:ce16 mode either by using "eject CD" or usb_modeswitch.

The MessageContent for usb_modeswitch.conf is:
"55534243e0c26a85000000000000061b000000020000000000000000000000"

Signed-off-by: Zhang Le <r0bertz@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -632,6 +632,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(TOSHIBA_VENDOR_ID, TOSHIBA_PRODUCT_G450) },
 	{ USB_DEVICE(TOSHIBA_VENDOR_ID, TOSHIBA_PRODUCT_HSDPA_MINICARD ) }, /* Toshiba 3G HSDPA == Novatel Expedite EU870D MiniCard */
 	{ USB_DEVICE(ALINK_VENDOR_ID, 0x9000) },
+	{ USB_DEVICE(ALINK_VENDOR_ID, 0xce16) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ALINK_VENDOR_ID, ALINK_PRODUCT_3GU, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X060S) },
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },


