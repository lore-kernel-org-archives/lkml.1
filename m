Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbYKDRXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbYKDRXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbYKDRXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:23:41 -0500
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:53890 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbYKDRXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:23:40 -0500
From: Boaz Harrosh <bharrosh@panasas.com>
To: Torben Mathiasen <device@lanana.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, open-osd ml <osd-dev@open-osd.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Sami.Iren@seagate.com,
       Pete Wyckoff <pw@padd.com>
Subject: [PATCH 01/18] major.h: char-major number for OSD device driver
Date: Tue,  4 Nov 2008 18:17:00 +0200
Message-Id: <1225815420-5721-1-git-send-email-bharrosh@panasas.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <491073BB.4000900@panasas.com>
References: <491073BB.4000900@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need a major for a char device for our OSD device driver.
Attached is a proposed patch for the Documentation/devices.txt
and include/linux/major.h files.

I have allocated the *260* char device as it looked like the next
available on the lanana.org web-site
(http://lanana.org/docs/device-list/devices-2.6+.txt)

Any number will do. Please allocate a number for us

(See http:/open-osd.org for further information)

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
CC: Torben Mathiasen <device@lanana.org>
---
 Documentation/devices.txt |    6 ++++++
 include/linux/major.h     |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 05c8064..d18070b 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -3142,6 +3142,12 @@ Your cooperation is appreciated.
 		  1 = /dev/blockrom1	Second ROM card's translation layer interface
 		  ...
 
+260 char	OSD (Object-based-device) SCSI Device
+		  0 = /dev/osd0		First OSD Device
+		  1 = /dev/osd1		Second OSD Device
+		  ...
+		  255 = /dev/osd255	256th OSD Device
+
  ****	ADDITIONAL /dev DIRECTORY ENTRIES
 
 This section details additional entries that should or may exist in
diff --git a/include/linux/major.h b/include/linux/major.h
index 8824945..058ec15 100644
--- a/include/linux/major.h
+++ b/include/linux/major.h
@@ -171,5 +171,6 @@
 #define VIOTAPE_MAJOR		230
 
 #define BLOCK_EXT_MAJOR		259
+#define SCSI_OSD_MAJOR		260	/* open-osd's OSD scsi device */
 
 #endif
-- 
1.6.0.1

