Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935683Ab0CMAoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:44:46 -0500
Received: from kroah.org ([198.145.64.141]:47204 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935547Ab0CMAca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:32:30 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:16 2010
Message-Id: <20100313002716.484351133@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:27:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Dumon <j.dumon@option.com>, Phil Dibowitz <phil@ipom.com>
Subject: [129/145] USB: unusual_devs: Add support for multiple Option 3G sticks
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Jan Dumon <j.dumon@option.com>

commit 46216e4fbe8c62059b5440dec0b236f386248a41 upstream.

Enable the SD-Card interface on multiple Option 3G sticks.
The unusual_devs.h entry is necessary because the device descriptor is
vendor-specific. That prevents usb-storage from binding to it as an interface
driver.

Signed-off-by: Jan Dumon <j.dumon@option.com>
Signed-off-by: Phil Dibowitz <phil@ipom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |   88 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 86 insertions(+), 2 deletions(-)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1147,8 +1147,8 @@ UNUSUAL_DEV( 0x0af0, 0x7401, 0x0000, 0x0
 		0 ),
 
 /* Reported by Jan Dumon <j.dumon@option.com>
- * This device (wrongly) has a vendor-specific device descriptor.
- * The entry is needed so usb-storage can bind to it's mass-storage
+ * These devices (wrongly) have a vendor-specific device descriptor.
+ * These entries are needed so usb-storage can bind to their mass-storage
  * interface as an interface driver */
 UNUSUAL_DEV( 0x0af0, 0x7501, 0x0000, 0x0000,
 		"Option",
@@ -1156,6 +1156,90 @@ UNUSUAL_DEV( 0x0af0, 0x7501, 0x0000, 0x0
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		0 ),
 
+UNUSUAL_DEV( 0x0af0, 0x7701, 0x0000, 0x0000,
+		"Option",
+		"GI 0451 SD-Card",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		0 ),
+
+UNUSUAL_DEV( 0x0af0, 0x7706, 0x0000, 0x0000,
+		"Option",
+		"GI 0451 SD-Card",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		0 ),
+
+UNUSUAL_DEV( 0x0af0, 0x7901, 0x0000, 0x0000,
+		"Option",
+		"GI 0452 SD-Card",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		0 ),
+
+UNUSUAL_DEV( 0x0af0, 0x7A01, 0x0000, 0x0000,
+		"Option",
+		"GI 0461 SD-Card",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		0 ),
+
+UNUSUAL_DEV( 0x0af0, 0x7A05, 0x0000, 0x0000,
+		"Option",
+		"GI 0461 SD-Card",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		0 ),
+
+UNUSUAL_DEV( 0x0af0, 0x8300, 0x0000, 0x0000,
+		"Option",
+		"GI 033x SD-Card",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		0 ),
+
+UNUSUAL_DEV( 0x0af0, 0x8302, 0x0000, 0x0000,
+		"Option",
+		"GI 033x SD-Card",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		0 ),
+
+UNUSUAL_DEV( 0x0af0, 0x8304, 0x0000, 0x0000,
+		"Option",
+		"GI 033x SD-Card",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		0 ),
+
+UNUSUAL_DEV( 0x0af0, 0xc100, 0x0000, 0x0000,
+		"Option",
+		"GI 070x SD-Card",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		0 ),
+
+UNUSUAL_DEV( 0x0af0, 0xd057, 0x0000, 0x0000,
+		"Option",
+		"GI 1505 SD-Card",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		0 ),
+
+UNUSUAL_DEV( 0x0af0, 0xd058, 0x0000, 0x0000,
+		"Option",
+		"GI 1509 SD-Card",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		0 ),
+
+UNUSUAL_DEV( 0x0af0, 0xd157, 0x0000, 0x0000,
+		"Option",
+		"GI 1515 SD-Card",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		0 ),
+
+UNUSUAL_DEV( 0x0af0, 0xd257, 0x0000, 0x0000,
+		"Option",
+		"GI 1215 SD-Card",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		0 ),
+
+UNUSUAL_DEV( 0x0af0, 0xd357, 0x0000, 0x0000,
+		"Option",
+		"GI 1505 SD-Card",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		0 ),
+
 /* Reported by Ben Efros <ben@pc-doctor.com> */
 UNUSUAL_DEV( 0x0bc2, 0x3010, 0x0000, 0x0000,
 		"Seagate",


