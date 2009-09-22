Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbZIVFoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbZIVFoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbZIVFoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:44:15 -0400
Received: from dcent.unixwiz.net ([99.25.142.34]:56959 "EHLO dcent.unixwiz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962AbZIVFoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:44:15 -0400
Date: Mon, 21 Sep 2009 22:44:19 -0700
From: Steve Friedl <steve@unixwiz.net>
To: linux-kernel@vger.kernel.org
Subject: PATCH 8/8] staging: hv: tabs are *8*
Message-ID: <20090922054419.GA6039@dcent.unixwiz.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Win32 style often uses four-character tabs, and when using the proper
8-char Linux-y tabs, a few places blew out the margins. This patch fixes
the obvious mis-tabbing.

~~~ Steve

Signed-off-by: Steve Friedl <steve@unixwiz.net>

---
 drivers/staging/hv/RingBuffer.c |   12 ++++----
 drivers/staging/hv/StorVscApi.h |   12 ++++----
 drivers/staging/hv/VmbusApi.h   |    4 +-
 drivers/staging/hv/logging.h    |   50 +++++++++++++++++++-------------------
 4 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/hv/RingBuffer.c b/drivers/staging/hv/RingBuffer.c
index 501dee9..1e8ae29 100644
--- a/drivers/staging/hv/RingBuffer.c
+++ b/drivers/staging/hv/RingBuffer.c
@@ -497,14 +497,14 @@ int RingBufferRead(struct hv_ring_buffer_info *InRingInfo, void *Buffer,
 	nextReadLocation = GetNextReadLocationWithOffset(InRingInfo, Offset);
 
 	nextReadLocation = CopyFromRingBuffer(InRingInfo,
-											Buffer,
-											BufferLen,
-											nextReadLocation);
+						Buffer,
+						BufferLen,
+						nextReadLocation);
 
 	nextReadLocation = CopyFromRingBuffer(InRingInfo,
-											&prevIndices,
-											sizeof(u64),
-											nextReadLocation);
+						&prevIndices,
+						sizeof(u64),
+						nextReadLocation);
 
 	/* Make sure all reads are done before we update the read index since */
 	/* the writer may start writing to the read area once the read index is updated */
diff --git a/drivers/staging/hv/StorVscApi.h b/drivers/staging/hv/StorVscApi.h
index 69c1406..b0ba810 100644
--- a/drivers/staging/hv/StorVscApi.h
+++ b/drivers/staging/hv/StorVscApi.h
@@ -28,10 +28,10 @@
 #include "VmbusApi.h"
 
 /* Defines */
-#define STORVSC_RING_BUFFER_SIZE			(10*PAGE_SIZE)
-#define BLKVSC_RING_BUFFER_SIZE				(20*PAGE_SIZE)
+#define STORVSC_RING_BUFFER_SIZE	(10*PAGE_SIZE)
+#define BLKVSC_RING_BUFFER_SIZE		(20*PAGE_SIZE)
 
-#define STORVSC_MAX_IO_REQUESTS				64
+#define STORVSC_MAX_IO_REQUESTS		64
 
 /*
  * In Hyper-V, each port/path/target maps to 1 scsi host adapter.  In
@@ -39,9 +39,9 @@
  * scsi host adapter essentially has 1 bus with 1 target that contains
  * up to 256 luns.
  */
-#define STORVSC_MAX_LUNS_PER_TARGET			64
-#define STORVSC_MAX_TARGETS				1
-#define STORVSC_MAX_CHANNELS				1
+#define STORVSC_MAX_LUNS_PER_TARGET	64
+#define STORVSC_MAX_TARGETS		1
+#define STORVSC_MAX_CHANNELS		1
 
 struct hv_storvsc_request;
 
diff --git a/drivers/staging/hv/VmbusApi.h b/drivers/staging/hv/VmbusApi.h
index d089bb1..3c25e51 100644
--- a/drivers/staging/hv/VmbusApi.h
+++ b/drivers/staging/hv/VmbusApi.h
@@ -25,8 +25,8 @@
 #ifndef _VMBUS_API_H_
 #define _VMBUS_API_H_
 
-#define MAX_PAGE_BUFFER_COUNT				16
-#define MAX_MULTIPAGE_BUFFER_COUNT			32 /* 128K */
+#define MAX_PAGE_BUFFER_COUNT		16
+#define MAX_MULTIPAGE_BUFFER_COUNT	32 /* 128K */
 
 #pragma pack(push, 1)
 
diff --git a/drivers/staging/hv/logging.h b/drivers/staging/hv/logging.h
index 9e55617..c953e85 100644
--- a/drivers/staging/hv/logging.h
+++ b/drivers/staging/hv/logging.h
@@ -29,35 +29,35 @@
 /* #include <linux/module.h> */
 
 
-#define VMBUS				0x0001
-#define STORVSC				0x0002
-#define NETVSC				0x0004
-#define INPUTVSC			0x0008
-#define BLKVSC				0x0010
-#define VMBUS_DRV			0x0100
-#define STORVSC_DRV			0x0200
-#define NETVSC_DRV			0x0400
+#define VMBUS			0x0001
+#define STORVSC			0x0002
+#define NETVSC			0x0004
+#define INPUTVSC		0x0008
+#define BLKVSC			0x0010
+#define VMBUS_DRV		0x0100
+#define STORVSC_DRV		0x0200
+#define NETVSC_DRV		0x0400
 #define INPUTVSC_DRV		0x0800
-#define BLKVSC_DRV			0x1000
-
-#define ALL_MODULES			(VMBUS		|\
-							STORVSC		|\
-							NETVSC		|\
-							INPUTVSC	|\
-							BLKVSC		|\
-							VMBUS_DRV	|\
-							STORVSC_DRV	|\
-							NETVSC_DRV	|\
-							INPUTVSC_DRV|\
-							BLKVSC_DRV)
+#define BLKVSC_DRV		0x1000
+
+#define ALL_MODULES		(VMBUS		|\
+				STORVSC		|\
+				NETVSC		|\
+				INPUTVSC	|\
+				BLKVSC		|\
+				VMBUS_DRV	|\
+				STORVSC_DRV	|\
+				NETVSC_DRV	|\
+				INPUTVSC_DRV|\
+				BLKVSC_DRV)
 
 /* Logging Level */
-#define ERROR_LVL				3
-#define WARNING_LVL				4
-#define INFO_LVL				6
-#define DEBUG_LVL				7
-#define DEBUG_LVL_ENTEREXIT			8
-#define DEBUG_RING_LVL				9
+#define ERROR_LVL		3
+#define WARNING_LVL		4
+#define INFO_LVL		6
+#define DEBUG_LVL		7
+#define DEBUG_LVL_ENTEREXIT	8
+#define DEBUG_RING_LVL		9
 
 extern unsigned int vmbus_loglevel;
 
-- 
1.6.5.rc1
