Return-Path: <linux-kernel-owner+w=401wt.eu-S1761788AbXE1Ihr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761788AbXE1Ihr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760057AbXE1Igh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:36:37 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:7605 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758479AbXE1Igc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:36:32 -0400
X-IronPort-AV: i="4.14,586,1170651600"; 
   d="scan'208"; a="31069462:sNHT23986515"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Simon Arlott <simon@fire.lp0.eu>, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 03/20] Blackfin arch: spelling fixes
Date: Mon, 28 May 2007 16:37:38 +0800
Message-Id: <118034147765-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11803414753217-git-send-email-bryan.wu@analog.com>
References: <11803414753217-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Arlott <simon@fire.lp0.eu>

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/irqchip.c                  |    2 +-
 arch/blackfin/kernel/traps.c                    |    2 +-
 arch/blackfin/mach-bf533/boards/cm_bf533.c      |    2 +-
 arch/blackfin/mach-bf533/boards/ezkit.c         |    2 +-
 arch/blackfin/mach-bf533/ints-priority.c        |    2 +-
 arch/blackfin/mach-bf537/boards/generic_board.c |    2 +-
 arch/blackfin/mach-bf537/boards/pnav10.c        |    2 +-
 arch/blackfin/mach-bf537/boards/stamp.c         |    2 +-
 arch/blackfin/mach-bf537/ints-priority.c        |    2 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c      |    4 ++--
 arch/blackfin/mach-bf561/ints-priority.c        |    2 +-
 arch/blackfin/mach-common/ints-priority-dc.c    |    2 +-
 arch/blackfin/mach-common/ints-priority-sc.c    |    2 +-
 arch/blackfin/mm/blackfin_sram.c                |    6 +++---
 14 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/blackfin/kernel/irqchip.c b/arch/blackfin/kernel/irqchip.c
index df5bf02..80996a1 100644
--- a/arch/blackfin/kernel/irqchip.c
+++ b/arch/blackfin/kernel/irqchip.c
@@ -91,7 +91,7 @@ int show_interrupts(struct seq_file *p, void *v)
 }
 
 /*
- * do_IRQ handles all hardware IRQ's.  Decoded IRQs should not
+ * do_IRQ handles all hardware IRQs.  Decoded IRQs should not
  * come via this function.  Instead, they should provide their
  * own 'handler'
  */
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 9932ede..5ab87b0 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -557,7 +557,7 @@ void dump_bfin_regs(struct pt_regs *fp, void *retaddr)
 				break;
 #ifndef CONFIG_DEBUG_HWERR
 			/* If one of the last few instructions was a STI
-			 * it is likily that the error occured awhile ago
+			 * it is likely that the error occured awhile ago
 			 * and we just noticed
 			 */
 			if (x >= 0x0040 && x <= 0x0047 && i <= 0)
