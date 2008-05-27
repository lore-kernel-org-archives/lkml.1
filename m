Return-Path: <linux-kernel-owner+w=401wt.eu-S1758928AbYE0QM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928AbYE0QM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 12:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758787AbYE0QMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 12:12:00 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:24515 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758763AbYE0QL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 12:11:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=jWoZxM1oKc63lGXYU5gTmqaDv7Fq6qO6LkGcdh1QYDXcUG8JxBrJmrOGmUIcZTR1zNqYl13FUV34MjD+oznLuJiJ3DEIhz0fm0T5Q4gmNoWNi5kd30DIO1xflvmFAs6zFDLLHFQPC+2Ii4g8RsFHdXvuqO2L83WP/c8mUbQUZZU=
Date: Tue, 27 May 2008 18:11:53 +0200
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] arm: fix header guards
Message-ID: <20080527161153.GE7550@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 27 May 2008 17:32:10 +0200
Subject: [PATCH] arm: fix header guards

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/asm-arm/arch-iop13xx/dma.h |    2 +-
 include/asm-arm/arch-msm/irqs.h    |    1 +
 include/asm-arm/arch-msm/timex.h   |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/asm-arm/arch-iop13xx/dma.h b/include/asm-arm/arch-iop13xx/dma.h
index 2e15da5..d79846f 100644
--- a/include/asm-arm/arch-iop13xx/dma.h
+++ b/include/asm-arm/arch-iop13xx/dma.h
@@ -1,3 +1,3 @@
 #ifndef _IOP13XX_DMA_H
-#define _IOP13XX_DMA_H_
+#define _IOP13XX_DMA_H
 #endif
diff --git a/include/asm-arm/arch-msm/irqs.h b/include/asm-arm/arch-msm/irqs.h
index 565430c..e62a108 100644
--- a/include/asm-arm/arch-msm/irqs.h
+++ b/include/asm-arm/arch-msm/irqs.h
@@ -15,6 +15,7 @@
  */
 
 #ifndef __ASM_ARCH_MSM_IRQS_H
+#define __ASM_ARCH_MSM_IRQS_H
 
 /* MSM ARM11 Interrupt Numbers */
 /* See 80-VE113-1 A, pp219-221     */
diff --git a/include/asm-arm/arch-msm/timex.h b/include/asm-arm/arch-msm/timex.h
index 154b23f..8724487 100644
--- a/include/asm-arm/arch-msm/timex.h
+++ b/include/asm-arm/arch-msm/timex.h
@@ -14,6 +14,7 @@
  */
 
 #ifndef __ASM_ARCH_MSM_TIMEX_H
+#define __ASM_ARCH_MSM_TIMEX_H
 
 #define CLOCK_TICK_RATE		1000000
 
-- 
1.5.4.1

