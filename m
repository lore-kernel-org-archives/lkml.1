Return-Path: <linux-kernel-owner+w=401wt.eu-S934078AbXDDSME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078AbXDDSME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934065AbXDDSL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:11:28 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:38241 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbXDDSLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:11:00 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Komal Shah <komal_shah802003@yahoo.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 50/90] ARM: OMAP: board-sdp2430.c Remove unnecessary #includes
Date: Wed,  4 Apr 2007 14:05:29 -0400
Message-Id: <1175710103340-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757101012787-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!
 it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Komal Shah <komal_shah802003@yahoo.com>

- and fix the file path.

Signed-off-by: Komal Shah <komal_shah802003@yahoo.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/board-2430sdp.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-omap2/board-2430sdp.c b/arch/arm/mach-omap2/board-2430sdp.c
index 77e77c1..7e76fbf 100644
--- a/arch/arm/mach-omap2/board-2430sdp.c
+++ b/arch/arm/mach-omap2/board-2430sdp.c
@@ -1,5 +1,5 @@
 /*
- * linux/arch/arm/mach-omap/omap2/board-2430sdp.c
+ * linux/arch/arm/mach-omap2/board-2430sdp.c
  *
  * Copyright (C) 2006 Texas Instruments
  *
@@ -19,8 +19,6 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/delay.h>
-#include <linux/workqueue.h>
-#include <linux/input.h>
 #include <linux/err.h>
 #include <linux/clk.h>
 
@@ -31,15 +29,9 @@
 #include <asm/mach/flash.h>
 
 #include <asm/arch/gpio.h>
-#include <asm/arch/gpioexpander.h>
 #include <asm/arch/mux.h>
-#include <asm/arch/usb.h>
-#include <asm/arch/irda.h>
 #include <asm/arch/board.h>
 #include <asm/arch/common.h>
-#include <asm/arch/keypad.h>
-#include <asm/arch/menelaus.h>
-#include <asm/arch/dma.h>
 #include <asm/arch/gpmc.h>
 #include "prcm-regs.h"
 
-- 
1.4.4.2

