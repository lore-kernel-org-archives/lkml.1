Return-Path: <linux-kernel-owner+w=401wt.eu-S933682AbZINUNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933682AbZINUNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933646AbZINUJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:09:01 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54125 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933519AbZINUIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:51 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Yi Li <yi.li@analog.com>
Subject: [PATCH 45/72] Blackfin: update anomaly lists
Date: Mon, 14 Sep 2009 16:07:49 -0400
Message-Id: <1252958896-25150-46-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Li <yi.li@analog.com>

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf518/include/mach/anomaly.h |    1 +
 arch/blackfin/mach-bf527/include/mach/anomaly.h |   13 +++++++++++--
 arch/blackfin/mach-bf537/include/mach/anomaly.h |    2 +-
 arch/blackfin/mach-bf538/include/mach/anomaly.h |    2 +-
 arch/blackfin/mach-bf548/include/mach/anomaly.h |   21 +++++++++++++++++++--
 arch/blackfin/mach-bf561/include/mach/anomaly.h |    2 ++
 6 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/arch/blackfin/mach-bf518/include/mach/anomaly.h b/arch/blackfin/mach-bf518/include/mach/anomaly.h
index 753ed81..e9c6539 100644
--- a/arch/blackfin/mach-bf518/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf518/include/mach/anomaly.h
@@ -124,6 +124,7 @@
 #define ANOMALY_05000386 (0)
 #define ANOMALY_05000389 (0)
 #define ANOMALY_05000400 (0)
+#define ANOMALY_05000402 (0)
 #define ANOMALY_05000412 (0)
 #define ANOMALY_05000432 (0)
 #define ANOMALY_05000447 (0)
diff --git a/arch/blackfin/mach-bf527/include/mach/anomaly.h b/arch/blackfin/mach-bf527/include/mach/anomaly.h
index c438ca8..3f90526 100644
--- a/arch/blackfin/mach-bf527/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf527/include/mach/anomaly.h
@@ -7,7 +7,7 @@
  */
 
 /* This file should be up to date with:
- *  - Revision C, 03/13/2009; ADSP-BF526 Blackfin Processor Anomaly List
+ *  - Revision D, 08/14/2009; ADSP-BF526 Blackfin Processor Anomaly List
  *  - Revision F, 03/03/2009; ADSP-BF527 Blackfin Processor Anomaly List
  */
 
@@ -176,7 +176,7 @@
 #define ANOMALY_05000443 (1)
 /* The WURESET Bit in the SYSCR Register is not Functional */
 #define ANOMALY_05000445 (1)
-/* USB DMA Short Packet Data Corruption */
+/* USB DMA Mode 1 Short Packet Data Corruption */
 #define ANOMALY_05000450 (1)
 /* BCODE_QUICKBOOT, BCODE_ALLBOOT, and BCODE_FULLBOOT Settings in SYSCR Register Not Functional */
 #define ANOMALY_05000451 (1)
@@ -186,12 +186,20 @@
 #define ANOMALY_05000456 (1)
 /* Host DMA Port Responds to Certain Bus Activity Without HOST_CE Assertion */
 #define ANOMALY_05000457 (1)
+/* USB DMA Mode 1 Failure When Multiple USB DMA Channels Are Concurrently Enabled */
+#define ANOMALY_05000460 (1)
 /* False Hardware Error when RETI Points to Invalid Memory */
 #define ANOMALY_05000461 (1)
+/* Synchronization Problem at Startup May Cause SPORT Transmit Channels to Misalign */
+#define ANOMALY_05000462 (1)
 /* USB Rx DMA hang */
 #define ANOMALY_05000465 (1)
+/* TxPktRdy Bit Not Set for Transmit Endpoint When Core and DMA Access USB Endpoint FIFOs Simultaneously */
+#define ANOMALY_05000466 (1)
 /* Possible RX data corruption when control & data EP FIFOs are accessed via the core */
 #define ANOMALY_05000467 (1)
+/* PLL Latches Incorrect Settings During Reset */
+#define ANOMALY_05000469 (1)
 
 /* Anomalies that don't exist on this proc */
 #define ANOMALY_05000099 (0)
@@ -238,6 +246,7 @@
 #define ANOMALY_05000362 (1)
 #define ANOMALY_05000363 (0)
 #define ANOMALY_05000400 (0)
+#define ANOMALY_05000402 (0)
 #define ANOMALY_05000412 (0)
 #define ANOMALY_05000447 (0)
 #define ANOMALY_05000448 (0)
diff --git a/arch/blackfin/mach-bf537/include/mach/anomaly.h b/arch/blackfin/mach-bf537/include/mach/anomaly.h
index e66aa13..f091ad2 100644
--- a/arch/blackfin/mach-bf537/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf537/include/mach/anomaly.h
@@ -143,7 +143,7 @@
 /* Possible RETS Register Corruption when Subroutine Is under 5 Cycles in Duration */
 #define ANOMALY_05000371 (1)
 /* SSYNC Stalls Processor when Executed from Non-Cacheable Memory */
-#define ANOMALY_05000402 (__SILICON_REVISION__ >= 5)
+#define ANOMALY_05000402 (__SILICON_REVISION__ == 2)
 /* Level-Sensitive External GPIO Wakeups May Cause Indefinite Stall */
 #define ANOMALY_05000403 (1)
 /* Speculative Fetches Can Cause Undesired External FIFO Operations */
