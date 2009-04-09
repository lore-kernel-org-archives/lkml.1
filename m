Return-Path: <linux-kernel-owner+w=401wt.eu-S936005AbZDIQmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936005AbZDIQmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 12:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935365AbZDIQ3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 12:29:23 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:50622 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935256AbZDIQ3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 12:29:17 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [RFC PATCH v2 08/19] venet: add the ABI definitions for an 802.x
	packet interface
To: linux-kernel@vger.kernel.org
Cc: agraf@suse.de, pmullaney@novell.com, pmorreale@novell.com,
       anthony@codemonkey.ws, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org, avi@redhat.com, bhutchings@solarflare.com,
       andi@firstfloor.org, gregkh@suse.de, herber@gondor.apana.org.au,
       chrisw@sous-sol.org, shemminger@vyatta.com
Date: Thu, 09 Apr 2009 12:31:23 -0400
Message-ID: <20090409163123.32740.53213.stgit@dev.haskins.net>
In-Reply-To: <20090409155200.32740.19358.stgit@dev.haskins.net>
References: <20090409155200.32740.19358.stgit@dev.haskins.net>
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

