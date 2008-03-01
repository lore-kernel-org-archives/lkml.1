Return-Path: <linux-kernel-owner+w=401wt.eu-S1760877AbYCAGEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877AbYCAGEu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 01:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYCAGEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 01:04:38 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:58802 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbYCAGEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 01:04:37 -0500
Date: Fri, 29 Feb 2008 22:03:07 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, lud <linux-usb@vger.kernel.org>
Cc: gregkh <greg@kroah.com>, akpm <akpm@linux-foundation.org>,
       torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4/6] docbook: fix usb source files
Message-Id: <20080229220307.7a637ce2.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix docbook problems in USB source files.
These cause the generated docbook to be incorrect.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/usb/core/usb.c |    6 ++----
 include/linux/usb.h    |    9 +++------
 2 files changed, 5 insertions(+), 10 deletions(-)

--- lin2625-rc3g2-kdoc.orig/drivers/usb/core/usb.c
+++ lin2625-rc3g2-kdoc/drivers/usb/core/usb.c
@@ -99,8 +99,7 @@ struct usb_interface *usb_ifnum_to_if(co
 EXPORT_SYMBOL_GPL(usb_ifnum_to_if);
 
 /**
- * usb_altnum_to_altsetting - get the altsetting structure with a given
- *	alternate setting number.
+ * usb_altnum_to_altsetting - get the altsetting structure with a given alternate setting number.
  * @intf: the interface containing the altsetting in question
  * @altnum: the desired alternate setting number
  *
@@ -442,8 +441,7 @@ EXPORT_SYMBOL_GPL(usb_put_intf);
  */
 
 /**
- * usb_lock_device_for_reset - cautiously acquire the lock for a
- *	usb device structure
+ * usb_lock_device_for_reset - cautiously acquire the lock for a usb device structure
  * @udev: device that's being locked
  * @iface: interface bound to the driver making the request (optional)
  *
--- lin2625-rc3g2-kdoc.orig/include/linux/usb.h
+++ lin2625-rc3g2-kdoc/include/linux/usb.h
@@ -781,8 +781,7 @@ static inline int usb_endpoint_is_isoc_o
 	.idVendor = (vend), \
 	.idProduct = (prod)
 /**
- * USB_DEVICE_VER - macro used to describe a specific usb device with a
- *		version range
+ * USB_DEVICE_VER - describe a specific usb device with a version range
  * @vend: the 16 bit USB Vendor ID
  * @prod: the 16 bit USB Product ID
  * @lo: the bcdDevice_lo value
@@ -799,8 +798,7 @@ static inline int usb_endpoint_is_isoc_o
 	.bcdDevice_hi = (hi)
 
 /**
- * USB_DEVICE_INTERFACE_PROTOCOL - macro used to describe a usb
- *		device with a specific interface protocol
+ * USB_DEVICE_INTERFACE_PROTOCOL - describe a usb device with a specific interface protocol
  * @vend: the 16 bit USB Vendor ID
  * @prod: the 16 bit USB Product ID
  * @pr: bInterfaceProtocol value
@@ -846,8 +844,7 @@ static inline int usb_endpoint_is_isoc_o
 	.bInterfaceProtocol = (pr)
 
 /**
- * USB_DEVICE_AND_INTERFACE_INFO - macro used to describe a specific usb device
- * 		with a class of usb interfaces
+ * USB_DEVICE_AND_INTERFACE_INFO - describe a specific usb device with a class of usb interfaces
  * @vend: the 16 bit USB Vendor ID
  * @prod: the 16 bit USB Product ID
  * @cl: bInterfaceClass value
