Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbZHZG05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbZHZG05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbZHZG04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:26:56 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:52360
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752073AbZHZG04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:26:56 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 02:26:55 EDT
Subject: Subject: [PATCH 10/33] score: create head files dma.h
	dma-mapping.h io.h ioctl.h ioctls.h
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:16:41 +0800
Message-Id: <1251267401.3073.13.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0afc8cdccd048bbd8a17a38bfe4d9d2935f6d61f Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:05:00 +0800
Subject: [PATCH 10/33] score: create head files dma.h dma-mapping.h io.h ioctl.h ioctls.h


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/dma-mapping.h |    6 ++++++
 arch/score/include/asm/dma.h         |    8 ++++++++
 arch/score/include/asm/io.h          |    9 +++++++++
 arch/score/include/asm/ioctl.h       |    6 ++++++
 arch/score/include/asm/ioctls.h      |    6 ++++++
 5 files changed, 35 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/dma-mapping.h
 create mode 100644 arch/score/include/asm/dma.h
 create mode 100644 arch/score/include/asm/io.h
 create mode 100644 arch/score/include/asm/ioctl.h
 create mode 100644 arch/score/include/asm/ioctls.h

diff --git a/arch/score/include/asm/dma-mapping.h b/arch/score/include/asm/dma-mapping.h
new file mode 100644
index 0000000..f9c0193
--- /dev/null
+++ b/arch/score/include/asm/dma-mapping.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_DMA_MAPPING_H
+#define _ASM_SCORE_DMA_MAPPING_H
+
+#include <asm-generic/dma-mapping-broken.h>
+
+#endif /* _ASM_SCORE_DMA_MAPPING_H */
diff --git a/arch/score/include/asm/dma.h b/arch/score/include/asm/dma.h
new file mode 100644
index 0000000..9f44185
--- /dev/null
+++ b/arch/score/include/asm/dma.h
@@ -0,0 +1,8 @@
+#ifndef _ASM_SCORE_DMA_H
+#define _ASM_SCORE_DMA_H
+
+#include <asm/io.h>
+
+#define MAX_DMA_ADDRESS		(0)
+
+#endif /* _ASM_SCORE_DMA_H */
diff --git a/arch/score/include/asm/io.h b/arch/score/include/asm/io.h
new file mode 100644
index 0000000..fbbfd71
--- /dev/null
+++ b/arch/score/include/asm/io.h
@@ -0,0 +1,9 @@
+#ifndef _ASM_SCORE_IO_H
+#define _ASM_SCORE_IO_H
+
+#include <asm-generic/io.h>
+
+#define virt_to_bus	virt_to_phys
+#define bus_to_virt	phys_to_virt
+
+#endif /* _ASM_SCORE_IO_H */
diff --git a/arch/score/include/asm/ioctl.h b/arch/score/include/asm/ioctl.h
new file mode 100644
index 0000000..a351d21
--- /dev/null
+++ b/arch/score/include/asm/ioctl.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_IOCTL_H
+#define _ASM_SCORE_IOCTL_H
+
+#include <asm-generic/ioctl.h>
+
+#endif /* _ASM_SCORE_IOCTL_H */
diff --git a/arch/score/include/asm/ioctls.h b/arch/score/include/asm/ioctls.h
new file mode 100644
index 0000000..ed01d2b
--- /dev/null
+++ b/arch/score/include/asm/ioctls.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_IOCTLS_H
+#define _ASM_SCORE_IOCTLS_H
+
+#include <asm-generic/ioctls.h>
+
+#endif /* _ASM_SCORE_IOCTLS_H */
-- 
1.6.2



