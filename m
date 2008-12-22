Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbYLVMh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbYLVMh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 07:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbYLVMhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 07:37:46 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:9138 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751677AbYLVMhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 07:37:45 -0500
From: Boaz Harrosh <bharrosh@panasas.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>,
       open-osd ml <osd-dev@open-osd.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/18] major.h: char-major number for OSD device driver
Date: Mon, 22 Dec 2008 14:37:40 +0200
Message-Id: <1229949460-15672-1-git-send-email-bharrosh@panasas.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <494F88C0.4070507@panasas.com>
References: <494F88C0.4070507@panasas.com>
X-OriginalArrivalTime: 22 Dec 2008 12:37:42.0956 (UTC) FILETIME=[158E4EC0:01C96432]
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
CC: device at lanana <device@lanana.org>
---
 Documentation/devices.txt |    6 ++++++
 include/linux/major.h     |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 2be0824..62254d4 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -3145,6 +3145,12 @@ Your cooperation is appreciated.
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