diff --git a/arch/blackfin/mach-bf533/boards/cm_bf533.c b/arch/blackfin/mach-bf533/boards/cm_bf533.c
index 23a7f60..edd31ce 100644
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c
+++ b/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -1,7 +1,7 @@
 /*
  * File:         arch/blackfin/mach-bf533/boards/cm_bf533.c
  * Based on:     arch/blackfin/mach-bf533/boards/ezkit.c
- * Author:       Aidan Williams <aidan@nicta.com.au> Copright 2005
+ * Author:       Aidan Williams <aidan@nicta.com.au> Copyright 2005
  *
  * Created:      2005
  * Description:  Board description file
diff --git a/arch/blackfin/mach-bf533/boards/ezkit.c b/arch/blackfin/mach-bf533/boards/ezkit.c
index 747298e..0b522d9 100644
--- a/arch/blackfin/mach-bf533/boards/ezkit.c
+++ b/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -1,6 +1,6 @@
 /*
  * File:         arch/blackfin/mach-bf533/ezkit.c
- * Based on:     Orginal Work
+ * Based on:     Original Work
  * Author:       Aidan Williams <aidan@nicta.com.au>
  *
  * Created:      2005
diff --git a/arch/blackfin/mach-bf533/ints-priority.c b/arch/blackfin/mach-bf533/ints-priority.c
index 36a6933..a3e1789 100644
--- a/arch/blackfin/mach-bf533/ints-priority.c
+++ b/arch/blackfin/mach-bf533/ints-priority.c
@@ -4,7 +4,7 @@
  * Author:       Michael Hennerich
  *
  * Created:      ?
- * Description:  Set up the interupt priorities
+ * Description:  Set up the interrupt priorities
  *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
diff --git a/arch/blackfin/mach-bf537/boards/generic_board.c b/arch/blackfin/mach-bf537/boards/generic_board.c
index 9019c0e..fd57e74 100644
--- a/arch/blackfin/mach-bf537/boards/generic_board.c
+++ b/arch/blackfin/mach-bf537/boards/generic_board.c
@@ -55,7 +55,7 @@ static struct resource bfin_pcmcia_cf_resources[] = {
 		.end = 0x20312000,
 		.flags = IORESOURCE_MEM,
 	},{
-		.start = 0x20311000, /* Attribute Memeory */
+		.start = 0x20311000, /* Attribute Memory */
 		.end = 0x20311FFF,
 		.flags = IORESOURCE_MEM,
 	},{
diff --git a/arch/blackfin/mach-bf537/boards/pnav10.c b/arch/blackfin/mach-bf537/boards/pnav10.c
index 40d3a1b..8aaf76d 100644
--- a/arch/blackfin/mach-bf537/boards/pnav10.c
+++ b/arch/blackfin/mach-bf537/boards/pnav10.c
@@ -59,7 +59,7 @@ static struct resource bfin_pcmcia_cf_resources[] = {
 		.end = 0x20312000,
 		.flags = IORESOURCE_MEM,
 	},{
-		.start = 0x20311000, /* Attribute Memeory */
+		.start = 0x20311000, /* Attribute Memory */
 		.end = 0x20311FFF,
 		.flags = IORESOURCE_MEM,
 	},{
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index ba2f875..3a29b4d 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -108,7 +108,7 @@ static struct resource bfin_pcmcia_cf_resources[] = {
 		.end = 0x20312000,
 		.flags = IORESOURCE_MEM,
 	},{
-		.start = 0x20311000, /* Attribute Memeory */
+		.start = 0x20311000, /* Attribute Memory */
 		.end = 0x20311FFF,
 		.flags = IORESOURCE_MEM,
 	},{
diff --git a/arch/blackfin/mach-bf537/ints-priority.c b/arch/blackfin/mach-bf537/ints-priority.c
index fd6308e..2dbf3df 100644
--- a/arch/blackfin/mach-bf537/ints-priority.c
+++ b/arch/blackfin/mach-bf537/ints-priority.c
@@ -4,7 +4,7 @@
  * Author:       Michael Hennerich
  *
  * Created:
- * Description:  Set up the interupt priorities
+ * Description:  Set up the interrupt priorities
  *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
diff --git a/arch/blackfin/mach-bf561/boards/cm_bf561.c b/arch/blackfin/mach-bf561/boards/cm_bf561.c
index 6824e95..3dc5c04 100644
--- a/arch/blackfin/mach-bf561/boards/cm_bf561.c
+++ b/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -1,7 +1,7 @@
 /*
  * File:         arch/blackfin/mach-bf533/boards/cm_bf561.c
  * Based on:     arch/blackfin/mach-bf533/boards/ezkit.c
- * Author:       Aidan Williams <aidan@nicta.com.au> Copright 2005
+ * Author:       Aidan Williams <aidan@nicta.com.au> Copyright 2005
  *
  * Created:      2006
  * Description:  Board description file
@@ -43,7 +43,7 @@
 char *bfin_board_name = "Bluetechnix CM BF561";
 
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
-/* all SPI perpherals info goes here */
+/* all SPI peripherals info goes here */
 
 #if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
 static struct mtd_partition bfin_spi_flash_partitions[] = {
diff --git a/arch/blackfin/mach-bf561/ints-priority.c b/arch/blackfin/mach-bf561/ints-priority.c
index 89c52ff..86e3b0e 100644
--- a/arch/blackfin/mach-bf561/ints-priority.c
+++ b/arch/blackfin/mach-bf561/ints-priority.c
@@ -4,7 +4,7 @@
  * Author:       Michael Hennerich
  *
  * Created:
- * Description:  Set up the interupt priorities
+ * Description:  Set up the interrupt priorities
  *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
diff --git a/arch/blackfin/mach-common/ints-priority-dc.c b/arch/blackfin/mach-common/ints-priority-dc.c
index f3cf070..80943bb 100644
--- a/arch/blackfin/mach-common/ints-priority-dc.c
+++ b/arch/blackfin/mach-common/ints-priority-dc.c
@@ -4,7 +4,7 @@
  * Author:
  *
  * Created:      ?
- * Description:  Set up the interupt priorities
+ * Description:  Set up the interrupt priorities
  *
  * Modified:
  *               1996 Roman Zippel
diff --git a/arch/blackfin/mach-common/ints-priority-sc.c b/arch/blackfin/mach-common/ints-priority-sc.c
index 34b6228..2cfc7d5 100644
--- a/arch/blackfin/mach-common/ints-priority-sc.c
+++ b/arch/blackfin/mach-common/ints-priority-sc.c
@@ -4,7 +4,7 @@
  * Author:
  *
  * Created:      ?
- * Description:  Set up the interupt priorities
+ * Description:  Set up the interrupt priorities
  *
  * Modified:
  *               1996 Roman Zippel
diff --git a/arch/blackfin/mm/blackfin_sram.c b/arch/blackfin/mm/blackfin_sram.c
index dd0c650..3c9e635 100644
--- a/arch/blackfin/mm/blackfin_sram.c
+++ b/arch/blackfin/mm/blackfin_sram.c
@@ -149,7 +149,7 @@ static void *_l1_sram_alloc(size_t size, struct l1_sram_piece *pfree, int count)
 	size = (size + 3) & ~3;
 
 	/* not use the good method to match the best slot !!! */
-	/* search an available memeory slot */
+	/* search an available memory slot */
 	for (i = 0; i < count; i++) {
 		if ((pfree[i].flag == SRAM_SLT_FREE)
 		    && (pfree[i].size >= size)) {
@@ -162,7 +162,7 @@ static void *_l1_sram_alloc(size_t size, struct l1_sram_piece *pfree, int count)
 	if (i >= count)
 		return NULL;
 
-	/* updated the NULL memeory slot !!! */
+	/* updated the NULL memory slot !!! */
 	if (pfree[i].size > size) {
 		for (i = 0; i < count; i++) {
 			if (pfree[i].flag == SRAM_SLT_NULL) {
@@ -186,7 +186,7 @@ static void *_l1_sram_alloc_max(struct l1_sram_piece *pfree, int count,
 	int i, index = -1;
 	void *addr = NULL;
 
-	/* search an available memeory slot */
+	/* search an available memory slot */
 	for (i = 0; i < count; i++) {
 		if (pfree[i].flag == SRAM_SLT_FREE && pfree[i].size > best) {
 			addr = pfree[i].paddr;
-- 
1.5.2
