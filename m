Return-Path: <linux-kernel-owner+w=401wt.eu-S1030824AbXDQRzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030824AbXDQRzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030827AbXDQRzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:55:15 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:59137 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030824AbXDQRzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:55:11 -0400
Date: Tue, 17 Apr 2007 13:53:38 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org
Subject: [PATCH] include files: convert "include" subdirectory to UTF-8
Message-ID: <alpine.DEB.0.83.0704171345510.914@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1875672472-926641575-1176832419=:914"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1875672472-926641575-1176832419=:914
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

From: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

Convert the "include" subdirectory to UTF-8. The following files are 
changed.

include/net/irda/{iriap.h,irttp.h,iriap_event.h,parameters.h}
include/net/irda/{irlmp_frame.h,irlan_eth.h,irlan_provider.h}
include/net/irda/{irlan_event.h,wrapper.h,af_irda.h,irlmp.h}
include/net/irda/{irmod.h,irlap.h,irlan_filter.h,timer.h,irqueue.h}
include/net/irda/{irda.h,irias_object.h,irlan_client.h}
include/net/irda/{irlan_common.h,irlmp_event.h}
include/linux/i2c-algo-pcf.h
include/linux/crypto.h
include/linux/meye.h
include/linux/sonypi.h
include/linux/i2c-algo-bit.h
include/linux/irda.h
include/asm-arm/arch-imx/imx-regs.h
include/asm-arm/arch-omap/{board.h,dma.h,gpio.h}
include/asm-arm/arch-integrator/platform.h
include/asm-m68k/{atariints.h,atarihw.h}
include/asm-ppc/hydra.h

Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

---

I can't get my mail client to send in ISO-8859-1 explicitly instead of 
whatever it decides I want, so the actual patch is attached in 
octet-stream format. The below patch is just for reference and will very 
likely NOT work, unless this time it picks ISO-8859-1.

Also, since the patch includes both encodings, whichever encoding you 
select while viewing it will display one correct and one garbled line. 
However, the bytecodes -are- correct.

diff -uprN linux-2.6.21-rc7.orig/include/asm-arm/arch-imx/imx-regs.h linux-2.6.21-rc7.mod/include/asm-arm/arch-imx/imx-regs.h
--- linux-2.6.21-rc7.orig/include/asm-arm/arch-imx/imx-regs.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/asm-arm/arch-imx/imx-regs.h	2007-04-17 13:43:32.000000000 -0400
@@ -297,7 +297,7 @@
 #define SAR(x)  __REG2( IMX_DMAC_BASE + 0x80, (x) << 6)	/* Source Address Registers */
 #define DAR(x)  __REG2( IMX_DMAC_BASE + 0x84, (x) << 6)	/* Destination Address Registers */
 #define CNTR(x) __REG2( IMX_DMAC_BASE + 0x88, (x) << 6)	/* Count Registers */
-#define CCR(x)  __REG2( IMX_DMAC_BASE + 0x8c, (x) << 6)	/* Control Registers */
+#define CCR(x)  __REG2( IMX_DMAC_BASE + 0x8c, (x) << 6)	/* Control Registers */
 #define RSSR(x) __REG2( IMX_DMAC_BASE + 0x90, (x) << 6)	/* Request source select Registers */
 #define BLR(x)  __REG2( IMX_DMAC_BASE + 0x94, (x) << 6)	/* Burst length Registers */
 #define RTOR(x) __REG2( IMX_DMAC_BASE + 0x98, (x) << 6)	/* Request timeout Registers */
diff -uprN linux-2.6.21-rc7.orig/include/asm-arm/arch-integrator/platform.h linux-2.6.21-rc7.mod/include/asm-arm/arch-integrator/platform.h
--- linux-2.6.21-rc7.orig/include/asm-arm/arch-integrator/platform.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/asm-arm/arch-integrator/platform.h	2007-04-17 13:38:29.000000000 -0400
@@ -17,7 +17,7 @@
  *                 from .s file by awk -f s2h.awk
  */
 /**************************************************************************
- * * Copyright © ARM Limited 1998.  All rights reserved.
+ * * Copyright Â© ARM Limited 1998.  All rights reserved.
  * ***********************************************************************/
 /* ************************************************************************
  *
diff -uprN linux-2.6.21-rc7.orig/include/asm-arm/arch-omap/board.h linux-2.6.21-rc7.mod/include/asm-arm/arch-omap/board.h
--- linux-2.6.21-rc7.orig/include/asm-arm/arch-omap/board.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/asm-arm/arch-omap/board.h	2007-04-17 13:38:29.000000000 -0400
@@ -4,7 +4,7 @@
  *  Information structures for board-specific data
  *
  *  Copyright (C) 2004	Nokia Corporation
- *  Written by Juha Yrjölä <juha.yrjola@nokia.com>
+ *  Written by Juha YrjÃ¶lÃ¤ <juha.yrjola@nokia.com>
  */
 
 #ifndef _OMAP_BOARD_H
diff -uprN linux-2.6.21-rc7.orig/include/asm-arm/arch-omap/dma.h linux-2.6.21-rc7.mod/include/asm-arm/arch-omap/dma.h
--- linux-2.6.21-rc7.orig/include/asm-arm/arch-omap/dma.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/asm-arm/arch-omap/dma.h	2007-04-17 13:38:29.000000000 -0400
@@ -2,7 +2,7 @@
  *  linux/include/asm-arm/arch-omap/dma.h
  *
  *  Copyright (C) 2003 Nokia Corporation
- *  Author: Juha Yrjölä <juha.yrjola@nokia.com>
+ *  Author: Juha YrjÃ¶lÃ¤ <juha.yrjola@nokia.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff -uprN linux-2.6.21-rc7.orig/include/asm-arm/arch-omap/gpio.h linux-2.6.21-rc7.mod/include/asm-arm/arch-omap/gpio.h
--- linux-2.6.21-rc7.orig/include/asm-arm/arch-omap/gpio.h	2007-04-17 11:42:07.000000000 -0400
+++ linux-2.6.21-rc7.mod/include/asm-arm/arch-omap/gpio.h	2007-04-17 13:38:29.000000000 -0400
@@ -5,7 +5,7 @@
  *
  * Copyright (C) 2003-2005 Nokia Corporation
  *
- * Written by Juha Yrjölä <juha.yrjola@nokia.com>
+ * Written by Juha YrjÃ¶lÃ¤ <juha.yrjola@nokia.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff -uprN linux-2.6.21-rc7.orig/include/asm-m68k/atarihw.h linux-2.6.21-rc7.mod/include/asm-m68k/atarihw.h
--- linux-2.6.21-rc7.orig/include/asm-m68k/atarihw.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/asm-m68k/atarihw.h	2007-04-17 13:38:29.000000000 -0400
@@ -2,7 +2,7 @@
 ** linux/atarihw.h -- This header defines some macros and pointers for
 **                    the various Atari custom hardware registers.
 **
-** Copyright 1994 by Bj”rn Brauel
+** Copyright 1994 by BjÂ”rn Brauel
 **
 ** 5/1/94 Roman Hodek:
 **   Added definitions for TT specific chips.
diff -uprN linux-2.6.21-rc7.orig/include/asm-m68k/atariints.h linux-2.6.21-rc7.mod/include/asm-m68k/atariints.h
--- linux-2.6.21-rc7.orig/include/asm-m68k/atariints.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/asm-m68k/atariints.h	2007-04-17 13:38:29.000000000 -0400
@@ -1,7 +1,7 @@
 /*
 ** atariints.h -- Atari Linux interrupt handling structs and prototypes
 **
-** Copyright 1994 by Bj”rn Brauel
+** Copyright 1994 by BjÂ”rn Brauel
 **
 ** 5/2/94 Roman Hodek:
 **   TT interrupt definitions added.
diff -uprN linux-2.6.21-rc7.orig/include/asm-ppc/hydra.h linux-2.6.21-rc7.mod/include/asm-ppc/hydra.h
--- linux-2.6.21-rc7.orig/include/asm-ppc/hydra.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/asm-ppc/hydra.h	2007-04-17 13:38:29.000000000 -0400
@@ -8,7 +8,7 @@
  *	Macintosh Technology in the Common Hardware Reference Platform
  *	Apple Computer, Inc.
  *
- *	© Copyright 1995 Apple Computer, Inc. All rights reserved.
+ *	Â© Copyright 1995 Apple Computer, Inc. All rights reserved.
  *
  *  It's available online from http://chrp.apple.com/MacTech.pdf.
  *  You can obtain paper copies of this book from computer bookstores or by
diff -uprN linux-2.6.21-rc7.orig/include/linux/crypto.h linux-2.6.21-rc7.mod/include/linux/crypto.h
--- linux-2.6.21-rc7.orig/include/linux/crypto.h	2007-04-17 11:42:11.000000000 -0400
+++ linux-2.6.21-rc7.mod/include/linux/crypto.h	2007-04-17 13:38:29.000000000 -0400
@@ -6,7 +6,7 @@
  * Copyright (c) 2005 Herbert Xu <herbert@gondor.apana.org.au>
  *
  * Portions derived from Cryptoapi, by Alexander Kjeldaas <astor@fast.no>
- * and Nettle, by Niels Möller.
+ * and Nettle, by Niels MÃ¶ller.
  * 
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
diff -uprN linux-2.6.21-rc7.orig/include/linux/i2c-algo-bit.h linux-2.6.21-rc7.mod/include/linux/i2c-algo-bit.h
--- linux-2.6.21-rc7.orig/include/linux/i2c-algo-bit.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/linux/i2c-algo-bit.h	2007-04-17 13:38:29.000000000 -0400
@@ -18,7 +18,7 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.                */
 /* ------------------------------------------------------------------------- */
 
-/* With some changes from Kyösti Mälkki <kmalkki@cc.hut.fi> and even
+/* With some changes from KyÃ¶sti MÃ¤lkki <kmalkki@cc.hut.fi> and even
    Frodo Looijaard <frodol@dds.nl> */
 
 #ifndef _LINUX_I2C_ALGO_BIT_H
diff -uprN linux-2.6.21-rc7.orig/include/linux/i2c-algo-pcf.h linux-2.6.21-rc7.mod/include/linux/i2c-algo-pcf.h
--- linux-2.6.21-rc7.orig/include/linux/i2c-algo-pcf.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/linux/i2c-algo-pcf.h	2007-04-17 13:38:29.000000000 -0400
@@ -19,7 +19,7 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.                */
 /* ------------------------------------------------------------------------- */
 
-/* With some changes from Kyösti Mälkki <kmalkki@cc.hut.fi> and even
+/* With some changes from KyÃ¶sti MÃ¤lkki <kmalkki@cc.hut.fi> and even
    Frodo Looijaard <frodol@dds.nl> */
 
 #ifndef _LINUX_I2C_ALGO_PCF_H
diff -uprN linux-2.6.21-rc7.orig/include/linux/irda.h linux-2.6.21-rc7.mod/include/linux/irda.h
--- linux-2.6.21-rc7.orig/include/linux/irda.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/linux/irda.h	2007-04-17 13:38:29.000000000 -0400
@@ -16,7 +16,7 @@
  *     published by the Free Software Foundation; either version 2 of 
  *     the License, or (at your option) any later version.
  *  
- *     Neither Dag Brattli nor University of Tromsø admit liability nor
+ *     Neither Dag Brattli nor University of TromsÃ¸ admit liability nor
  *     provide warranty for any of this software. This material is 
  *     provided "AS-IS" and at no charge.
  *
diff -uprN linux-2.6.21-rc7.orig/include/linux/meye.h linux-2.6.21-rc7.mod/include/linux/meye.h
--- linux-2.6.21-rc7.orig/include/linux/meye.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/linux/meye.h	2007-04-17 13:38:29.000000000 -0400
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2001-2003 Stelian Pop <stelian@popies.net>
  *
- * Copyright (C) 2001-2002 Alcôve <www.alcove.com>
+ * Copyright (C) 2001-2002 AlcÃ´ve <www.alcove.com>
  *
  * Copyright (C) 2000 Andrew Tridgell <tridge@valinux.com>
  *
diff -uprN linux-2.6.21-rc7.orig/include/linux/sonypi.h linux-2.6.21-rc7.mod/include/linux/sonypi.h
--- linux-2.6.21-rc7.orig/include/linux/sonypi.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/linux/sonypi.h	2007-04-17 13:38:29.000000000 -0400
@@ -5,7 +5,7 @@
  *
  * Copyright (C) 2005 Narayanan R S <nars@kadamba.org>
 
