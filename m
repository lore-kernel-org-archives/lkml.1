Return-Path: <linux-kernel-owner+w=401wt.eu-S936368AbXHJMb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936368AbXHJMb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 08:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757771AbXHJMbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 08:31:15 -0400
Received: from cluster-g.mailcontrol.com ([85.115.41.190]:54470 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbXHJMbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 08:31:13 -0400
Message-ID: <46BC5A07.80107@csr.com>
Date: Fri, 10 Aug 2007 13:28:55 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Pierre Ossman <drzeus-list@drzeus.cx>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: sdio: add CSR vendor/device IDs
References: <46BC58E8.50300@csr.com>
In-Reply-To: <46BC58E8.50300@csr.com>
Content-Type: multipart/mixed;
 boundary="------------020808010300000207000701"
X-OriginalArrivalTime: 10 Aug 2007 12:29:08.0008 (UTC) FILETIME=[0C147A80:01C7DB4A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020808010300000207000701
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.

--------------020808010300000207000701
Content-Type: text/x-patch;
 name="sdio-csr-ids.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="sdio-csr-ids.patch"

sdio: add CSR vendor/device IDs

Signed-off-by: David Vrabel <david.vrabel@csr.com>
---
Index: mmc/include/linux/mmc/sdio_ids.h
===================================================================
--- mmc.orig/include/linux/mmc/sdio_ids.h	2007-08-10 01:15:54.000000000 +0100
+++ mmc/include/linux/mmc/sdio_ids.h	2007-08-10 01:16:19.000000000 +0100
@@ -19,5 +19,13 @@
 #define SDIO_CLASS_WLAN		0x07	/* WLAN interface */
 #define SDIO_CLASS_ATA		0x08	/* Embedded SDIO-ATA std interface */
 
+/*
+ * Vendor and device IDs.
+ */
+
+#define SDIO_VENDOR_ID_CSR		0x032a
+#define SDIO_DEVICE_ID_CSR_UNIFI_1	0x0001
+#define SDIO_DEVICE_ID_CSR_UNIFI_2	0x0002
+#define SDIO_DEVICE_ID_CSR_BC6		0x0004
 
 #endif

--------------020808010300000207000701--
