Return-Path: <linux-kernel-owner+w=401wt.eu-S2992714AbXBQRFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992714AbXBQRFy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992710AbXBQRFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:05:53 -0500
Received: from smtp.nokia.com ([131.228.20.173]:34802 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992714AbXBQRFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:05:50 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Feb 2007 18:57:31 +0200
Message-Id: <20070217165731.5845.50010.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 37/44 take 2] [UBI] sysfs handling unit header
X-OriginalArrivalTime: 17 Feb 2007 16:57:30.0526 (UTC) FILETIME=[B60D3BE0:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185409-0CD71BB0-21F5FED5/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/sysfs.h tmp-to/drivers/mtd/ubi/sysfs.h
--- tmp-from/drivers/mtd/ubi/sysfs.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/sysfs.h	2007-02-17 18:07:27.000000000 +0200
@@ -0,0 +1,82 @@
+/*
+ * Copyright (c) International Business Machines Corp., 2006
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Author: Artem B. Bityutskiy
+ */
+
+/*
+ * This is a part of the UBI user interface unit and contains all the
+ * sysfs-related stuff.
+ */
+
+#ifndef __UBI_SYSFS_H__
+#define __UBI_SYSFS_H__
+
+#include <linux/init.h>
+
+struct ubi_info;
+struct ubi_uif_volume;
+
+/**
+ * ubi_sysfs_vol_init - initialize sysfs for an UBI volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol: user interfaces unit volume description object
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_sysfs_vol_init(const struct ubi_info *ubi, struct ubi_uif_volume *vol);
+
+/**
+ * ubi_sysfs_vol_close - close sysfs for an UBI volume.
+ *
+ * @vol: user interfaces unit volume description object
+ */
+void ubi_sysfs_vol_close(struct ubi_uif_volume *vol);
+
+/**
+ * ubi_sysfs_init - initialize sysfs for an UBI device.
+ *
+ * @ubi: the UBI device description object
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_sysfs_init(const struct ubi_info *ubi);
+
+/**
+ * ubi_sysfs_close - close sysfs for an UBI device.
+ *
+ * @ubi: the UBI device description object
+ */
+void ubi_sysfs_close(const struct ubi_info *ubi);
+
+/**
+ * ubi_sysfs_global_init - initialize UBI sysfs support.
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int __init ubi_sysfs_global_init(void);
+
+/**
+ * ubi_sysfs_global_close - close UBI sysfs support.
+ */
+void ubi_sysfs_global_close(void);
+
+#endif /* !__UBI_SYSFS_H__ */