- * Copyright (C) 2001-2002 Alcôve <www.alcove.com>
+ * Copyright (C) 2001-2002 AlcÃ´ve <www.alcove.com>
  *
  * Copyright (C) 2001 Michael Ashley <m.ashley@unsw.edu.au>
  *
diff -uprN linux-2.6.21-rc7.orig/include/net/irda/af_irda.h linux-2.6.21-rc7.mod/include/net/irda/af_irda.h
--- linux-2.6.21-rc7.orig/include/net/irda/af_irda.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/net/irda/af_irda.h	2007-04-17 13:38:29.000000000 -0400
@@ -17,7 +17,7 @@
  *     published by the Free Software Foundation; either version 2 of 
  *     the License, or (at your option) any later version.
  *  
- *     Neither Dag Brattli nor University of Tromsø admit liability nor
+ *     Neither Dag Brattli nor University of TromsÃ¸ admit liability nor
  *     provide warranty for any of this software. This material is 
  *     provided "AS-IS" and at no charge.
  *     
diff -uprN linux-2.6.21-rc7.orig/include/net/irda/irda.h linux-2.6.21-rc7.mod/include/net/irda/irda.h
--- linux-2.6.21-rc7.orig/include/net/irda/irda.h	2007-04-17 11:42:13.000000000 -0400
+++ linux-2.6.21-rc7.mod/include/net/irda/irda.h	2007-04-17 13:38:29.000000000 -0400
@@ -17,7 +17,7 @@
  *     published by the Free Software Foundation; either version 2 of 
  *     the License, or (at your option) any later version.
  *  
- *     Neither Dag Brattli nor University of Tromsø admit liability nor
+ *     Neither Dag Brattli nor University of TromsÃ¸ admit liability nor
  *     provide warranty for any of this software. This material is 
  *     provided "AS-IS" and at no charge.
  *     
diff -uprN linux-2.6.21-rc7.orig/include/net/irda/iriap_event.h linux-2.6.21-rc7.mod/include/net/irda/iriap_event.h
--- linux-2.6.21-rc7.orig/include/net/irda/iriap_event.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/net/irda/iriap_event.h	2007-04-17 13:38:29.000000000 -0400
@@ -16,7 +16,7 @@
  *     published by the Free Software Foundation; either version 2 of 
  *     the License, or (at your option) any later version.
  *
- *     Neither Dag Brattli nor University of Tromsø admit liability nor
+ *     Neither Dag Brattli nor University of TromsÃ¸ admit liability nor
  *     provide warranty for any of this software. This material is 
  *     provided "AS-IS" and at no charge.
  *
diff -uprN linux-2.6.21-rc7.orig/include/net/irda/iriap.h linux-2.6.21-rc7.mod/include/net/irda/iriap.h
--- linux-2.6.21-rc7.orig/include/net/irda/iriap.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/net/irda/iriap.h	2007-04-17 13:38:29.000000000 -0400
@@ -17,7 +17,7 @@
  *     published by the Free Software Foundation; either version 2 of 
  *     the License, or (at your option) any later version.
  *
- *     Neither Dag Brattli nor University of Tromsø admit liability nor
+ *     Neither Dag Brattli nor University of TromsÃ¸ admit liability nor
  *     provide warranty for any of this software. This material is 
  *     provided "AS-IS" and at no charge.
  *
diff -uprN linux-2.6.21-rc7.orig/include/net/irda/irias_object.h linux-2.6.21-rc7.mod/include/net/irda/irias_object.h
--- linux-2.6.21-rc7.orig/include/net/irda/irias_object.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/net/irda/irias_object.h	2007-04-17 13:38:29.000000000 -0400
@@ -16,7 +16,7 @@
  *     published by the Free Software Foundation; either version 2 of 
  *     the License, or (at your option) any later version.
  *  
- *     Neither Dag Brattli nor University of Tromsø admit liability nor
+ *     Neither Dag Brattli nor University of TromsÃ¸ admit liability nor
  *     provide warranty for any of this software. This material is 
  *     provided "AS-IS" and at no charge.
  *     
diff -uprN linux-2.6.21-rc7.orig/include/net/irda/irlan_client.h linux-2.6.21-rc7.mod/include/net/irda/irlan_client.h
--- linux-2.6.21-rc7.orig/include/net/irda/irlan_client.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/net/irda/irlan_client.h	2007-04-17 13:38:29.000000000 -0400
@@ -16,7 +16,7 @@
  *     published by the Free Software Foundation; either version 2 of 
  *     the License, or (at your option) any later version.
  *
- *     Neither Dag Brattli nor University of Tromsø admit liability nor
+ *     Neither Dag Brattli nor University of TromsÃ¸ admit liability nor
  *     provide warranty for any of this software. This material is 
  *     provided "AS-IS" and at no charge.
  *
diff -uprN linux-2.6.21-rc7.orig/include/net/irda/irlan_common.h linux-2.6.21-rc7.mod/include/net/irda/irlan_common.h
--- linux-2.6.21-rc7.orig/include/net/irda/irlan_common.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/net/irda/irlan_common.h	2007-04-17 13:38:29.000000000 -0400
@@ -17,7 +17,7 @@
  *     published by the Free Software Foundation; either version 2 of 
  *     the License, or (at your option) any later version.
  *
- *     Neither Dag Brattli nor University of Tromsø admit liability nor
+ *     Neither Dag Brattli nor University of TromsÃ¸ admit liability nor
  *     provide warranty for any of this software. This material is 
  *     provided "AS-IS" and at no charge.
  *
diff -uprN linux-2.6.21-rc7.orig/include/net/irda/irlan_eth.h linux-2.6.21-rc7.mod/include/net/irda/irlan_eth.h
--- linux-2.6.21-rc7.orig/include/net/irda/irlan_eth.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/net/irda/irlan_eth.h	2007-04-17 13:38:29.000000000 -0400
@@ -16,7 +16,7 @@
  *     published by the Free Software Foundation; either version 2 of 
  *     the License, or (at your option) any later version.
  *  
- *     Neither Dag Brattli nor University of Tromsø admit liability nor
+ *     Neither Dag Brattli nor University of TromsÃ¸ admit liability nor
  *     provide warranty for any of this software. This material is 
  *     provided "AS-IS" and at no charge.
  *     
diff -uprN linux-2.6.21-rc7.orig/include/net/irda/irlan_event.h linux-2.6.21-rc7.mod/include/net/irda/irlan_event.h
--- linux-2.6.21-rc7.orig/include/net/irda/irlan_event.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/net/irda/irlan_event.h	2007-04-17 13:38:29.000000000 -0400
@@ -16,7 +16,7 @@
  *     published by the Free Software Foundation; either version 2 of 
  *     the License, or (at your option) any later version.
  *
- *     Neither Dag Brattli nor University of Tromsø admit liability nor
+ *     Neither Dag Brattli nor University of TromsÃ¸ admit liability nor
  *     provide warranty for any of this software. This material is 
  *     provided "AS-IS" and at no charge.
  *
diff -uprN linux-2.6.21-rc7.orig/include/net/irda/irlan_filter.h linux-2.6.21-rc7.mod/include/net/irda/irlan_filter.h
--- linux-2.6.21-rc7.orig/include/net/irda/irlan_filter.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/net/irda/irlan_filter.h	2007-04-17 13:38:29.000000000 -0400
@@ -16,7 +16,7 @@
  *     published by the Free Software Foundation; either version 2 of 
  *     the License, or (at your option) any later version.
  *  
- *     Neither Dag Brattli nor University of Tromsø admit liability nor
+ *     Neither Dag Brattli nor University of TromsÃ¸ admit liability nor
  *     provide warranty for any of this software. This material is 
  *     provided "AS-IS" and at no charge.
  *     
diff -uprN linux-2.6.21-rc7.orig/include/net/irda/irlan_provider.h linux-2.6.21-rc7.mod/include/net/irda/irlan_provider.h
--- linux-2.6.21-rc7.orig/include/net/irda/irlan_provider.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/net/irda/irlan_provider.h	2007-04-17 13:38:29.000000000 -0400
@@ -16,7 +16,7 @@
  *     published by the Free Software Foundation; either version 2 of 
  *     the License, or (at your option) any later version.
  *
- *     Neither Dag Brattli nor University of Tromsø admit liability nor
+ *     Neither Dag Brattli nor University of TromsÃ¸ admit liability nor
  *     provide warranty for any of this software. This material is 
  *     provided "AS-IS" and at no charge.
  *
diff -uprN linux-2.6.21-rc7.orig/include/net/irda/irlap.h linux-2.6.21-rc7.mod/include/net/irda/irlap.h
--- linux-2.6.21-rc7.orig/include/net/irda/irlap.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/net/irda/irlap.h	2007-04-17 13:38:29.000000000 -0400
@@ -18,7 +18,7 @@
  *     published by the Free Software Foundation; either version 2 of 
  *     the License, or (at your option) any later version.
  *
- *     Neither Dag Brattli nor University of Tromsø admit liability nor
+ *     Neither Dag Brattli nor University of TromsÃ¸ admit liability nor
  *     provide warranty for any of this software. This material is 
  *     provided "AS-IS" and at no charge.
  *
diff -uprN linux-2.6.21-rc7.orig/include/net/irda/irlmp_event.h linux-2.6.21-rc7.mod/include/net/irda/irlmp_event.h
--- linux-2.6.21-rc7.orig/include/net/irda/irlmp_event.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/net/irda/irlmp_event.h	2007-04-17 13:38:29.000000000 -0400
@@ -18,7 +18,7 @@
  *     published by the Free Software Foundation; either version 2 of 
  *     the License, or (at your option) any later version.
  *
- *     Neither Dag Brattli nor University of Tromsø admit liability nor
+ *     Neither Dag Brattli nor University of TromsÃ¸ admit liability nor
  *     provide warranty for any of this software. This material is 
  *     provided "AS-IS" and at no charge.
  *
diff -uprN linux-2.6.21-rc7.orig/include/net/irda/irlmp_frame.h linux-2.6.21-rc7.mod/include/net/irda/irlmp_frame.h
--- linux-2.6.21-rc7.orig/include/net/irda/irlmp_frame.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/net/irda/irlmp_frame.h	2007-04-17 13:38:29.000000000 -0400
@@ -17,7 +17,7 @@
  *     published by the Free Software Foundation; either version 2 of 
  *     the License, or (at your option) any later version.
  *
- *     Neither Dag Brattli nor University of Tromsø admit liability nor
+ *     Neither Dag Brattli nor University of TromsÃ¸ admit liability nor
  *     provide warranty for any of this software. This material is 
  *     provided "AS-IS" and at no charge.
  *
diff -uprN linux-2.6.21-rc7.orig/include/net/irda/irlmp.h linux-2.6.21-rc7.mod/include/net/irda/irlmp.h
--- linux-2.6.21-rc7.orig/include/net/irda/irlmp.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/net/irda/irlmp.h	2007-04-17 13:38:29.000000000 -0400
@@ -18,7 +18,7 @@
  *     published by the Free Software Foundation; either version 2 of 
  *     the License, or (at your option) any later version.
  *
- *     Neither Dag Brattli nor University of Tromsø admit liability nor
+ *     Neither Dag Brattli nor University of TromsÃ¸ admit liability nor
  *     provide warranty for any of this software. This material is 
  *     provided "AS-IS" and at no charge.
  *
diff -uprN linux-2.6.21-rc7.orig/include/net/irda/irmod.h linux-2.6.21-rc7.mod/include/net/irda/irmod.h
--- linux-2.6.21-rc7.orig/include/net/irda/irmod.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/net/irda/irmod.h	2007-04-17 13:38:29.000000000 -0400
@@ -17,7 +17,7 @@
  *     published by the Free Software Foundation; either version 2 of 
  *     the License, or (at your option) any later version.
  *  
- *     Neither Dag Brattli nor University of Tromsø admit liability nor
+ *     Neither Dag Brattli nor University of TromsÃ¸ admit liability nor
  *     provide warranty for any of this software. This material is 
  *     provided "AS-IS" and at no charg.
  *     
