Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbYCKJKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbYCKJKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 05:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbYCKJKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 05:10:10 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:50041 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbYCKJKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 05:10:09 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org, akpm@linux-foundation.org,
       galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 03/17] Move include/asm-ppc/rio.h to include/asm-powerpc/rio.h
Date: Tue, 11 Mar 2008 17:07:44 +0800
Message-Id: <1205226478-7641-3-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1205226478-7641-2-git-send-email-wei.zhang@freescale.com>
References: <1205226478-7641-1-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-2-git-send-email-wei.zhang@freescale.com>
X-OriginalArrivalTime: 11 Mar 2008 09:10:00.0149 (UTC) FILETIME=[AF006050:01C88357]
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