diff --git a/arch/blackfin/mach-bf538/include/mach/anomaly.h b/arch/blackfin/mach-bf538/include/mach/anomaly.h
index 451cf8a..26b7608 100644
--- a/arch/blackfin/mach-bf538/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf538/include/mach/anomaly.h
@@ -113,7 +113,7 @@
 /* GPIO Pins PC1 and PC4 Can Function as Normal Outputs */
 #define ANOMALY_05000375 (__SILICON_REVISION__ < 4)
 /* SSYNC Stalls Processor when Executed from Non-Cacheable Memory */
-#define ANOMALY_05000402 (__SILICON_REVISION__ < 4)
+#define ANOMALY_05000402 (__SILICON_REVISION__ == 3)
 /* Level-Sensitive External GPIO Wakeups May Cause Indefinite Stall */
 #define ANOMALY_05000403 (1)
 /* Speculative Fetches Can Cause Undesired External FIFO Operations */
diff --git a/arch/blackfin/mach-bf548/include/mach/anomaly.h b/arch/blackfin/mach-bf548/include/mach/anomaly.h
index cd040fe..52b116a 100644
--- a/arch/blackfin/mach-bf548/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf548/include/mach/anomaly.h
@@ -7,7 +7,7 @@
  */
 
 /* This file should be up to date with:
- *  - Revision H, 01/16/2009; ADSP-BF542/BF544/BF547/BF548/BF549 Blackfin Processor Anomaly List
+ *  - Revision I, 07/23/2009; ADSP-BF542/BF544/BF547/BF548/BF549 Blackfin Processor Anomaly List
  */
 
 #ifndef _MACH_ANOMALY_H_
@@ -162,6 +162,8 @@
 #define ANOMALY_05000430 (__SILICON_REVISION__ >= 2)
 /* Incorrect Use of Stack in Lockbox Firmware During Authentication */
 #define ANOMALY_05000431 (__SILICON_REVISION__ < 3)
+/* SW Breakpoints Ignored Upon Return From Lockbox Authentication */
+#define ANOMALY_05000434 (1)
 /* OTP Write Accesses Not Supported */
 #define ANOMALY_05000442 (__SILICON_REVISION__ < 1)
 /* IFLUSH Instruction at End of Hardware Loop Causes Infinite Stall */
@@ -176,12 +178,26 @@
 #define ANOMALY_05000449 (__SILICON_REVISION__ == 1)
 /* USB DMA Mode 1 Short Packet Data Corruption */
 #define ANOMALY_05000450 (1)
+/* Incorrect Default Hysteresis Setting for RESET, NMI, and BMODE Signals */
+#define ANOMALY_05000452 (__SILICON_REVISION__ < 1)
 /* USB Receive Interrupt Is Not Generated in DMA Mode 1 */
-#define ANOMALY_05000456 (__SILICON_REVISION__ < 3)
+#define ANOMALY_05000456 (1)
+/* Host DMA Port Responds to Certain Bus Activity Without HOST_CE Assertion */
+#define ANOMALY_05000457 (1)
+/* USB DMA Mode 1 Failure When Multiple USB DMA Channels Are Concurrently Enabled */
+#define ANOMALY_05000460 (1)
 /* False Hardware Error when RETI Points to Invalid Memory */
 #define ANOMALY_05000461 (1)
+/* Synchronization Problem at Startup May Cause SPORT Transmit Channels to Misalign */
+#define ANOMALY_05000462 (1)
+/* USB DMA RX Data Corruption */
+#define ANOMALY_05000463 (1)
+/* USB TX DMA Hang */
+#define ANOMALY_05000464 (1)
 /* USB Rx DMA hang */
 #define ANOMALY_05000465 (1)
+/* TxPktRdy Bit Not Set for Transmit Endpoint When Core and DMA Access USB Endpoint FIFOs Simultaneously */
+#define ANOMALY_05000466 (1)
 /* Possible RX data corruption when control & data EP FIFOs are accessed via the core */
 #define ANOMALY_05000467 (1)
 
@@ -230,6 +246,7 @@
 #define ANOMALY_05000364 (0)
 #define ANOMALY_05000380 (0)
 #define ANOMALY_05000400 (0)
+#define ANOMALY_05000402 (0)
 #define ANOMALY_05000412 (0)
 #define ANOMALY_05000432 (0)
 #define ANOMALY_05000435 (0)
diff --git a/arch/blackfin/mach-bf561/include/mach/anomaly.h b/arch/blackfin/mach-bf561/include/mach/anomaly.h
index a5312b2..70da495 100644
--- a/arch/blackfin/mach-bf561/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf561/include/mach/anomaly.h
@@ -262,6 +262,8 @@
 #define ANOMALY_05000366 (1)
 /* Possible RETS Register Corruption when Subroutine Is under 5 Cycles in Duration */
 #define ANOMALY_05000371 (1)
+/* SSYNC Stalls Processor when Executed from Non-Cacheable Memory */
+#define ANOMALY_05000402 (__SILICON_REVISION__ == 4)
 /* Level-Sensitive External GPIO Wakeups May Cause Indefinite Stall */
 #define ANOMALY_05000403 (1)
 /* TESTSET Instruction Causes Data Corruption with Writeback Data Cache Enabled */
-- 
1.6.4.2

