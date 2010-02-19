Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab0BSRFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:05:30 -0500
Received: from kroah.org ([198.145.64.141]:57805 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057Ab0BSRBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:01:11 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:53 2010
Message-Id: <20100219163253.292095747@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:30:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [81/93] rtl8187: Add new device ID
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jelle Martijn Kok <jmkok@solutionsradio.com>

commit 174b24963eaf96dc5e093502ee09639aed13eb2f upstream.

Add new RTL8187B device.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -65,6 +65,7 @@ static struct usb_device_id rtl8187_tabl
 	/* Sitecom */
 	{USB_DEVICE(0x0df6, 0x000d), .driver_info = DEVICE_RTL8187},
 	{USB_DEVICE(0x0df6, 0x0028), .driver_info = DEVICE_RTL8187B},
+	{USB_DEVICE(0x0df6, 0x0029), .driver_info = DEVICE_RTL8187B},
 	/* Sphairon Access Systems GmbH */
 	{USB_DEVICE(0x114B, 0x0150), .driver_info = DEVICE_RTL8187},
 	/* Dick Smith Electronics */


