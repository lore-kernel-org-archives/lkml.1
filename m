Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbZFIGdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbZFIGdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZFIGdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:33:09 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:36651 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbZFIGdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:33:08 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: [PATCH 06/27] score: create head files delay.h device.h div64.h
 dma-mapping.h dma.h
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFA4420B9D.34FDC91E-ON482575D0.0023528E-482575D0.0023C39B@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 9 Jun 2009 14:26:21 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/09 ?? 02:26:21,
	Serialize complete at 2009/06/09 ?? 02:26:21
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 98df81697789227319d5909b66daf7e48bb3d2d7 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Tue, 9 Jun 2009 13:43:07 +0800



Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/delay.h       |   14 ++++++++++++++
 arch/score/include/asm/device.h      |    6 ++++++
 arch/score/include/asm/div64.h       |    6 ++++++
 arch/score/include/asm/dma-mapping.h |    6 ++++++
 arch/score/include/asm/dma.h         |    8 ++++++++
 5 files changed, 40 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/delay.h
 create mode 100644 arch/score/include/asm/device.h
 create mode 100644 arch/score/include/asm/div64.h
 create mode 100644 arch/score/include/asm/dma-mapping.h
 create mode 100644 arch/score/include/asm/dma.h

diff --git a/arch/score/include/asm/delay.h 
b/arch/score/include/asm/delay.h
new file mode 100644
index 0000000..ea4d532
--- /dev/null
+++ b/arch/score/include/asm/delay.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_SCORE_DELAY_H
+#define _ASM_SCORE_DELAY_H
+
+static inline void __delay(unsigned long loops)
+{}
+
+static inline void __udelay(unsigned long usecs)
+{
+       __delay(usecs);
+}
+
+#define udelay(usecs) __udelay(usecs)
+
+#endif /* _ASM_SCORE_DELAY_H */
diff --git a/arch/score/include/asm/device.h 
b/arch/score/include/asm/device.h
new file mode 100644
index 0000000..2dc7cc5
--- /dev/null
+++ b/arch/score/include/asm/device.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_DEVICE_H
+#define _ASM_SCORE_DEVICE_H
+
+#include <asm-generic/device.h>
+
+#endif /* _ASM_SCORE_DEVICE_H */
diff --git a/arch/score/include/asm/div64.h 
b/arch/score/include/asm/div64.h
new file mode 100644
index 0000000..75fae19
--- /dev/null
+++ b/arch/score/include/asm/div64.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_DIV64_H
+#define _ASM_SCORE_DIV64_H
+
+#include <asm-generic/div64.h>
+
+#endif /* _ASM_SCORE_DIV64_H */
diff --git a/arch/score/include/asm/dma-mapping.h 
b/arch/score/include/asm/dma-mapping.h
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
index 0000000..4c4f2e3
--- /dev/null
+++ b/arch/score/include/asm/dma.h
@@ -0,0 +1,8 @@
+#ifndef _ASM_SCORE_DMA_H
+#define _ASM_SCORE_DMA_H
+
+#include <asm/io.h>
+
+#define MAX_DMA_ADDRESS                (PAGE_OFFSET + 0x01000000)
+
+#endif /* _ASM_SCORE_DMA_H */
-- 
1.6.2

