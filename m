Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbYCDIdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbYCDIdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbYCDIat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:30:49 -0500
Received: from az33egw01.freescale.net ([192.88.158.102]:46319 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbYCDIar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:30:47 -0500
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org, galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 03/17] Move include/asm-ppc/rio.h to include/asm-powerpc/rio.h
Date: Wed,  5 Mar 2008 00:29:48 +0800
Message-Id: <1204648202-5495-3-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1204648202-5495-2-git-send-email-wei.zhang@freescale.com>
References: <1204648202-5495-1-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-2-git-send-email-wei.zhang@freescale.com>
X-OriginalArrivalTime: 04 Mar 2008 08:30:28.0719 (UTC) FILETIME=[00A09FF0:01C87DD2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 include/asm-powerpc/rio.h |   18 ++++++++++++++++++
 include/asm-ppc/rio.h     |   18 ------------------
 2 files changed, 18 insertions(+), 18 deletions(-)
 create mode 100644 include/asm-powerpc/rio.h
 delete mode 100644 include/asm-ppc/rio.h

diff --git a/include/asm-powerpc/rio.h b/include/asm-powerpc/rio.h
new file mode 100644
index 0000000..0018bf8
--- /dev/null
+++ b/include/asm-powerpc/rio.h
@@ -0,0 +1,18 @@
+/*
+ * RapidIO architecture support
+ *
+ * Copyright 2005 MontaVista Software, Inc.
+ * Matt Porter <mporter@kernel.crashing.org>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef ASM_PPC_RIO_H
+#define ASM_PPC_RIO_H
+
+extern void platform_rio_init(void);
+
+#endif				/* ASM_PPC_RIO_H */
diff --git a/include/asm-ppc/rio.h b/include/asm-ppc/rio.h
deleted file mode 100644
index 0018bf8..0000000
--- a/include/asm-ppc/rio.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/*
- * RapidIO architecture support
- *
- * Copyright 2005 MontaVista Software, Inc.
- * Matt Porter <mporter@kernel.crashing.org>
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-
-#ifndef ASM_PPC_RIO_H
-#define ASM_PPC_RIO_H
-
-extern void platform_rio_init(void);
-
-#endif				/* ASM_PPC_RIO_H */
-- 
1.5.4

