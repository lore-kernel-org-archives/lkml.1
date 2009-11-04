Return-Path: <linux-kernel-owner+w=401wt.eu-S932434AbZKDRgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbZKDRgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:36:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932414AbZKDRgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:36:01 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:40568 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbZKDRf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:35:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jWMB6ZzZ5rLszcbQ0kHSs9zZGtauFlD0K28ml7A+cIVq52jw27Db4erBWutH/dqnZL
         mbrqggk04uiSKtoQ0N6uhslAwPU14V5uo4PIEyzuVKJP/4nCUYn3HokAuaj2moj3Z48t
         Q6kmq6Ws7SUE2At9fKGC7X3KLTid7mJfzb1Cg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:35:39 +0100
Message-Id: <20091104173539.28463.82770.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 30/41] rt2800usb: fix comments in rt2800usb.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800usb: fix comments in rt2800usb.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800usb.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/rt2x00/rt2800usb.h
@@ -61,7 +61,7 @@
 
 /*
  * Signal information.
- * Defaul offset is required for RSSI <-> dBm conversion.
+ * Default offset is required for RSSI <-> dBm conversion.
  */
 #define DEFAULT_RSSI_OFFSET		120 /* FIXME */
 
@@ -87,12 +87,6 @@
  */
 
 /*
- * HOST-MCU shared memory
- */
-#define HOST_CMD_CSR			0x0404
-#define HOST_CMD_CSR_HOST_COMMAND	FIELD32(0x000000ff)
-
-/*
  * INT_SOURCE_CSR: Interrupt source register.
  * Write one to clear corresponding bit.
  * TX_FIFO_STATUS: FIFO Statistics is full, sw should read 0x171c
@@ -351,6 +345,12 @@
 #define PBF_SYS_CTRL_HOST_RAM_WRITE	FIELD32(0x00010000)
 
 /*
+ * HOST-MCU shared memory
+ */
+#define HOST_CMD_CSR			0x0404
+#define HOST_CMD_CSR_HOST_COMMAND	FIELD32(0x000000ff)
+
+/*
  * PBF registers
  * Most are for debug. Driver doesn't touch PBF register.
  */
@@ -1776,7 +1776,7 @@ struct mac_iveiv_entry {
 
 /*
  * Word3
- * WIV: Wireless Info Valid. 1: Driver filled WI,  0: DMA needs to copy WI
+ * WIV: Wireless Info Valid. 1: Driver filled WI, 0: DMA needs to copy WI
  * QSEL: Select on-chip FIFO ID for 2nd-stage output scheduler.
  *       0:MGMT, 1:HCCA 2:EDCA
  */
