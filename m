Return-Path: <linux-kernel-owner+w=401wt.eu-S1763439AbZCaSpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763439AbZCaSpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 14:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761671AbZCaSlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 14:41:25 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:42833 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761944AbZCaSlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 14:41:15 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [RFC PATCH 08/17] venet: add the ABI definitions for an 802.x packet
	interface
To: linux-kernel@vger.kernel.org
Cc: agraf@suse.de, pmullaney@novell.com, pmorreale@novell.com,
       anthony@codemonkey.ws, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Date: Tue, 31 Mar 2009 14:43:29 -0400
Message-ID: <20090331184328.28333.80808.stgit@dev.haskins.net>
In-Reply-To: <20090331184057.28333.77287.stgit@dev.haskins.net>
References: <20090331184057.28333.77287.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/venet.h |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/venet.h

diff --git a/include/linux/venet.h b/include/linux/venet.h
new file mode 100644
index 0000000..ef6b199
--- /dev/null
+++ b/include/linux/venet.h
@@ -0,0 +1,47 @@
+/*
+ * Copyright 2008 Novell.  All Rights Reserved.
+ *
+ * Virtual-Ethernet adapter
+ *
+ * Author:
+ *      Gregory Haskins <ghaskins@novell.com>
+ *
+ * This file is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
+ */
+
+#ifndef _LINUX_VENET_H
+#define _LINUX_VENET_H
+
+#define VENET_VERSION 1
+
+#define VENET_TYPE "virtual-ethernet"
+
+#define VENET_QUEUE_RX 0
+#define VENET_QUEUE_TX 1
+
+struct venet_capabilities {
+	__u32 gid;
+	__u32 bits;
+};
+
+/* CAPABILITIES-GROUP 0 */
+/* #define VENET_CAP_FOO    0   (No capabilities defined yet, for now) */
+
+#define VENET_FUNC_LINKUP   0
+#define VENET_FUNC_LINKDOWN 1
+#define VENET_FUNC_MACQUERY 2
+#define VENET_FUNC_NEGCAP   3 /* negotiate capabilities */
+#define VENET_FUNC_FLUSHRX  4
+
+#endif /* _LINUX_VENET_H */

