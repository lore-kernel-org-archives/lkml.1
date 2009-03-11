Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbZCKWAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbZCKWAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbZCKV6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:58:11 -0400
Received: from smtp106.biz.mail.mud.yahoo.com ([68.142.200.254]:33240 "HELO
	smtp106.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754257AbZCKV6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:58:09 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: WSAf4pMVM1la9MXLOFCBsqSiRgTOw1xhbBJ8WKr6JWc6VSxcY4CrtYC0LYkHIDEIa_O8HMeQvbd10YxQxTrwRiuaEVQYmU4NDkl58WFtE5yoynabtAYGyIm4OWO2H4o0o1PcbWDbLUiWfxQ84PGsyBQ1yP_qdWWsduh0AYVZID_oIaBRYFEYEV5udy0AXTog9sny.jqfCuhtYttFm7M7hT7RDQ--
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
To: uClinux development list <uclinux-dev@uclinux.org>
Subject: [RFC 06/14] Coldfire generic GPIO (m68knommu)
Date: Wed, 11 Mar 2009 13:55:58 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@snapgear.com>
MIME-Version: 1.0
Content-Disposition: inline
Organization: fdwdc.com
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200903111455.58549.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Steven King <sfking@fdwdc.com>

diff --git a/arch/m68k/include/asm/m5249sim.h b/arch/m68k/include/asm/m5249sim.h
index 366eb86..2c23a83 100644
--- a/arch/m68k/include/asm/m5249sim.h
+++ b/arch/m68k/include/asm/m5249sim.h
@@ -73,14 +73,14 @@
 /*
  *	General purpose IO registers (in MBAR2).
  */
-#define	MCFSIM2_GPIOREAD	0x0		/* GPIO read values */
-#define	MCFSIM2_GPIOWRITE	0x4		/* GPIO write values */
-#define	MCFSIM2_GPIOENABLE	0x8		/* GPIO enabled */
-#define	MCFSIM2_GPIOFUNC	0xc		/* GPIO function */
-#define	MCFSIM2_GPIO1READ	0xb0		/* GPIO1 read values */
-#define	MCFSIM2_GPIO1WRITE	0xb4		/* GPIO1 write values */
-#define	MCFSIM2_GPIO1ENABLE	0xb8		/* GPIO1 enabled */
-#define	MCFSIM2_GPIO1FUNC	0xbc		/* GPIO1 function */
+#define	MCFSIM2_GPIOREAD	(MCF_MBAR2 + 0x000)	/* GPIO read values */
+#define	MCFSIM2_GPIOWRITE	(MCF_MBAR2 + 0x004)	/* GPIO write values */
+#define	MCFSIM2_GPIOENABLE	(MCF_MBAR2 + 0x008)	/* GPIO enabled */
+#define	MCFSIM2_GPIOFUNC	(MCF_MBAR2 + 0x00C)	/* GPIO function */
+#define	MCFSIM2_GPIO1READ	(MCF_MBAR2 + 0x0B0)	/* GPIO1 read values */
+#define	MCFSIM2_GPIO1WRITE	(MCF_MBAR2 + 0x0B4)	/* GPIO1 write values */
+#define	MCFSIM2_GPIO1ENABLE	(MCF_MBAR2 + 0x0B8)	/* GPIO1 enabled */
+#define	MCFSIM2_GPIO1FUNC	(MCF_MBAR2 + 0x0BC)	/* GPIO1 function */
 
 #define	MCFSIM2_GPIOINTSTAT	0xc0		/* GPIO interrupt status */
 #define	MCFSIM2_GPIOINTCLEAR	0xc0		/* GPIO interrupt clear */
@@ -100,7 +100,12 @@
 #define	MCFSIM2_IDECONFIG1	0x18c		/* IDEconfig1 */
 #define	MCFSIM2_IDECONFIG2	0x190		/* IDEconfig2 */
 
-
+/*
+ * Generic GPIO support
+ */
+#define MCFGPIO_PIN_MAX		64
+#define MCFGPIO_IRQ_MAX		-1
+#define MCFGPIO_IRQ_VECBASE	-1
 /*
  *	Macro to set IMR register. It is 32 bits on the 5249.
  */
-- 
Steven King -- sfking at fdwdc dot com
