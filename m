Return-Path: <linux-kernel-owner+w=401wt.eu-S1762997AbYBGU5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762997AbYBGU5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760869AbYBGUvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:51:22 -0500
Received: from ns.suse.de ([195.135.220.2]:45356 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760690AbYBGUvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:51:19 -0500
Date: Thu, 7 Feb 2008 12:47:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, linux-usb@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel Koz??k <kozzi11@gmail.com>
Subject: [patch 14/45] USB: remove duplicate entry in Option driver and
	Pl2303 driver for Huawei modem
Message-ID: <20080207204710.GO16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename="usb-remove-duplicate-entry-in-option-driver-and-pl2303-driver-for-huawei-modem.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Daniel Kozák <kozzi11@gmail.com>

Remove entry for Huawei E620 UMTS/HSDPA card (ID: 12d1:1001) in pl2303 driver
Option driver is use instead

Signed-off-by: Daniel Kozák <kozzi11@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/pl2303.c |    1 -
 drivers/usb/serial/pl2303.h |    4 ----
 2 files changed, 5 deletions(-)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -84,7 +84,6 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(DATAPILOT_U2_VENDOR_ID, DATAPILOT_U2_PRODUCT_ID) },
 	{ USB_DEVICE(BELKIN_VENDOR_ID, BELKIN_PRODUCT_ID) },
 	{ USB_DEVICE(ALCOR_VENDOR_ID, ALCOR_PRODUCT_ID) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_ID) },
 	{ USB_DEVICE(WS002IN_VENDOR_ID, WS002IN_PRODUCT_ID) },
 	{ USB_DEVICE(COREGA_VENDOR_ID, COREGA_PRODUCT_ID) },
 	{ USB_DEVICE(HL340_VENDOR_ID, HL340_PRODUCT_ID) },
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -96,10 +96,6 @@
 #define ALCOR_VENDOR_ID		0x058F
 #define ALCOR_PRODUCT_ID	0x9720
 
-/* Huawei E620 UMTS/HSDPA card (ID: 12d1:1001) */
-#define HUAWEI_VENDOR_ID	0x12d1
-#define HUAWEI_PRODUCT_ID	0x1001
-
 /* Willcom WS002IN Data Driver (by NetIndex Inc.) */
 #define WS002IN_VENDOR_ID	0x11f6
 #define WS002IN_PRODUCT_ID	0x2001

-- 