diff -uprN linux-2.6.21-rc7.orig/include/net/irda/irqueue.h linux-2.6.21-rc7.mod/include/net/irda/irqueue.h
--- linux-2.6.21-rc7.orig/include/net/irda/irqueue.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/net/irda/irqueue.h	2007-04-17 13:38:29.000000000 -0400
@@ -21,7 +21,7 @@
  *     published by the Free Software Foundation; either version 2 of 
  *     the License, or (at your option) any later version.
  *  
- *     Neither Dag Brattli nor University of Tromsø admit liability nor
+ *     Neither Dag Brattli nor University of TromsÃ¸ admit liability nor
  *     provide warranty for any of this software. This material is 
  *     provided "AS-IS" and at no charge.
  *     
diff -uprN linux-2.6.21-rc7.orig/include/net/irda/irttp.h linux-2.6.21-rc7.mod/include/net/irda/irttp.h
--- linux-2.6.21-rc7.orig/include/net/irda/irttp.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/net/irda/irttp.h	2007-04-17 13:38:29.000000000 -0400
@@ -18,7 +18,7 @@
  *     published by the Free Software Foundation; either version 2 of 
  *     the License, or (at your option) any later version.
  *
- *     Neither Dag Brattli nor University of Tromsø admit liability nor
+ *     Neither Dag Brattli nor University of TromsÃ¸ admit liability nor
  *     provide warranty for any of this software. This material is 
  *     provided "AS-IS" and at no charge.
  *
diff -uprN linux-2.6.21-rc7.orig/include/net/irda/parameters.h linux-2.6.21-rc7.mod/include/net/irda/parameters.h
--- linux-2.6.21-rc7.orig/include/net/irda/parameters.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/net/irda/parameters.h	2007-04-17 13:38:29.000000000 -0400
@@ -26,7 +26,7 @@
  *     Foundation, Inc., 59 Temple Place, Suite 330, Boston, 
  *     MA 02111-1307 USA
  *
- *     Michel Dänzer <daenzer@debian.org>, 10/2001
+ *     Michel DÃ¤nzer <daenzer@debian.org>, 10/2001
  *     - simplify irda_pv_t to avoid endianness issues
  *     
  ********************************************************************/
diff -uprN linux-2.6.21-rc7.orig/include/net/irda/timer.h linux-2.6.21-rc7.mod/include/net/irda/timer.h
--- linux-2.6.21-rc7.orig/include/net/irda/timer.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/net/irda/timer.h	2007-04-17 13:38:29.000000000 -0400
@@ -18,7 +18,7 @@
  *     published by the Free Software Foundation; either version 2 of 
  *     the License, or (at your option) any later version.
  *
- *     Neither Dag Brattli nor University of Tromsø admit liability nor
+ *     Neither Dag Brattli nor University of TromsÃ¸ admit liability nor
  *     provide warranty for any of this software. This material is 
  *     provided "AS-IS" and at no charge.
  *
diff -uprN linux-2.6.21-rc7.orig/include/net/irda/wrapper.h linux-2.6.21-rc7.mod/include/net/irda/wrapper.h
--- linux-2.6.21-rc7.orig/include/net/irda/wrapper.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/include/net/irda/wrapper.h	2007-04-17 13:38:29.000000000 -0400
@@ -17,7 +17,7 @@
  *     published by the Free Software Foundation; either version 2 of 
  *     the License, or (at your option) any later version.
  *
- *     Neither Dag Brattli nor University of Tromsø admit liability nor
+ *     Neither Dag Brattli nor University of TromsÃ¸ admit liability nor
  *     provide warranty for any of this software. This material is 
  *     provided "AS-IS" and at no charge.
  *
--1875672472-926641575-1176832419=:914
Content-Type: APPLICATION/octet-stream; name=patch-include.bin
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.0.83.0704171353380.914@sigma.j-a-k-j.com>
Content-Description: 
Content-Disposition: attachment; filename=patch-include.bin

ZGlmZiAtdXByTiBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvaW5jbHVkZS9hc20t
YXJtL2FyY2gtaW14L2lteC1yZWdzLmggbGludXgtMi42LjIxLXJjNy5tb2Qv
aW5jbHVkZS9hc20tYXJtL2FyY2gtaW14L2lteC1yZWdzLmgKLS0tIGxpbnV4
LTIuNi4yMS1yYzcub3JpZy9pbmNsdWRlL2FzbS1hcm0vYXJjaC1pbXgvaW14
LXJlZ3MuaAkyMDA3LTAyLTA0IDEzOjQ0OjU0LjAwMDAwMDAwMCAtMDUwMAor
KysgbGludXgtMi42LjIxLXJjNy5tb2QvaW5jbHVkZS9hc20tYXJtL2FyY2gt
aW14L2lteC1yZWdzLmgJMjAwNy0wNC0xNyAxMzo0MzozMi4wMDAwMDAwMDAg
LTA0MDAKQEAgLTI5Nyw3ICsyOTcsNyBAQAogI2RlZmluZSBTQVIoeCkgIF9f
UkVHMiggSU1YX0RNQUNfQkFTRSArIDB4ODAsICh4KSA8PCA2KQkvKiBTb3Vy
Y2UgQWRkcmVzcyBSZWdpc3RlcnMgKi8KICNkZWZpbmUgREFSKHgpICBfX1JF
RzIoIElNWF9ETUFDX0JBU0UgKyAweDg0LCAoeCkgPDwgNikJLyogRGVzdGlu
YXRpb24gQWRkcmVzcyBSZWdpc3RlcnMgKi8KICNkZWZpbmUgQ05UUih4KSBf
X1JFRzIoIElNWF9ETUFDX0JBU0UgKyAweDg4LCAoeCkgPDwgNikJLyogQ291
bnQgUmVnaXN0ZXJzICovCi0jZGVmaW5lIENDUih4KSAgX19SRUcyKCBJTVhf
RE1BQ19CQVNFICsgMHg4YywgKHgpIDw8IDYpCS8qoENvbnRyb2wgUmVnaXN0
ZXJzICovCisjZGVmaW5lIENDUih4KSAgX19SRUcyKCBJTVhfRE1BQ19CQVNF
ICsgMHg4YywgKHgpIDw8IDYpCS8qIENvbnRyb2wgUmVnaXN0ZXJzICovCiAj
ZGVmaW5lIFJTU1IoeCkgX19SRUcyKCBJTVhfRE1BQ19CQVNFICsgMHg5MCwg
KHgpIDw8IDYpCS8qIFJlcXVlc3Qgc291cmNlIHNlbGVjdCBSZWdpc3RlcnMg
Ki8KICNkZWZpbmUgQkxSKHgpICBfX1JFRzIoIElNWF9ETUFDX0JBU0UgKyAw
eDk0LCAoeCkgPDwgNikJLyogQnVyc3QgbGVuZ3RoIFJlZ2lzdGVycyAqLwog
I2RlZmluZSBSVE9SKHgpIF9fUkVHMiggSU1YX0RNQUNfQkFTRSArIDB4OTgs
ICh4KSA8PCA2KQkvKiBSZXF1ZXN0IHRpbWVvdXQgUmVnaXN0ZXJzICovCmRp
ZmYgLXVwck4gbGludXgtMi42LjIxLXJjNy5vcmlnL2luY2x1ZGUvYXNtLWFy
bS9hcmNoLWludGVncmF0b3IvcGxhdGZvcm0uaCBsaW51eC0yLjYuMjEtcmM3
Lm1vZC9pbmNsdWRlL2FzbS1hcm0vYXJjaC1pbnRlZ3JhdG9yL3BsYXRmb3Jt
LmgKLS0tIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9pbmNsdWRlL2FzbS1hcm0v
YXJjaC1pbnRlZ3JhdG9yL3BsYXRmb3JtLmgJMjAwNy0wMi0wNCAxMzo0NDo1
NC4wMDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4LTIuNi4yMS1yYzcubW9kL2lu
Y2x1ZGUvYXNtLWFybS9hcmNoLWludGVncmF0b3IvcGxhdGZvcm0uaAkyMDA3
LTA0LTE3IDEzOjM4OjI5LjAwMDAwMDAwMCAtMDQwMApAQCAtMTcsNyArMTcs
NyBAQAogICogICAgICAgICAgICAgICAgIGZyb20gLnMgZmlsZSBieSBhd2sg
LWYgczJoLmF3awogICovCiAvKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioKLSAqICogQ29weXJpZ2h0IKkgQVJNIExpbWl0ZWQgMTk5OC4gIEFsbCBy
aWdodHMgcmVzZXJ2ZWQuCisgKiAqIENvcHlyaWdodCDCqSBBUk0gTGltaXRl
ZCAxOTk4LiAgQWxsIHJpZ2h0cyByZXNlcnZlZC4KICAqICoqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqLwogLyogKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqCiAgKgpkaWZmIC11cHJOIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9pbmNs
dWRlL2FzbS1hcm0vYXJjaC1vbWFwL2JvYXJkLmggbGludXgtMi42LjIxLXJj
Ny5tb2QvaW5jbHVkZS9hc20tYXJtL2FyY2gtb21hcC9ib2FyZC5oCi0tLSBs
aW51eC0yLjYuMjEtcmM3Lm9yaWcvaW5jbHVkZS9hc20tYXJtL2FyY2gtb21h
cC9ib2FyZC5oCTIwMDctMDItMDQgMTM6NDQ6NTQuMDAwMDAwMDAwIC0wNTAw
CisrKyBsaW51eC0yLjYuMjEtcmM3Lm1vZC9pbmNsdWRlL2FzbS1hcm0vYXJj
aC1vbWFwL2JvYXJkLmgJMjAwNy0wNC0xNyAxMzozODoyOS4wMDAwMDAwMDAg
LTA0MDAKQEAgLTQsNyArNCw3IEBACiAgKiAgSW5mb3JtYXRpb24gc3RydWN0
dXJlcyBmb3IgYm9hcmQtc3BlY2lmaWMgZGF0YQogICoKICAqICBDb3B5cmln
aHQgKEMpIDIwMDQJTm9raWEgQ29ycG9yYXRpb24KLSAqICBXcml0dGVuIGJ5
IEp1aGEgWXJq9mzkIDxqdWhhLnlyam9sYUBub2tpYS5jb20+CisgKiAgV3Jp
dHRlbiBieSBKdWhhIFlyasO2bMOkIDxqdWhhLnlyam9sYUBub2tpYS5jb20+
CiAgKi8KIAogI2lmbmRlZiBfT01BUF9CT0FSRF9ICmRpZmYgLXVwck4gbGlu
dXgtMi42LjIxLXJjNy5vcmlnL2luY2x1ZGUvYXNtLWFybS9hcmNoLW9tYXAv
ZG1hLmggbGludXgtMi42LjIxLXJjNy5tb2QvaW5jbHVkZS9hc20tYXJtL2Fy
Y2gtb21hcC9kbWEuaAotLS0gbGludXgtMi42LjIxLXJjNy5vcmlnL2luY2x1
ZGUvYXNtLWFybS9hcmNoLW9tYXAvZG1hLmgJMjAwNy0wMi0wNCAxMzo0NDo1
NC4wMDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4LTIuNi4yMS1yYzcubW9kL2lu
Y2x1ZGUvYXNtLWFybS9hcmNoLW9tYXAvZG1hLmgJMjAwNy0wNC0xNyAxMzoz
ODoyOS4wMDAwMDAwMDAgLTA0MDAKQEAgLTIsNyArMiw3IEBACiAgKiAgbGlu
dXgvaW5jbHVkZS9hc20tYXJtL2FyY2gtb21hcC9kbWEuaAogICoKICAqICBD
b3B5cmlnaHQgKEMpIDIwMDMgTm9raWEgQ29ycG9yYXRpb24KLSAqICBBdXRo
b3I6IEp1aGEgWXJq9mzkIDxqdWhhLnlyam9sYUBub2tpYS5jb20+CisgKiAg
QXV0aG9yOiBKdWhhIFlyasO2bMOkIDxqdWhhLnlyam9sYUBub2tpYS5jb20+
CiAgKgogICogVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBj
YW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2RpZnkKICAqIGl0IHVuZGVy
IHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2Ug
YXMgcHVibGlzaGVkIGJ5CmRpZmYgLXVwck4gbGludXgtMi42LjIxLXJjNy5v
cmlnL2luY2x1ZGUvYXNtLWFybS9hcmNoLW9tYXAvZ3Bpby5oIGxpbnV4LTIu
Ni4yMS1yYzcubW9kL2luY2x1ZGUvYXNtLWFybS9hcmNoLW9tYXAvZ3Bpby5o
Ci0tLSBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvaW5jbHVkZS9hc20tYXJtL2Fy
Y2gtb21hcC9ncGlvLmgJMjAwNy0wNC0xNyAxMTo0MjowNy4wMDAwMDAwMDAg
LTA0MDAKKysrIGxpbnV4LTIuNi4yMS1yYzcubW9kL2luY2x1ZGUvYXNtLWFy
bS9hcmNoLW9tYXAvZ3Bpby5oCTIwMDctMDQtMTcgMTM6Mzg6MjkuMDAwMDAw
MDAwIC0wNDAwCkBAIC01LDcgKzUsNyBAQAogICoKICAqIENvcHlyaWdodCAo
QykgMjAwMy0yMDA1IE5va2lhIENvcnBvcmF0aW9uCiAgKgotICogV3JpdHRl
biBieSBKdWhhIFlyavZs5CA8anVoYS55cmpvbGFAbm9raWEuY29tPgorICog
V3JpdHRlbiBieSBKdWhhIFlyasO2bMOkIDxqdWhhLnlyam9sYUBub2tpYS5j
b20+CiAgKgogICogVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlv
dSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2RpZnkKICAqIGl0IHVu
ZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vu
c2UgYXMgcHVibGlzaGVkIGJ5CmRpZmYgLXVwck4gbGludXgtMi42LjIxLXJj
Ny5vcmlnL2luY2x1ZGUvYXNtLW02OGsvYXRhcmlody5oIGxpbnV4LTIuNi4y
MS1yYzcubW9kL2luY2x1ZGUvYXNtLW02OGsvYXRhcmlody5oCi0tLSBsaW51
eC0yLjYuMjEtcmM3Lm9yaWcvaW5jbHVkZS9hc20tbTY4ay9hdGFyaWh3LmgJ
MjAwNy0wMi0wNCAxMzo0NDo1NC4wMDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4
LTIuNi4yMS1yYzcubW9kL2luY2x1ZGUvYXNtLW02OGsvYXRhcmlody5oCTIw
MDctMDQtMTcgMTM6Mzg6MjkuMDAwMDAwMDAwIC0wNDAwCkBAIC0yLDcgKzIs
NyBAQAogKiogbGludXgvYXRhcmlody5oIC0tIFRoaXMgaGVhZGVyIGRlZmlu
ZXMgc29tZSBtYWNyb3MgYW5kIHBvaW50ZXJzIGZvcgogKiogICAgICAgICAg
ICAgICAgICAgIHRoZSB2YXJpb3VzIEF0YXJpIGN1c3RvbSBoYXJkd2FyZSBy
ZWdpc3RlcnMuCiAqKgotKiogQ29weXJpZ2h0IDE5OTQgYnkgQmqUcm4gQnJh
dWVsCisqKiBDb3B5cmlnaHQgMTk5NCBieSBCasKUcm4gQnJhdWVsCiAqKgog
KiogNS8xLzk0IFJvbWFuIEhvZGVrOgogKiogICBBZGRlZCBkZWZpbml0aW9u
cyBmb3IgVFQgc3BlY2lmaWMgY2hpcHMuCmRpZmYgLXVwck4gbGludXgtMi42
LjIxLXJjNy5vcmlnL2luY2x1ZGUvYXNtLW02OGsvYXRhcmlpbnRzLmggbGlu
dXgtMi42LjIxLXJjNy5tb2QvaW5jbHVkZS9hc20tbTY4ay9hdGFyaWludHMu
aAotLS0gbGludXgtMi42LjIxLXJjNy5vcmlnL2luY2x1ZGUvYXNtLW02OGsv
YXRhcmlpbnRzLmgJMjAwNy0wMi0wNCAxMzo0NDo1NC4wMDAwMDAwMDAgLTA1
MDAKKysrIGxpbnV4LTIuNi4yMS1yYzcubW9kL2luY2x1ZGUvYXNtLW02OGsv
YXRhcmlpbnRzLmgJMjAwNy0wNC0xNyAxMzozODoyOS4wMDAwMDAwMDAgLTA0
MDAKQEAgLTEsNyArMSw3IEBACiAvKgogKiogYXRhcmlpbnRzLmggLS0gQXRh
cmkgTGludXggaW50ZXJydXB0IGhhbmRsaW5nIHN0cnVjdHMgYW5kIHByb3Rv
dHlwZXMKICoqCi0qKiBDb3B5cmlnaHQgMTk5NCBieSBCapRybiBCcmF1ZWwK
KyoqIENvcHlyaWdodCAxOTk0IGJ5IEJqwpRybiBCcmF1ZWwKICoqCiAqKiA1
LzIvOTQgUm9tYW4gSG9kZWs6CiAqKiAgIFRUIGludGVycnVwdCBkZWZpbml0
aW9ucyBhZGRlZC4KZGlmZiAtdXByTiBsaW51eC0yLjYuMjEtcmM3Lm9yaWcv
aW5jbHVkZS9hc20tcHBjL2h5ZHJhLmggbGludXgtMi42LjIxLXJjNy5tb2Qv
aW5jbHVkZS9hc20tcHBjL2h5ZHJhLmgKLS0tIGxpbnV4LTIuNi4yMS1yYzcu
b3JpZy9pbmNsdWRlL2FzbS1wcGMvaHlkcmEuaAkyMDA3LTAyLTA0IDEzOjQ0
OjU0LjAwMDAwMDAwMCAtMDUwMAorKysgbGludXgtMi42LjIxLXJjNy5tb2Qv
aW5jbHVkZS9hc20tcHBjL2h5ZHJhLmgJMjAwNy0wNC0xNyAxMzozODoyOS4w
MDAwMDAwMDAgLTA0MDAKQEAgLTgsNyArOCw3IEBACiAgKglNYWNpbnRvc2gg
VGVjaG5vbG9neSBpbiB0aGUgQ29tbW9uIEhhcmR3YXJlIFJlZmVyZW5jZSBQ
bGF0Zm9ybQogICoJQXBwbGUgQ29tcHV0ZXIsIEluYy4KICAqCi0gKgmpIENv
cHlyaWdodCAxOTk1IEFwcGxlIENvbXB1dGVyLCBJbmMuIEFsbCByaWdodHMg
cmVzZXJ2ZWQuCisgKgnCqSBDb3B5cmlnaHQgMTk5NSBBcHBsZSBDb21wdXRl
ciwgSW5jLiBBbGwgcmlnaHRzIHJlc2VydmVkLgogICoKICAqICBJdCdzIGF2
YWlsYWJsZSBvbmxpbmUgZnJvbSBodHRwOi8vY2hycC5hcHBsZS5jb20vTWFj
VGVjaC5wZGYuCiAgKiAgWW91IGNhbiBvYnRhaW4gcGFwZXIgY29waWVzIG9m
IHRoaXMgYm9vayBmcm9tIGNvbXB1dGVyIGJvb2tzdG9yZXMgb3IgYnkKZGlm
ZiAtdXByTiBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvaW5jbHVkZS9saW51eC9j
cnlwdG8uaCBsaW51eC0yLjYuMjEtcmM3Lm1vZC9pbmNsdWRlL2xpbnV4L2Ny
eXB0by5oCi0tLSBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvaW5jbHVkZS9saW51
eC9jcnlwdG8uaAkyMDA3LTA0LTE3IDExOjQyOjExLjAwMDAwMDAwMCAtMDQw
MAorKysgbGludXgtMi42LjIxLXJjNy5tb2QvaW5jbHVkZS9saW51eC9jcnlw
dG8uaAkyMDA3LTA0LTE3IDEzOjM4OjI5LjAwMDAwMDAwMCAtMDQwMApAQCAt
Niw3ICs2LDcgQEAKICAqIENvcHlyaWdodCAoYykgMjAwNSBIZXJiZXJ0IFh1
IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+CiAgKgogICogUG9ydGlv
bnMgZGVyaXZlZCBmcm9tIENyeXB0b2FwaSwgYnkgQWxleGFuZGVyIEtqZWxk
YWFzIDxhc3RvckBmYXN0Lm5vPgotICogYW5kIE5ldHRsZSwgYnkgTmllbHMg
TfZsbGVyLgorICogYW5kIE5ldHRsZSwgYnkgTmllbHMgTcO2bGxlci4KICAq
IAogICogVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4g
cmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2RpZnkgaXQKICAqIHVuZGVyIHRo
ZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgYXMg
cHVibGlzaGVkIGJ5IHRoZSBGcmVlCmRpZmYgLXVwck4gbGludXgtMi42LjIx
LXJjNy5vcmlnL2luY2x1ZGUvbGludXgvaTJjLWFsZ28tYml0LmggbGludXgt
Mi42LjIxLXJjNy5tb2QvaW5jbHVkZS9saW51eC9pMmMtYWxnby1iaXQuaAot
LS0gbGludXgtMi42LjIxLXJjNy5vcmlnL2luY2x1ZGUvbGludXgvaTJjLWFs
Z28tYml0LmgJMjAwNy0wMi0wNCAxMzo0NDo1NC4wMDAwMDAwMDAgLTA1MDAK
KysrIGxpbnV4LTIuNi4yMS1yYzcubW9kL2luY2x1ZGUvbGludXgvaTJjLWFs
Z28tYml0LmgJMjAwNy0wNC0xNyAxMzozODoyOS4wMDAwMDAwMDAgLTA0MDAK
QEAgLTE4LDcgKzE4LDcgQEAKICAgICBGb3VuZGF0aW9uLCBJbmMuLCA2NzUg
TWFzcyBBdmUsIENhbWJyaWRnZSwgTUEgMDIxMzksIFVTQS4gICAgICAgICAg
ICAgICAgKi8KIC8qIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0gKi8K
IAotLyogV2l0aCBzb21lIGNoYW5nZXMgZnJvbSBLefZzdGkgTeRsa2tpIDxr
bWFsa2tpQGNjLmh1dC5maT4gYW5kIGV2ZW4KKy8qIFdpdGggc29tZSBjaGFu
Z2VzIGZyb20gS3nDtnN0aSBNw6Rsa2tpIDxrbWFsa2tpQGNjLmh1dC5maT4g
YW5kIGV2ZW4KICAgIEZyb2RvIExvb2lqYWFyZCA8ZnJvZG9sQGRkcy5ubD4g
Ki8KIAogI2lmbmRlZiBfTElOVVhfSTJDX0FMR09fQklUX0gKZGlmZiAtdXBy
TiBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvaW5jbHVkZS9saW51eC9pMmMtYWxn
by1wY2YuaCBsaW51eC0yLjYuMjEtcmM3Lm1vZC9pbmNsdWRlL2xpbnV4L2ky
Yy1hbGdvLXBjZi5oCi0tLSBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvaW5jbHVk
ZS9saW51eC9pMmMtYWxnby1wY2YuaAkyMDA3LTAyLTA0IDEzOjQ0OjU0LjAw
MDAwMDAwMCAtMDUwMAorKysgbGludXgtMi42LjIxLXJjNy5tb2QvaW5jbHVk
ZS9saW51eC9pMmMtYWxnby1wY2YuaAkyMDA3LTA0LTE3IDEzOjM4OjI5LjAw
MDAwMDAwMCAtMDQwMApAQCAtMTksNyArMTksNyBAQAogICAgIEZvdW5kYXRp
b24sIEluYy4sIDY3NSBNYXNzIEF2ZSwgQ2FtYnJpZGdlLCBNQSAwMjEzOSwg
VVNBLiAgICAgICAgICAgICAgICAqLwogLyogLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLSAqLwogCi0vKiBXaXRoIHNvbWUgY2hhbmdlcyBmcm9tIEt5
9nN0aSBN5Gxra2kgPGttYWxra2lAY2MuaHV0LmZpPiBhbmQgZXZlbgorLyog
V2l0aCBzb21lIGNoYW5nZXMgZnJvbSBLecO2c3RpIE3DpGxra2kgPGttYWxr
a2lAY2MuaHV0LmZpPiBhbmQgZXZlbgogICAgRnJvZG8gTG9vaWphYXJkIDxm
cm9kb2xAZGRzLm5sPiAqLwogCiAjaWZuZGVmIF9MSU5VWF9JMkNfQUxHT19Q
Q0ZfSApkaWZmIC11cHJOIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9pbmNsdWRl
L2xpbnV4L2lyZGEuaCBsaW51eC0yLjYuMjEtcmM3Lm1vZC9pbmNsdWRlL2xp
bnV4L2lyZGEuaAotLS0gbGludXgtMi42LjIxLXJjNy5vcmlnL2luY2x1ZGUv
bGludXgvaXJkYS5oCTIwMDctMDItMDQgMTM6NDQ6NTQuMDAwMDAwMDAwIC0w
NTAwCisrKyBsaW51eC0yLjYuMjEtcmM3Lm1vZC9pbmNsdWRlL2xpbnV4L2ly
ZGEuaAkyMDA3LTA0LTE3IDEzOjM4OjI5LjAwMDAwMDAwMCAtMDQwMApAQCAt
MTYsNyArMTYsNyBAQAogICogICAgIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBT
b2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbiAyIG9mIAogICog
ICAgIHRoZSBMaWNlbnNlLCBvciAoYXQgeW91ciBvcHRpb24pIGFueSBsYXRl
ciB2ZXJzaW9uLgogICogIAotICogICAgIE5laXRoZXIgRGFnIEJyYXR0bGkg
bm9yIFVuaXZlcnNpdHkgb2YgVHJvbXP4IGFkbWl0IGxpYWJpbGl0eSBub3IK
KyAqICAgICBOZWl0aGVyIERhZyBCcmF0dGxpIG5vciBVbml2ZXJzaXR5IG9m
IFRyb21zw7ggYWRtaXQgbGlhYmlsaXR5IG5vcgogICogICAgIHByb3ZpZGUg
d2FycmFudHkgZm9yIGFueSBvZiB0aGlzIHNvZnR3YXJlLiBUaGlzIG1hdGVy
aWFsIGlzIAogICogICAgIHByb3ZpZGVkICJBUy1JUyIgYW5kIGF0IG5vIGNo
YXJnZS4KICAqCmRpZmYgLXVwck4gbGludXgtMi42LjIxLXJjNy5vcmlnL2lu
Y2x1ZGUvbGludXgvbWV5ZS5oIGxpbnV4LTIuNi4yMS1yYzcubW9kL2luY2x1
ZGUvbGludXgvbWV5ZS5oCi0tLSBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvaW5j
bHVkZS9saW51eC9tZXllLmgJMjAwNy0wMi0wNCAxMzo0NDo1NC4wMDAwMDAw
MDAgLTA1MDAKKysrIGxpbnV4LTIuNi4yMS1yYzcubW9kL2luY2x1ZGUvbGlu
dXgvbWV5ZS5oCTIwMDctMDQtMTcgMTM6Mzg6MjkuMDAwMDAwMDAwIC0wNDAw
CkBAIC0zLDcgKzMsNyBAQAogICoKICAqIENvcHlyaWdodCAoQykgMjAwMS0y
MDAzIFN0ZWxpYW4gUG9wIDxzdGVsaWFuQHBvcGllcy5uZXQ+CiAgKgotICog
Q29weXJpZ2h0IChDKSAyMDAxLTIwMDIgQWxj9HZlIDx3d3cuYWxjb3ZlLmNv
bT4KKyAqIENvcHlyaWdodCAoQykgMjAwMS0yMDAyIEFsY8O0dmUgPHd3dy5h
bGNvdmUuY29tPgogICoKICAqIENvcHlyaWdodCAoQykgMjAwMCBBbmRyZXcg
VHJpZGdlbGwgPHRyaWRnZUB2YWxpbnV4LmNvbT4KICAqCmRpZmYgLXVwck4g
bGludXgtMi42LjIxLXJjNy5vcmlnL2luY2x1ZGUvbGludXgvc29ueXBpLmgg
bGludXgtMi42LjIxLXJjNy5tb2QvaW5jbHVkZS9saW51eC9zb255cGkuaAot
LS0gbGludXgtMi42LjIxLXJjNy5vcmlnL2luY2x1ZGUvbGludXgvc29ueXBp
LmgJMjAwNy0wMi0wNCAxMzo0NDo1NC4wMDAwMDAwMDAgLTA1MDAKKysrIGxp
bnV4LTIuNi4yMS1yYzcubW9kL2luY2x1ZGUvbGludXgvc29ueXBpLmgJMjAw
Ny0wNC0xNyAxMzozODoyOS4wMDAwMDAwMDAgLTA0MDAKQEAgLTUsNyArNSw3
IEBACiAgKgogICogQ29weXJpZ2h0IChDKSAyMDA1IE5hcmF5YW5hbiBSIFMg
PG5hcnNAa2FkYW1iYS5vcmc+CiAKLSAqIENvcHlyaWdodCAoQykgMjAwMS0y
MDAyIEFsY/R2ZSA8d3d3LmFsY292ZS5jb20+CisgKiBDb3B5cmlnaHQgKEMp
IDIwMDEtMjAwMiBBbGPDtHZlIDx3d3cuYWxjb3ZlLmNvbT4KICAqCiAgKiBD
b3B5cmlnaHQgKEMpIDIwMDEgTWljaGFlbCBBc2hsZXkgPG0uYXNobGV5QHVu
c3cuZWR1LmF1PgogICoKZGlmZiAtdXByTiBsaW51eC0yLjYuMjEtcmM3Lm9y
aWcvaW5jbHVkZS9uZXQvaXJkYS9hZl9pcmRhLmggbGludXgtMi42LjIxLXJj
Ny5tb2QvaW5jbHVkZS9uZXQvaXJkYS9hZl9pcmRhLmgKLS0tIGxpbnV4LTIu
Ni4yMS1yYzcub3JpZy9pbmNsdWRlL25ldC9pcmRhL2FmX2lyZGEuaAkyMDA3
LTAyLTA0IDEzOjQ0OjU0LjAwMDAwMDAwMCAtMDUwMAorKysgbGludXgtMi42
LjIxLXJjNy5tb2QvaW5jbHVkZS9uZXQvaXJkYS9hZl9pcmRhLmgJMjAwNy0w
NC0xNyAxMzozODoyOS4wMDAwMDAwMDAgLTA0MDAKQEAgLTE3LDcgKzE3LDcg
QEAKICAqICAgICBwdWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUgRm91
bmRhdGlvbjsgZWl0aGVyIHZlcnNpb24gMiBvZiAKICAqICAgICB0aGUgTGlj
ZW5zZSwgb3IgKGF0IHlvdXIgb3B0aW9uKSBhbnkgbGF0ZXIgdmVyc2lvbi4K
ICAqICAKLSAqICAgICBOZWl0aGVyIERhZyBCcmF0dGxpIG5vciBVbml2ZXJz
aXR5IG9mIFRyb21z+CBhZG1pdCBsaWFiaWxpdHkgbm9yCisgKiAgICAgTmVp
dGhlciBEYWcgQnJhdHRsaSBub3IgVW5pdmVyc2l0eSBvZiBUcm9tc8O4IGFk
bWl0IGxpYWJpbGl0eSBub3IKICAqICAgICBwcm92aWRlIHdhcnJhbnR5IGZv
ciBhbnkgb2YgdGhpcyBzb2Z0d2FyZS4gVGhpcyBtYXRlcmlhbCBpcyAKICAq
ICAgICBwcm92aWRlZCAiQVMtSVMiIGFuZCBhdCBubyBjaGFyZ2UuCiAgKiAg
ICAgCmRpZmYgLXVwck4gbGludXgtMi42LjIxLXJjNy5vcmlnL2luY2x1ZGUv
bmV0L2lyZGEvaXJkYS5oIGxpbnV4LTIuNi4yMS1yYzcubW9kL2luY2x1ZGUv
bmV0L2lyZGEvaXJkYS5oCi0tLSBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvaW5j
bHVkZS9uZXQvaXJkYS9pcmRhLmgJMjAwNy0wNC0xNyAxMTo0MjoxMy4wMDAw
MDAwMDAgLTA0MDAKKysrIGxpbnV4LTIuNi4yMS1yYzcubW9kL2luY2x1ZGUv
bmV0L2lyZGEvaXJkYS5oCTIwMDctMDQtMTcgMTM6Mzg6MjkuMDAwMDAwMDAw
IC0wNDAwCkBAIC0xNyw3ICsxNyw3IEBACiAgKiAgICAgcHVibGlzaGVkIGJ5
IHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb247IGVpdGhlciB2ZXJzaW9u
IDIgb2YgCiAgKiAgICAgdGhlIExpY2Vuc2UsIG9yIChhdCB5b3VyIG9wdGlv
bikgYW55IGxhdGVyIHZlcnNpb24uCiAgKiAgCi0gKiAgICAgTmVpdGhlciBE
YWcgQnJhdHRsaSBub3IgVW5pdmVyc2l0eSBvZiBUcm9tc/ggYWRtaXQgbGlh
YmlsaXR5IG5vcgorICogICAgIE5laXRoZXIgRGFnIEJyYXR0bGkgbm9yIFVu
aXZlcnNpdHkgb2YgVHJvbXPDuCBhZG1pdCBsaWFiaWxpdHkgbm9yCiAgKiAg
ICAgcHJvdmlkZSB3YXJyYW50eSBmb3IgYW55IG9mIHRoaXMgc29mdHdhcmUu
IFRoaXMgbWF0ZXJpYWwgaXMgCiAgKiAgICAgcHJvdmlkZWQgIkFTLUlTIiBh
bmQgYXQgbm8gY2hhcmdlLgogICogICAgIApkaWZmIC11cHJOIGxpbnV4LTIu
Ni4yMS1yYzcub3JpZy9pbmNsdWRlL25ldC9pcmRhL2lyaWFwX2V2ZW50Lmgg
bGludXgtMi42LjIxLXJjNy5tb2QvaW5jbHVkZS9uZXQvaXJkYS9pcmlhcF9l
dmVudC5oCi0tLSBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvaW5jbHVkZS9uZXQv
aXJkYS9pcmlhcF9ldmVudC5oCTIwMDctMDItMDQgMTM6NDQ6NTQuMDAwMDAw
MDAwIC0wNTAwCisrKyBsaW51eC0yLjYuMjEtcmM3Lm1vZC9pbmNsdWRlL25l
dC9pcmRhL2lyaWFwX2V2ZW50LmgJMjAwNy0wNC0xNyAxMzozODoyOS4wMDAw
MDAwMDAgLTA0MDAKQEAgLTE2LDcgKzE2LDcgQEAKICAqICAgICBwdWJsaXNo
ZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbjsgZWl0aGVyIHZl
cnNpb24gMiBvZiAKICAqICAgICB0aGUgTGljZW5zZSwgb3IgKGF0IHlvdXIg
b3B0aW9uKSBhbnkgbGF0ZXIgdmVyc2lvbi4KICAqCi0gKiAgICAgTmVpdGhl
ciBEYWcgQnJhdHRsaSBub3IgVW5pdmVyc2l0eSBvZiBUcm9tc/ggYWRtaXQg
bGlhYmlsaXR5IG5vcgorICogICAgIE5laXRoZXIgRGFnIEJyYXR0bGkgbm9y
IFVuaXZlcnNpdHkgb2YgVHJvbXPDuCBhZG1pdCBsaWFiaWxpdHkgbm9yCiAg
KiAgICAgcHJvdmlkZSB3YXJyYW50eSBmb3IgYW55IG9mIHRoaXMgc29mdHdh
cmUuIFRoaXMgbWF0ZXJpYWwgaXMgCiAgKiAgICAgcHJvdmlkZWQgIkFTLUlT
IiBhbmQgYXQgbm8gY2hhcmdlLgogICoKZGlmZiAtdXByTiBsaW51eC0yLjYu
MjEtcmM3Lm9yaWcvaW5jbHVkZS9uZXQvaXJkYS9pcmlhcC5oIGxpbnV4LTIu
Ni4yMS1yYzcubW9kL2luY2x1ZGUvbmV0L2lyZGEvaXJpYXAuaAotLS0gbGlu
dXgtMi42LjIxLXJjNy5vcmlnL2luY2x1ZGUvbmV0L2lyZGEvaXJpYXAuaAky
MDA3LTAyLTA0IDEzOjQ0OjU0LjAwMDAwMDAwMCAtMDUwMAorKysgbGludXgt
Mi42LjIxLXJjNy5tb2QvaW5jbHVkZS9uZXQvaXJkYS9pcmlhcC5oCTIwMDct
MDQtMTcgMTM6Mzg6MjkuMDAwMDAwMDAwIC0wNDAwCkBAIC0xNyw3ICsxNyw3
IEBACiAgKiAgICAgcHVibGlzaGVkIGJ5IHRoZSBGcmVlIFNvZnR3YXJlIEZv
dW5kYXRpb247IGVpdGhlciB2ZXJzaW9uIDIgb2YgCiAgKiAgICAgdGhlIExp
Y2Vuc2UsIG9yIChhdCB5b3VyIG9wdGlvbikgYW55IGxhdGVyIHZlcnNpb24u
CiAgKgotICogICAgIE5laXRoZXIgRGFnIEJyYXR0bGkgbm9yIFVuaXZlcnNp
dHkgb2YgVHJvbXP4IGFkbWl0IGxpYWJpbGl0eSBub3IKKyAqICAgICBOZWl0
aGVyIERhZyBCcmF0dGxpIG5vciBVbml2ZXJzaXR5IG9mIFRyb21zw7ggYWRt
aXQgbGlhYmlsaXR5IG5vcgogICogICAgIHByb3ZpZGUgd2FycmFudHkgZm9y
IGFueSBvZiB0aGlzIHNvZnR3YXJlLiBUaGlzIG1hdGVyaWFsIGlzIAogICog
ICAgIHByb3ZpZGVkICJBUy1JUyIgYW5kIGF0IG5vIGNoYXJnZS4KICAqCmRp
ZmYgLXVwck4gbGludXgtMi42LjIxLXJjNy5vcmlnL2luY2x1ZGUvbmV0L2ly
ZGEvaXJpYXNfb2JqZWN0LmggbGludXgtMi42LjIxLXJjNy5tb2QvaW5jbHVk
ZS9uZXQvaXJkYS9pcmlhc19vYmplY3QuaAotLS0gbGludXgtMi42LjIxLXJj
Ny5vcmlnL2luY2x1ZGUvbmV0L2lyZGEvaXJpYXNfb2JqZWN0LmgJMjAwNy0w
Mi0wNCAxMzo0NDo1NC4wMDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4LTIuNi4y
MS1yYzcubW9kL2luY2x1ZGUvbmV0L2lyZGEvaXJpYXNfb2JqZWN0LmgJMjAw
Ny0wNC0xNyAxMzozODoyOS4wMDAwMDAwMDAgLTA0MDAKQEAgLTE2LDcgKzE2
LDcgQEAKICAqICAgICBwdWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUg
Rm91bmRhdGlvbjsgZWl0aGVyIHZlcnNpb24gMiBvZiAKICAqICAgICB0aGUg
TGljZW5zZSwgb3IgKGF0IHlvdXIgb3B0aW9uKSBhbnkgbGF0ZXIgdmVyc2lv
bi4KICAqICAKLSAqICAgICBOZWl0aGVyIERhZyBCcmF0dGxpIG5vciBVbml2
ZXJzaXR5IG9mIFRyb21z+CBhZG1pdCBsaWFiaWxpdHkgbm9yCisgKiAgICAg
TmVpdGhlciBEYWcgQnJhdHRsaSBub3IgVW5pdmVyc2l0eSBvZiBUcm9tc8O4
IGFkbWl0IGxpYWJpbGl0eSBub3IKICAqICAgICBwcm92aWRlIHdhcnJhbnR5
IGZvciBhbnkgb2YgdGhpcyBzb2Z0d2FyZS4gVGhpcyBtYXRlcmlhbCBpcyAK
ICAqICAgICBwcm92aWRlZCAiQVMtSVMiIGFuZCBhdCBubyBjaGFyZ2UuCiAg
KiAgICAgCmRpZmYgLXVwck4gbGludXgtMi42LjIxLXJjNy5vcmlnL2luY2x1
ZGUvbmV0L2lyZGEvaXJsYW5fY2xpZW50LmggbGludXgtMi42LjIxLXJjNy5t
b2QvaW5jbHVkZS9uZXQvaXJkYS9pcmxhbl9jbGllbnQuaAotLS0gbGludXgt
Mi42LjIxLXJjNy5vcmlnL2luY2x1ZGUvbmV0L2lyZGEvaXJsYW5fY2xpZW50
LmgJMjAwNy0wMi0wNCAxMzo0NDo1NC4wMDAwMDAwMDAgLTA1MDAKKysrIGxp
bnV4LTIuNi4yMS1yYzcubW9kL2luY2x1ZGUvbmV0L2lyZGEvaXJsYW5fY2xp
ZW50LmgJMjAwNy0wNC0xNyAxMzozODoyOS4wMDAwMDAwMDAgLTA0MDAKQEAg
LTE2LDcgKzE2LDcgQEAKICAqICAgICBwdWJsaXNoZWQgYnkgdGhlIEZyZWUg
U29mdHdhcmUgRm91bmRhdGlvbjsgZWl0aGVyIHZlcnNpb24gMiBvZiAKICAq
ICAgICB0aGUgTGljZW5zZSwgb3IgKGF0IHlvdXIgb3B0aW9uKSBhbnkgbGF0
ZXIgdmVyc2lvbi4KICAqCi0gKiAgICAgTmVpdGhlciBEYWcgQnJhdHRsaSBu
b3IgVW5pdmVyc2l0eSBvZiBUcm9tc/ggYWRtaXQgbGlhYmlsaXR5IG5vcgor
ICogICAgIE5laXRoZXIgRGFnIEJyYXR0bGkgbm9yIFVuaXZlcnNpdHkgb2Yg
VHJvbXPDuCBhZG1pdCBsaWFiaWxpdHkgbm9yCiAgKiAgICAgcHJvdmlkZSB3
YXJyYW50eSBmb3IgYW55IG9mIHRoaXMgc29mdHdhcmUuIFRoaXMgbWF0ZXJp
YWwgaXMgCiAgKiAgICAgcHJvdmlkZWQgIkFTLUlTIiBhbmQgYXQgbm8gY2hh
cmdlLgogICoKZGlmZiAtdXByTiBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvaW5j
bHVkZS9uZXQvaXJkYS9pcmxhbl9jb21tb24uaCBsaW51eC0yLjYuMjEtcmM3
Lm1vZC9pbmNsdWRlL25ldC9pcmRhL2lybGFuX2NvbW1vbi5oCi0tLSBsaW51
eC0yLjYuMjEtcmM3Lm9yaWcvaW5jbHVkZS9uZXQvaXJkYS9pcmxhbl9jb21t
b24uaAkyMDA3LTAyLTA0IDEzOjQ0OjU0LjAwMDAwMDAwMCAtMDUwMAorKysg
bGludXgtMi42LjIxLXJjNy5tb2QvaW5jbHVkZS9uZXQvaXJkYS9pcmxhbl9j
b21tb24uaAkyMDA3LTA0LTE3IDEzOjM4OjI5LjAwMDAwMDAwMCAtMDQwMApA
QCAtMTcsNyArMTcsNyBAQAogICogICAgIHB1Ymxpc2hlZCBieSB0aGUgRnJl
ZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbiAyIG9mIAog
ICogICAgIHRoZSBMaWNlbnNlLCBvciAoYXQgeW91ciBvcHRpb24pIGFueSBs
YXRlciB2ZXJzaW9uLgogICoKLSAqICAgICBOZWl0aGVyIERhZyBCcmF0dGxp
IG5vciBVbml2ZXJzaXR5IG9mIFRyb21z+CBhZG1pdCBsaWFiaWxpdHkgbm9y
CisgKiAgICAgTmVpdGhlciBEYWcgQnJhdHRsaSBub3IgVW5pdmVyc2l0eSBv
ZiBUcm9tc8O4IGFkbWl0IGxpYWJpbGl0eSBub3IKICAqICAgICBwcm92aWRl
IHdhcnJhbnR5IGZvciBhbnkgb2YgdGhpcyBzb2Z0d2FyZS4gVGhpcyBtYXRl
cmlhbCBpcyAKICAqICAgICBwcm92aWRlZCAiQVMtSVMiIGFuZCBhdCBubyBj
aGFyZ2UuCiAgKgpkaWZmIC11cHJOIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9p
bmNsdWRlL25ldC9pcmRhL2lybGFuX2V0aC5oIGxpbnV4LTIuNi4yMS1yYzcu
bW9kL2luY2x1ZGUvbmV0L2lyZGEvaXJsYW5fZXRoLmgKLS0tIGxpbnV4LTIu
Ni4yMS1yYzcub3JpZy9pbmNsdWRlL25ldC9pcmRhL2lybGFuX2V0aC5oCTIw
MDctMDItMDQgMTM6NDQ6NTQuMDAwMDAwMDAwIC0wNTAwCisrKyBsaW51eC0y
LjYuMjEtcmM3Lm1vZC9pbmNsdWRlL25ldC9pcmRhL2lybGFuX2V0aC5oCTIw
MDctMDQtMTcgMTM6Mzg6MjkuMDAwMDAwMDAwIC0wNDAwCkBAIC0xNiw3ICsx
Niw3IEBACiAgKiAgICAgcHVibGlzaGVkIGJ5IHRoZSBGcmVlIFNvZnR3YXJl
IEZvdW5kYXRpb247IGVpdGhlciB2ZXJzaW9uIDIgb2YgCiAgKiAgICAgdGhl
IExpY2Vuc2UsIG9yIChhdCB5b3VyIG9wdGlvbikgYW55IGxhdGVyIHZlcnNp
b24uCiAgKiAgCi0gKiAgICAgTmVpdGhlciBEYWcgQnJhdHRsaSBub3IgVW5p
dmVyc2l0eSBvZiBUcm9tc/ggYWRtaXQgbGlhYmlsaXR5IG5vcgorICogICAg
IE5laXRoZXIgRGFnIEJyYXR0bGkgbm9yIFVuaXZlcnNpdHkgb2YgVHJvbXPD
uCBhZG1pdCBsaWFiaWxpdHkgbm9yCiAgKiAgICAgcHJvdmlkZSB3YXJyYW50
eSBmb3IgYW55IG9mIHRoaXMgc29mdHdhcmUuIFRoaXMgbWF0ZXJpYWwgaXMg
CiAgKiAgICAgcHJvdmlkZWQgIkFTLUlTIiBhbmQgYXQgbm8gY2hhcmdlLgog
ICogICAgIApkaWZmIC11cHJOIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9pbmNs
dWRlL25ldC9pcmRhL2lybGFuX2V2ZW50LmggbGludXgtMi42LjIxLXJjNy5t
b2QvaW5jbHVkZS9uZXQvaXJkYS9pcmxhbl9ldmVudC5oCi0tLSBsaW51eC0y
LjYuMjEtcmM3Lm9yaWcvaW5jbHVkZS9uZXQvaXJkYS9pcmxhbl9ldmVudC5o
CTIwMDctMDItMDQgMTM6NDQ6NTQuMDAwMDAwMDAwIC0wNTAwCisrKyBsaW51
eC0yLjYuMjEtcmM3Lm1vZC9pbmNsdWRlL25ldC9pcmRhL2lybGFuX2V2ZW50
LmgJMjAwNy0wNC0xNyAxMzozODoyOS4wMDAwMDAwMDAgLTA0MDAKQEAgLTE2
LDcgKzE2LDcgQEAKICAqICAgICBwdWJsaXNoZWQgYnkgdGhlIEZyZWUgU29m
dHdhcmUgRm91bmRhdGlvbjsgZWl0aGVyIHZlcnNpb24gMiBvZiAKICAqICAg
ICB0aGUgTGljZW5zZSwgb3IgKGF0IHlvdXIgb3B0aW9uKSBhbnkgbGF0ZXIg
dmVyc2lvbi4KICAqCi0gKiAgICAgTmVpdGhlciBEYWcgQnJhdHRsaSBub3Ig
VW5pdmVyc2l0eSBvZiBUcm9tc/ggYWRtaXQgbGlhYmlsaXR5IG5vcgorICog
ICAgIE5laXRoZXIgRGFnIEJyYXR0bGkgbm9yIFVuaXZlcnNpdHkgb2YgVHJv
bXPDuCBhZG1pdCBsaWFiaWxpdHkgbm9yCiAgKiAgICAgcHJvdmlkZSB3YXJy
YW50eSBmb3IgYW55IG9mIHRoaXMgc29mdHdhcmUuIFRoaXMgbWF0ZXJpYWwg
aXMgCiAgKiAgICAgcHJvdmlkZWQgIkFTLUlTIiBhbmQgYXQgbm8gY2hhcmdl
LgogICoKZGlmZiAtdXByTiBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvaW5jbHVk
ZS9uZXQvaXJkYS9pcmxhbl9maWx0ZXIuaCBsaW51eC0yLjYuMjEtcmM3Lm1v
ZC9pbmNsdWRlL25ldC9pcmRhL2lybGFuX2ZpbHRlci5oCi0tLSBsaW51eC0y
LjYuMjEtcmM3Lm9yaWcvaW5jbHVkZS9uZXQvaXJkYS9pcmxhbl9maWx0ZXIu
aAkyMDA3LTAyLTA0IDEzOjQ0OjU0LjAwMDAwMDAwMCAtMDUwMAorKysgbGlu
dXgtMi42LjIxLXJjNy5tb2QvaW5jbHVkZS9uZXQvaXJkYS9pcmxhbl9maWx0
ZXIuaAkyMDA3LTA0LTE3IDEzOjM4OjI5LjAwMDAwMDAwMCAtMDQwMApAQCAt
MTYsNyArMTYsNyBAQAogICogICAgIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBT
b2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbiAyIG9mIAogICog
ICAgIHRoZSBMaWNlbnNlLCBvciAoYXQgeW91ciBvcHRpb24pIGFueSBsYXRl
ciB2ZXJzaW9uLgogICogIAotICogICAgIE5laXRoZXIgRGFnIEJyYXR0bGkg
bm9yIFVuaXZlcnNpdHkgb2YgVHJvbXP4IGFkbWl0IGxpYWJpbGl0eSBub3IK
KyAqICAgICBOZWl0aGVyIERhZyBCcmF0dGxpIG5vciBVbml2ZXJzaXR5IG9m
IFRyb21zw7ggYWRtaXQgbGlhYmlsaXR5IG5vcgogICogICAgIHByb3ZpZGUg
d2FycmFudHkgZm9yIGFueSBvZiB0aGlzIHNvZnR3YXJlLiBUaGlzIG1hdGVy
aWFsIGlzIAogICogICAgIHByb3ZpZGVkICJBUy1JUyIgYW5kIGF0IG5vIGNo
YXJnZS4KICAqICAgICAKZGlmZiAtdXByTiBsaW51eC0yLjYuMjEtcmM3Lm9y
aWcvaW5jbHVkZS9uZXQvaXJkYS9pcmxhbl9wcm92aWRlci5oIGxpbnV4LTIu
Ni4yMS1yYzcubW9kL2luY2x1ZGUvbmV0L2lyZGEvaXJsYW5fcHJvdmlkZXIu
aAotLS0gbGludXgtMi42LjIxLXJjNy5vcmlnL2luY2x1ZGUvbmV0L2lyZGEv
aXJsYW5fcHJvdmlkZXIuaAkyMDA3LTAyLTA0IDEzOjQ0OjU0LjAwMDAwMDAw
MCAtMDUwMAorKysgbGludXgtMi42LjIxLXJjNy5tb2QvaW5jbHVkZS9uZXQv
aXJkYS9pcmxhbl9wcm92aWRlci5oCTIwMDctMDQtMTcgMTM6Mzg6MjkuMDAw
MDAwMDAwIC0wNDAwCkBAIC0xNiw3ICsxNiw3IEBACiAgKiAgICAgcHVibGlz
aGVkIGJ5IHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb247IGVpdGhlciB2
ZXJzaW9uIDIgb2YgCiAgKiAgICAgdGhlIExpY2Vuc2UsIG9yIChhdCB5b3Vy
IG9wdGlvbikgYW55IGxhdGVyIHZlcnNpb24uCiAgKgotICogICAgIE5laXRo
ZXIgRGFnIEJyYXR0bGkgbm9yIFVuaXZlcnNpdHkgb2YgVHJvbXP4IGFkbWl0
IGxpYWJpbGl0eSBub3IKKyAqICAgICBOZWl0aGVyIERhZyBCcmF0dGxpIG5v
ciBVbml2ZXJzaXR5IG9mIFRyb21zw7ggYWRtaXQgbGlhYmlsaXR5IG5vcgog
ICogICAgIHByb3ZpZGUgd2FycmFudHkgZm9yIGFueSBvZiB0aGlzIHNvZnR3
YXJlLiBUaGlzIG1hdGVyaWFsIGlzIAogICogICAgIHByb3ZpZGVkICJBUy1J
UyIgYW5kIGF0IG5vIGNoYXJnZS4KICAqCmRpZmYgLXVwck4gbGludXgtMi42
LjIxLXJjNy5vcmlnL2luY2x1ZGUvbmV0L2lyZGEvaXJsYXAuaCBsaW51eC0y
LjYuMjEtcmM3Lm1vZC9pbmNsdWRlL25ldC9pcmRhL2lybGFwLmgKLS0tIGxp
bnV4LTIuNi4yMS1yYzcub3JpZy9pbmNsdWRlL25ldC9pcmRhL2lybGFwLmgJ
MjAwNy0wMi0wNCAxMzo0NDo1NC4wMDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4
LTIuNi4yMS1yYzcubW9kL2luY2x1ZGUvbmV0L2lyZGEvaXJsYXAuaAkyMDA3
LTA0LTE3IDEzOjM4OjI5LjAwMDAwMDAwMCAtMDQwMApAQCAtMTgsNyArMTgs
NyBAQAogICogICAgIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBG
b3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbiAyIG9mIAogICogICAgIHRoZSBM
aWNlbnNlLCBvciAoYXQgeW91ciBvcHRpb24pIGFueSBsYXRlciB2ZXJzaW9u
LgogICoKLSAqICAgICBOZWl0aGVyIERhZyBCcmF0dGxpIG5vciBVbml2ZXJz
aXR5IG9mIFRyb21z+CBhZG1pdCBsaWFiaWxpdHkgbm9yCisgKiAgICAgTmVp
dGhlciBEYWcgQnJhdHRsaSBub3IgVW5pdmVyc2l0eSBvZiBUcm9tc8O4IGFk
bWl0IGxpYWJpbGl0eSBub3IKICAqICAgICBwcm92aWRlIHdhcnJhbnR5IGZv
ciBhbnkgb2YgdGhpcyBzb2Z0d2FyZS4gVGhpcyBtYXRlcmlhbCBpcyAKICAq
ICAgICBwcm92aWRlZCAiQVMtSVMiIGFuZCBhdCBubyBjaGFyZ2UuCiAgKgpk
aWZmIC11cHJOIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9pbmNsdWRlL25ldC9p
cmRhL2lybG1wX2V2ZW50LmggbGludXgtMi42LjIxLXJjNy5tb2QvaW5jbHVk
ZS9uZXQvaXJkYS9pcmxtcF9ldmVudC5oCi0tLSBsaW51eC0yLjYuMjEtcmM3
Lm9yaWcvaW5jbHVkZS9uZXQvaXJkYS9pcmxtcF9ldmVudC5oCTIwMDctMDIt
MDQgMTM6NDQ6NTQuMDAwMDAwMDAwIC0wNTAwCisrKyBsaW51eC0yLjYuMjEt
cmM3Lm1vZC9pbmNsdWRlL25ldC9pcmRhL2lybG1wX2V2ZW50LmgJMjAwNy0w
NC0xNyAxMzozODoyOS4wMDAwMDAwMDAgLTA0MDAKQEAgLTE4LDcgKzE4LDcg
QEAKICAqICAgICBwdWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUgRm91
bmRhdGlvbjsgZWl0aGVyIHZlcnNpb24gMiBvZiAKICAqICAgICB0aGUgTGlj
ZW5zZSwgb3IgKGF0IHlvdXIgb3B0aW9uKSBhbnkgbGF0ZXIgdmVyc2lvbi4K
ICAqCi0gKiAgICAgTmVpdGhlciBEYWcgQnJhdHRsaSBub3IgVW5pdmVyc2l0
eSBvZiBUcm9tc/ggYWRtaXQgbGlhYmlsaXR5IG5vcgorICogICAgIE5laXRo
ZXIgRGFnIEJyYXR0bGkgbm9yIFVuaXZlcnNpdHkgb2YgVHJvbXPDuCBhZG1p
dCBsaWFiaWxpdHkgbm9yCiAgKiAgICAgcHJvdmlkZSB3YXJyYW50eSBmb3Ig
YW55IG9mIHRoaXMgc29mdHdhcmUuIFRoaXMgbWF0ZXJpYWwgaXMgCiAgKiAg
ICAgcHJvdmlkZWQgIkFTLUlTIiBhbmQgYXQgbm8gY2hhcmdlLgogICoKZGlm
ZiAtdXByTiBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvaW5jbHVkZS9uZXQvaXJk
YS9pcmxtcF9mcmFtZS5oIGxpbnV4LTIuNi4yMS1yYzcubW9kL2luY2x1ZGUv
bmV0L2lyZGEvaXJsbXBfZnJhbWUuaAotLS0gbGludXgtMi42LjIxLXJjNy5v
cmlnL2luY2x1ZGUvbmV0L2lyZGEvaXJsbXBfZnJhbWUuaAkyMDA3LTAyLTA0
IDEzOjQ0OjU0LjAwMDAwMDAwMCAtMDUwMAorKysgbGludXgtMi42LjIxLXJj
Ny5tb2QvaW5jbHVkZS9uZXQvaXJkYS9pcmxtcF9mcmFtZS5oCTIwMDctMDQt
MTcgMTM6Mzg6MjkuMDAwMDAwMDAwIC0wNDAwCkBAIC0xNyw3ICsxNyw3IEBA
CiAgKiAgICAgcHVibGlzaGVkIGJ5IHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5k
YXRpb247IGVpdGhlciB2ZXJzaW9uIDIgb2YgCiAgKiAgICAgdGhlIExpY2Vu
c2UsIG9yIChhdCB5b3VyIG9wdGlvbikgYW55IGxhdGVyIHZlcnNpb24uCiAg
KgotICogICAgIE5laXRoZXIgRGFnIEJyYXR0bGkgbm9yIFVuaXZlcnNpdHkg
b2YgVHJvbXP4IGFkbWl0IGxpYWJpbGl0eSBub3IKKyAqICAgICBOZWl0aGVy
IERhZyBCcmF0dGxpIG5vciBVbml2ZXJzaXR5IG9mIFRyb21zw7ggYWRtaXQg
bGlhYmlsaXR5IG5vcgogICogICAgIHByb3ZpZGUgd2FycmFudHkgZm9yIGFu
eSBvZiB0aGlzIHNvZnR3YXJlLiBUaGlzIG1hdGVyaWFsIGlzIAogICogICAg
IHByb3ZpZGVkICJBUy1JUyIgYW5kIGF0IG5vIGNoYXJnZS4KICAqCmRpZmYg
LXVwck4gbGludXgtMi42LjIxLXJjNy5vcmlnL2luY2x1ZGUvbmV0L2lyZGEv
aXJsbXAuaCBsaW51eC0yLjYuMjEtcmM3Lm1vZC9pbmNsdWRlL25ldC9pcmRh
L2lybG1wLmgKLS0tIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9pbmNsdWRlL25l
dC9pcmRhL2lybG1wLmgJMjAwNy0wMi0wNCAxMzo0NDo1NC4wMDAwMDAwMDAg
LTA1MDAKKysrIGxpbnV4LTIuNi4yMS1yYzcubW9kL2luY2x1ZGUvbmV0L2ly
ZGEvaXJsbXAuaAkyMDA3LTA0LTE3IDEzOjM4OjI5LjAwMDAwMDAwMCAtMDQw
MApAQCAtMTgsNyArMTgsNyBAQAogICogICAgIHB1Ymxpc2hlZCBieSB0aGUg
RnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbiAyIG9m
IAogICogICAgIHRoZSBMaWNlbnNlLCBvciAoYXQgeW91ciBvcHRpb24pIGFu
eSBsYXRlciB2ZXJzaW9uLgogICoKLSAqICAgICBOZWl0aGVyIERhZyBCcmF0
dGxpIG5vciBVbml2ZXJzaXR5IG9mIFRyb21z+CBhZG1pdCBsaWFiaWxpdHkg
bm9yCisgKiAgICAgTmVpdGhlciBEYWcgQnJhdHRsaSBub3IgVW5pdmVyc2l0
eSBvZiBUcm9tc8O4IGFkbWl0IGxpYWJpbGl0eSBub3IKICAqICAgICBwcm92
aWRlIHdhcnJhbnR5IGZvciBhbnkgb2YgdGhpcyBzb2Z0d2FyZS4gVGhpcyBt
YXRlcmlhbCBpcyAKICAqICAgICBwcm92aWRlZCAiQVMtSVMiIGFuZCBhdCBu
byBjaGFyZ2UuCiAgKgpkaWZmIC11cHJOIGxpbnV4LTIuNi4yMS1yYzcub3Jp
Zy9pbmNsdWRlL25ldC9pcmRhL2lybW9kLmggbGludXgtMi42LjIxLXJjNy5t
b2QvaW5jbHVkZS9uZXQvaXJkYS9pcm1vZC5oCi0tLSBsaW51eC0yLjYuMjEt
cmM3Lm9yaWcvaW5jbHVkZS9uZXQvaXJkYS9pcm1vZC5oCTIwMDctMDItMDQg
MTM6NDQ6NTQuMDAwMDAwMDAwIC0wNTAwCisrKyBsaW51eC0yLjYuMjEtcmM3
Lm1vZC9pbmNsdWRlL25ldC9pcmRhL2lybW9kLmgJMjAwNy0wNC0xNyAxMzoz
ODoyOS4wMDAwMDAwMDAgLTA0MDAKQEAgLTE3LDcgKzE3LDcgQEAKICAqICAg
ICBwdWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbjsg
ZWl0aGVyIHZlcnNpb24gMiBvZiAKICAqICAgICB0aGUgTGljZW5zZSwgb3Ig
KGF0IHlvdXIgb3B0aW9uKSBhbnkgbGF0ZXIgdmVyc2lvbi4KICAqICAKLSAq
ICAgICBOZWl0aGVyIERhZyBCcmF0dGxpIG5vciBVbml2ZXJzaXR5IG9mIFRy
b21z+CBhZG1pdCBsaWFiaWxpdHkgbm9yCisgKiAgICAgTmVpdGhlciBEYWcg
QnJhdHRsaSBub3IgVW5pdmVyc2l0eSBvZiBUcm9tc8O4IGFkbWl0IGxpYWJp
bGl0eSBub3IKICAqICAgICBwcm92aWRlIHdhcnJhbnR5IGZvciBhbnkgb2Yg
dGhpcyBzb2Z0d2FyZS4gVGhpcyBtYXRlcmlhbCBpcyAKICAqICAgICBwcm92
aWRlZCAiQVMtSVMiIGFuZCBhdCBubyBjaGFyZy4KICAqICAgICAKZGlmZiAt
dXByTiBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvaW5jbHVkZS9uZXQvaXJkYS9p
cnF1ZXVlLmggbGludXgtMi42LjIxLXJjNy5tb2QvaW5jbHVkZS9uZXQvaXJk
YS9pcnF1ZXVlLmgKLS0tIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9pbmNsdWRl
L25ldC9pcmRhL2lycXVldWUuaAkyMDA3LTAyLTA0IDEzOjQ0OjU0LjAwMDAw
MDAwMCAtMDUwMAorKysgbGludXgtMi42LjIxLXJjNy5tb2QvaW5jbHVkZS9u
ZXQvaXJkYS9pcnF1ZXVlLmgJMjAwNy0wNC0xNyAxMzozODoyOS4wMDAwMDAw
MDAgLTA0MDAKQEAgLTIxLDcgKzIxLDcgQEAKICAqICAgICBwdWJsaXNoZWQg
YnkgdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbjsgZWl0aGVyIHZlcnNp
b24gMiBvZiAKICAqICAgICB0aGUgTGljZW5zZSwgb3IgKGF0IHlvdXIgb3B0
aW9uKSBhbnkgbGF0ZXIgdmVyc2lvbi4KICAqICAKLSAqICAgICBOZWl0aGVy
IERhZyBCcmF0dGxpIG5vciBVbml2ZXJzaXR5IG9mIFRyb21z+CBhZG1pdCBs
aWFiaWxpdHkgbm9yCisgKiAgICAgTmVpdGhlciBEYWcgQnJhdHRsaSBub3Ig
VW5pdmVyc2l0eSBvZiBUcm9tc8O4IGFkbWl0IGxpYWJpbGl0eSBub3IKICAq
ICAgICBwcm92aWRlIHdhcnJhbnR5IGZvciBhbnkgb2YgdGhpcyBzb2Z0d2Fy
ZS4gVGhpcyBtYXRlcmlhbCBpcyAKICAqICAgICBwcm92aWRlZCAiQVMtSVMi
IGFuZCBhdCBubyBjaGFyZ2UuCiAgKiAgICAgCmRpZmYgLXVwck4gbGludXgt
Mi42LjIxLXJjNy5vcmlnL2luY2x1ZGUvbmV0L2lyZGEvaXJ0dHAuaCBsaW51
eC0yLjYuMjEtcmM3Lm1vZC9pbmNsdWRlL25ldC9pcmRhL2lydHRwLmgKLS0t
IGxpbnV4LTIuNi4yMS1yYzcub3JpZy9pbmNsdWRlL25ldC9pcmRhL2lydHRw
LmgJMjAwNy0wMi0wNCAxMzo0NDo1NC4wMDAwMDAwMDAgLTA1MDAKKysrIGxp
bnV4LTIuNi4yMS1yYzcubW9kL2luY2x1ZGUvbmV0L2lyZGEvaXJ0dHAuaAky
MDA3LTA0LTE3IDEzOjM4OjI5LjAwMDAwMDAwMCAtMDQwMApAQCAtMTgsNyAr
MTgsNyBAQAogICogICAgIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2Fy
ZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbiAyIG9mIAogICogICAgIHRo
ZSBMaWNlbnNlLCBvciAoYXQgeW91ciBvcHRpb24pIGFueSBsYXRlciB2ZXJz
aW9uLgogICoKLSAqICAgICBOZWl0aGVyIERhZyBCcmF0dGxpIG5vciBVbml2
ZXJzaXR5IG9mIFRyb21z+CBhZG1pdCBsaWFiaWxpdHkgbm9yCisgKiAgICAg
TmVpdGhlciBEYWcgQnJhdHRsaSBub3IgVW5pdmVyc2l0eSBvZiBUcm9tc8O4
IGFkbWl0IGxpYWJpbGl0eSBub3IKICAqICAgICBwcm92aWRlIHdhcnJhbnR5
IGZvciBhbnkgb2YgdGhpcyBzb2Z0d2FyZS4gVGhpcyBtYXRlcmlhbCBpcyAK
ICAqICAgICBwcm92aWRlZCAiQVMtSVMiIGFuZCBhdCBubyBjaGFyZ2UuCiAg
KgpkaWZmIC11cHJOIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9pbmNsdWRlL25l
dC9pcmRhL3BhcmFtZXRlcnMuaCBsaW51eC0yLjYuMjEtcmM3Lm1vZC9pbmNs
dWRlL25ldC9pcmRhL3BhcmFtZXRlcnMuaAotLS0gbGludXgtMi42LjIxLXJj
Ny5vcmlnL2luY2x1ZGUvbmV0L2lyZGEvcGFyYW1ldGVycy5oCTIwMDctMDIt
MDQgMTM6NDQ6NTQuMDAwMDAwMDAwIC0wNTAwCisrKyBsaW51eC0yLjYuMjEt
cmM3Lm1vZC9pbmNsdWRlL25ldC9pcmRhL3BhcmFtZXRlcnMuaAkyMDA3LTA0
LTE3IDEzOjM4OjI5LjAwMDAwMDAwMCAtMDQwMApAQCAtMjYsNyArMjYsNyBA
QAogICogICAgIEZvdW5kYXRpb24sIEluYy4sIDU5IFRlbXBsZSBQbGFjZSwg
U3VpdGUgMzMwLCBCb3N0b24sIAogICogICAgIE1BIDAyMTExLTEzMDcgVVNB
CiAgKgotICogICAgIE1pY2hlbCBE5G56ZXIgPGRhZW56ZXJAZGViaWFuLm9y
Zz4sIDEwLzIwMDEKKyAqICAgICBNaWNoZWwgRMOkbnplciA8ZGFlbnplckBk
ZWJpYW4ub3JnPiwgMTAvMjAwMQogICogICAgIC0gc2ltcGxpZnkgaXJkYV9w
dl90IHRvIGF2b2lkIGVuZGlhbm5lc3MgaXNzdWVzCiAgKiAgICAgCiAgKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKiovCmRpZmYgLXVwck4gbGludXgtMi42LjIx
LXJjNy5vcmlnL2luY2x1ZGUvbmV0L2lyZGEvdGltZXIuaCBsaW51eC0yLjYu
MjEtcmM3Lm1vZC9pbmNsdWRlL25ldC9pcmRhL3RpbWVyLmgKLS0tIGxpbnV4
LTIuNi4yMS1yYzcub3JpZy9pbmNsdWRlL25ldC9pcmRhL3RpbWVyLmgJMjAw
Ny0wMi0wNCAxMzo0NDo1NC4wMDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4LTIu
Ni4yMS1yYzcubW9kL2luY2x1ZGUvbmV0L2lyZGEvdGltZXIuaAkyMDA3LTA0
LTE3IDEzOjM4OjI5LjAwMDAwMDAwMCAtMDQwMApAQCAtMTgsNyArMTgsNyBA
QAogICogICAgIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3Vu
ZGF0aW9uOyBlaXRoZXIgdmVyc2lvbiAyIG9mIAogICogICAgIHRoZSBMaWNl
bnNlLCBvciAoYXQgeW91ciBvcHRpb24pIGFueSBsYXRlciB2ZXJzaW9uLgog
ICoKLSAqICAgICBOZWl0aGVyIERhZyBCcmF0dGxpIG5vciBVbml2ZXJzaXR5
IG9mIFRyb21z+CBhZG1pdCBsaWFiaWxpdHkgbm9yCisgKiAgICAgTmVpdGhl
ciBEYWcgQnJhdHRsaSBub3IgVW5pdmVyc2l0eSBvZiBUcm9tc8O4IGFkbWl0
IGxpYWJpbGl0eSBub3IKICAqICAgICBwcm92aWRlIHdhcnJhbnR5IGZvciBh
bnkgb2YgdGhpcyBzb2Z0d2FyZS4gVGhpcyBtYXRlcmlhbCBpcyAKICAqICAg
ICBwcm92aWRlZCAiQVMtSVMiIGFuZCBhdCBubyBjaGFyZ2UuCiAgKgpkaWZm
IC11cHJOIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9pbmNsdWRlL25ldC9pcmRh
L3dyYXBwZXIuaCBsaW51eC0yLjYuMjEtcmM3Lm1vZC9pbmNsdWRlL25ldC9p
cmRhL3dyYXBwZXIuaAotLS0gbGludXgtMi42LjIxLXJjNy5vcmlnL2luY2x1
ZGUvbmV0L2lyZGEvd3JhcHBlci5oCTIwMDctMDItMDQgMTM6NDQ6NTQuMDAw
MDAwMDAwIC0wNTAwCisrKyBsaW51eC0yLjYuMjEtcmM3Lm1vZC9pbmNsdWRl
L25ldC9pcmRhL3dyYXBwZXIuaAkyMDA3LTA0LTE3IDEzOjM4OjI5LjAwMDAw
MDAwMCAtMDQwMApAQCAtMTcsNyArMTcsNyBAQAogICogICAgIHB1Ymxpc2hl
ZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVy
c2lvbiAyIG9mIAogICogICAgIHRoZSBMaWNlbnNlLCBvciAoYXQgeW91ciBv
cHRpb24pIGFueSBsYXRlciB2ZXJzaW9uLgogICoKLSAqICAgICBOZWl0aGVy
IERhZyBCcmF0dGxpIG5vciBVbml2ZXJzaXR5IG9mIFRyb21z+CBhZG1pdCBs
aWFiaWxpdHkgbm9yCisgKiAgICAgTmVpdGhlciBEYWcgQnJhdHRsaSBub3Ig
VW5pdmVyc2l0eSBvZiBUcm9tc8O4IGFkbWl0IGxpYWJpbGl0eSBub3IKICAq
ICAgICBwcm92aWRlIHdhcnJhbnR5IGZvciBhbnkgb2YgdGhpcyBzb2Z0d2Fy
ZS4gVGhpcyBtYXRlcmlhbCBpcyAKICAqICAgICBwcm92aWRlZCAiQVMtSVMi
IGFuZCBhdCBubyBjaGFyZ2UuCiAgKgo=

--1875672472-926641575-1176832419=:914--
