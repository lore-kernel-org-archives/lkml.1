Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbZDLKrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbZDLKrp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 06:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759577AbZDLKre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 06:47:34 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:49839 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758855AbZDLKre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 06:47:34 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH 1/4] fix parenthesis balance in blackfin arch code
Date: Sun, 12 Apr 2009 12:47:28 +0200
Message-Id: <1239533251-31276-2-git-send-email-m.kozlowski@tuxland.pl>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239533251-31276-1-git-send-email-m.kozlowski@tuxland.pl>
References: <1239533251-31276-1-git-send-email-m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
---
 arch/blackfin/mach-bf538/include/mach/cdefBF538.h |    2 +-
 arch/blackfin/mach-bf548/include/mach/anomaly.h   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/mach-bf538/include/mach/cdefBF538.h b/arch/blackfin/mach-bf538/include/mach/cdefBF538.h
index 241725b..2a6c71d 100644
--- a/arch/blackfin/mach-bf538/include/mach/cdefBF538.h
+++ b/arch/blackfin/mach-bf538/include/mach/cdefBF538.h
@@ -74,7 +74,7 @@
 #define bfin_read_SIC_IWR1()           bfin_read32(SIC_IWR1)
 #define bfin_write_SIC_IWR1(val)       bfin_write32(SIC_IWR1, val)
 #define bfin_read_SIC_IWR(x)	       bfin_read32(SIC_IWR0 + x * (SIC_IWR1 - SIC_IWR0))
-#define bfin_write_SIC_IWR(x, val)     bfin_write32((SIC_IWR0 + x * (SIC_IWR1 - SIC_IWR0), val)
+#define bfin_write_SIC_IWR(x, val)     bfin_write32(SIC_IWR0 + x * (SIC_IWR1 - SIC_IWR0), val)
 #define bfin_read_SIC_IAR0()           bfin_read32(SIC_IAR0)
 #define bfin_write_SIC_IAR0(val)       bfin_write32(SIC_IAR0, val)
 #define bfin_read_SIC_IAR1()           bfin_read32(SIC_IAR1)
diff --git a/arch/blackfin/mach-bf548/include/mach/anomaly.h b/arch/blackfin/mach-bf548/include/mach/anomaly.h
index 882e40c..b1f9494 100644
--- a/arch/blackfin/mach-bf548/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf548/include/mach/anomaly.h
@@ -170,7 +170,7 @@
 /* Reduced Timing Margins on DDR Output Setup and Hold (tDS and tDH) */
 #define ANOMALY_05000449 (__SILICON_REVISION__ == 1)
 /* USB DMA Mode 1 Short Packet Data Corruption */
-#define ANOMALY_05000450 (1
+#define ANOMALY_05000450 (1)
 
 /* Anomalies that don't exist on this proc */
 #define ANOMALY_05000125 (0)
-- 
1.5.6.3

