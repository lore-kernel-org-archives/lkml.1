Return-Path: <linux-kernel-owner+w=401wt.eu-S1762818AbYBGUzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762818AbYBGUzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762267AbYBGUu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:50:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:38167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933163AbYBGUu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:50:56 -0500
Date: Thu, 7 Feb 2008 12:46:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, linux-usb@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 09/45] USB: Adding YC Cable USB Serial device to pl2303
Message-ID: <20080207204657.GJ16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-adding-yc-cable-usb-serial-device-to-pl2303.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Damien Stuart <dstuart@dstuart.org>

This simply adds the "YC Cable" as a vendor and its pl2303-based
USB<->Serial adapter as a product.  This particular adapter is sold by
Radio Shack.  I've done limited testing on a few different systems with
no issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    3 +++
 2 files changed, 4 insertions(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -88,6 +88,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(WS002IN_VENDOR_ID, WS002IN_PRODUCT_ID) },
 	{ USB_DEVICE(COREGA_VENDOR_ID, COREGA_PRODUCT_ID) },
 	{ USB_DEVICE(HL340_VENDOR_ID, HL340_PRODUCT_ID) },
+	{ USB_DEVICE(YCCABLE_VENDOR_ID, YCCABLE_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -112,3 +112,6 @@
 #define HL340_VENDOR_ID		0x4348
 #define HL340_PRODUCT_ID	0x5523
 
+/* Y.C. Cable U.S.A., Inc - USB to RS-232 */
+#define YCCABLE_VENDOR_ID	0x05ad
+#define YCCABLE_PRODUCT_ID	0x0fba

-- 
