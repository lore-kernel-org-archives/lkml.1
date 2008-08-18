Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbYHRT0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbYHRT0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759142AbYHRT0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:26:21 -0400
Received: from ns2.suse.de ([195.135.220.15]:40204 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761146AbYHRT0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:26:18 -0400
Date: Mon, 18 Aug 2008 12:19:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Tollef Fog Heen <tfheen@err.no>
Subject: [patch 04/49] USB: pl2023: Remove USB id (4348:5523) handled by
	ch341
Message-ID: <20080818191920.GE10350@suse.de>
References: <20080818191012.663450219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-pl2023-remove-usb-id-handled-by-ch341.patch"
In-Reply-To: <20080818191834.GA10350@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tollef Fog Heen <tfheen@err.no>

commit 8c809681ba0289afd0ed7bbb63679a0568dd441d upstream

USB ID 4348:5523 is handled by the ch341 driver.  Remove it from the
pl2023 driver.

Reverts 002e8f2c80c6be76bb312940bc278fc10b2b2487.

Signed-off-by: Tollef Fog Heen <tfheen@err.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/pl2303.c |    1 -
 drivers/usb/serial/pl2303.h |    4 ----
 2 files changed, 5 deletions(-)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -87,7 +87,6 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(ALCOR_VENDOR_ID, ALCOR_PRODUCT_ID) },
 	{ USB_DEVICE(WS002IN_VENDOR_ID, WS002IN_PRODUCT_ID) },
 	{ USB_DEVICE(COREGA_VENDOR_ID, COREGA_PRODUCT_ID) },
-	{ USB_DEVICE(HL340_VENDOR_ID, HL340_PRODUCT_ID) },
 	{ USB_DEVICE(YCCABLE_VENDOR_ID, YCCABLE_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -105,10 +105,6 @@
 #define COREGA_VENDOR_ID	0x07aa
 #define COREGA_PRODUCT_ID	0x002a
 
-/* HL HL-340 (ID: 4348:5523) */
-#define HL340_VENDOR_ID		0x4348
-#define HL340_PRODUCT_ID	0x5523
-
 /* Y.C. Cable U.S.A., Inc - USB to RS-232 */
 #define YCCABLE_VENDOR_ID	0x05ad
 #define YCCABLE_PRODUCT_ID	0x0fba

-- 
