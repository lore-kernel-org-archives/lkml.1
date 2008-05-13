Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbYEMW0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbYEMW0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 18:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYEMW0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 18:26:17 -0400
Received: from fb1.tech.numericable.fr ([82.216.111.51]:59287 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbYEMW0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 18:26:16 -0400
X-Greylist: delayed 1320 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2008 18:26:16 EDT
Message-Id: <3CC3C284-EB1C-4BE8-A73C-88F8A10344B0@sitadelle.com>
From: Aurelien Nephtali <aurelien.nephtali@sitadelle.com>
To: akpm@osdl.org
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: [patch] net/usb : add support for Apple USB Ethernet Adapter
X-Priority: 3
Date: Wed, 14 May 2008 00:04:11 +0200
Cc: linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The following patch adds support for Apple USB Ethernet Adapter.

http://store.apple.com/1-800-MY-APPLE/WebObjects/AppleStore.woa/wa/RSLID?nplm=MB442Z/A

It applies against kernel 2.6.25.3.

Signed-off-by: Aurelien Nephtali <aurelien@sitadelle.com>

--- linux/drivers/net/usb/asix.c.orig   2008-05-13 19:46:19.000000000
+0200
+++ linux/drivers/net/usb/asix.c        2008-05-13 19:47:20.000000000
+0200
@@ -1437,6 +1437,10 @@ static const struct usb_device_id        produc
        // Belkin F5D5055
        USB_DEVICE(0x050d, 0x5055),
        .driver_info = (unsigned long) &ax88178_info,
+}, {
+       // Apple USB Ethernet Adapter
+       USB_DEVICE(0x05ac, 0x1402),
+       .driver_info = (unsigned long) &ax88772_info,
},
        { },            // END
};

-- 
Aurelien Nephtali



