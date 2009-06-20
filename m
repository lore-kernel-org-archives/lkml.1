Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbZFTSqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbZFTSqa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757363AbZFTSpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:45:38 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48018 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757259AbZFTSpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:45:33 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 04/25] Blackfin: update anomaly lists
Date: Sat, 20 Jun 2009 14:44:27 -0400
Message-Id: <1245523488-26536-5-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update anomaly headers to match latest released anomaly sheets.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf518/include/mach/anomaly.h |   37 +++++++---
 arch/blackfin/mach-bf527/include/mach/anomaly.h |   15 ++++-
 arch/blackfin/mach-bf533/include/mach/anomaly.h |   77 ++++++++++----------
 arch/blackfin/mach-bf537/include/mach/anomaly.h |   41 ++++++-----
 arch/blackfin/mach-bf538/include/mach/anomaly.h |   24 ++++--
 arch/blackfin/mach-bf548/include/mach/anomaly.h |   20 ++++--
 arch/blackfin/mach-bf561/include/mach/anomaly.h |   89 ++++++++++++-----------
 7 files changed, 178 insertions(+), 125 deletions(-)

diff --git a/arch/blackfin/mach-bf518/include/mach/anomaly.h b/arch/blackfin/mach-bf518/include/mach/anomaly.h
index b69bd9a..426e064 100644
--- a/arch/blackfin/mach-bf518/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf518/include/mach/anomaly.h
@@ -7,7 +7,7 @@
  */
 
 /* This file should be up to date with:
- *  - Revision B, 02/03/2009; ADSP-BF512/BF514/BF516/BF518 Blackfin Processor Anomaly List
+ *  - Revision C, 06/12/2009; ADSP-BF512/BF514/BF516/BF518 Blackfin Processor Anomaly List
  */
 
 /* We plan on not supporting 0.0 silicon, but 0.1 isn't out yet - sorry */
@@ -18,7 +18,7 @@
 #ifndef _MACH_ANOMALY_H_
 #define _MACH_ANOMALY_H_
 
-/* Multi-issue instruction with dsp32shiftimm in slot1 and P-reg store in slot 2 not supported */
+/* Multi-Issue Instruction with dsp32shiftimm in slot1 and P-reg Store in slot2 Not Supported */
 #define ANOMALY_05000074 (1)
 /* Rx.H Cannot Be Used to Access 16-bit System MMR Registers */
 #define ANOMALY_05000122 (1)
@@ -45,29 +45,31 @@
 /* Speculative Fetches of Indirect-Pointer Instructions Can Cause False Hardware Errors */
 #define ANOMALY_05000426 (1)
 /* Software System Reset Corrupts PLL_LOCKCNT Register */
-#define ANOMALY_05000430 (1)
+#define ANOMALY_05000430 (__SILICON_REVISION__ < 1)
 /* Incorrect Use of Stack in Lockbox Firmware During Authentication */
 #define ANOMALY_05000431 (1)
 /* Certain SIC Registers are not Reset After Soft or Core Double Fault Reset */
-#define ANOMALY_05000435 (1)
+#define ANOMALY_05000435 (__SILICON_REVISION__ < 1)
 /* PORTx_DRIVE and PORTx_HYSTERESIS Registers Read Back Incorrect Values */
-#define ANOMALY_05000438 (1)
+#define ANOMALY_05000438 (__SILICON_REVISION__ < 1)
 /* Preboot Cannot be Used to Alter the PLL_DIV Register */
-#define ANOMALY_05000439 (1)
+#define ANOMALY_05000439 (__SILICON_REVISION__ < 1)
 /* bfrom_SysControl() Cannot be Used to Write the PLL_DIV Register */
-#define ANOMALY_05000440 (1)
+#define ANOMALY_05000440 (__SILICON_REVISION__ < 1)
 /* IFLUSH Instruction at End of Hardware Loop Causes Infinite Stall */
 #define ANOMALY_05000443 (1)
 /* Incorrect L1 Instruction Bank B Memory Map Location */
-#define ANOMALY_05000444 (1)
+#define ANOMALY_05000444 (__SILICON_REVISION__ < 1)
 /* Incorrect Default Hysteresis Setting for RESET, NMI, and BMODE Signals */
-#define ANOMALY_05000452 (1)
+#define ANOMALY_05000452 (__SILICON_REVISION__ < 1)
 /* PWM_TRIPB Signal Not Available on PG10 */
-#define ANOMALY_05000453 (1)
+#define ANOMALY_05000453 (__SILICON_REVISION__ < 1)
 /* PPI_FS3 is Driven One Half Cycle Later Than PPI Data */
-#define ANOMALY_05000455 (1)
-/* False Hardware Error when RETI points to invalid memory */
+#define ANOMALY_05000455 (__SILICON_REVISION__ < 1)
+/* False Hardware Error when RETI Points to Invalid Memory */
 #define ANOMALY_05000461 (1)
+/* Synchronization Problem at Startup May Cause SPORT Transmit Channels to Misalign */
+#define ANOMALY_05000462 (1)
 
 /* Anomalies that don't exist on this proc */
 #define ANOMALY_05000099 (0)
@@ -78,24 +80,30 @@
 #define ANOMALY_05000158 (0)
 #define ANOMALY_05000171 (0)
 #define ANOMALY_05000179 (0)
+#define ANOMALY_05000182 (0)
 #define ANOMALY_05000183 (0)
 #define ANOMALY_05000198 (0)
+#define ANOMALY_05000202 (0)
 #define ANOMALY_05000215 (0)
 #define ANOMALY_05000220 (0)
 #define ANOMALY_05000227 (0)
 #define ANOMALY_05000230 (0)
 #define ANOMALY_05000231 (0)
 #define ANOMALY_05000233 (0)
+#define ANOMALY_05000234 (0)
 #define ANOMALY_05000242 (0)
 #define ANOMALY_05000244 (0)
 #define ANOMALY_05000248 (0)
 #define ANOMALY_05000250 (0)
+#define ANOMALY_05000257 (0)
 #define ANOMALY_05000261 (0)
 #define ANOMALY_05000263 (0)
 #define ANOMALY_05000266 (0)
 #define ANOMALY_05000273 (0)
 #define ANOMALY_05000274 (0)
 #define ANOMALY_05000278 (0)
+#define ANOMALY_05000281 (0)
+#define ANOMALY_05000283 (0)
 #define ANOMALY_05000285 (0)
 #define ANOMALY_05000287 (0)
 #define ANOMALY_05000301 (0)
@@ -103,10 +111,13 @@
 #define ANOMALY_05000307 (0)
 #define ANOMALY_05000311 (0)
 #define ANOMALY_05000312 (0)
+#define ANOMALY_05000315 (0)
 #define ANOMALY_05000323 (0)
 #define ANOMALY_05000353 (0)
+#define ANOMALY_05000357 (0)
 #define ANOMALY_05000362 (1)
 #define ANOMALY_05000363 (0)
+#define ANOMALY_05000371 (0)
 #define ANOMALY_05000380 (0)
 #define ANOMALY_05000386 (0)
 #define ANOMALY_05000389 (0)
@@ -117,5 +128,7 @@
 #define ANOMALY_05000448 (0)
 #define ANOMALY_05000456 (0)
 #define ANOMALY_05000450 (0)
+#define ANOMALY_05000465 (0)
+#define ANOMALY_05000467 (0)
 
 #endif
diff --git a/arch/blackfin/mach-bf527/include/mach/anomaly.h b/arch/blackfin/mach-bf527/include/mach/anomaly.h
index c84ddea..0d63f74 100644
--- a/arch/blackfin/mach-bf527/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf527/include/mach/anomaly.h
@@ -34,7 +34,7 @@
 #define _ANOMALY_BF527(rev527) (ANOMALY_BF527 && __SILICON_REVISION__ rev527)
 #define _ANOMALY_BF526_BF527(rev526, rev527) (_ANOMALY_BF526(rev526) || _ANOMALY_BF527(rev527))
 
-/* Multi-issue instruction with dsp32shiftimm in slot1 and P-reg store in slot 2 not supported */
+/* Multi-Issue Instruction with dsp32shiftimm in slot1 and P-reg Store in slot2 Not Supported */
 #define ANOMALY_05000074 (1)
 /* DMA_RUN Bit Is Not Valid after a Peripheral Receive Channel DMA Stops */
 #define ANOMALY_05000119 (1)	/* note: brokenness is noted in documentation, not anomaly sheet */
@@ -184,8 +184,12 @@
 #define ANOMALY_05000456 (1)
 /* Host DMA Port Responds to Certain Bus Activity Without HOST_CE Assertion */
 #define ANOMALY_05000457 (1)
-/* False Hardware Error when RETI points to invalid memory */
+/* False Hardware Error when RETI Points to Invalid Memory */
 #define ANOMALY_05000461 (1)
+/* USB Rx DMA hang */
+#define ANOMALY_05000465 (1)
+/* Possible RX data corruption when control & data EP FIFOs are accessed via the core */
+#define ANOMALY_05000467 (1)
 
 /* Anomalies that don't exist on this proc */
 #define ANOMALY_05000099 (0)
@@ -195,24 +199,30 @@
 #define ANOMALY_05000158 (0)
 #define ANOMALY_05000171 (0)
 #define ANOMALY_05000179 (0)
+#define ANOMALY_05000182 (0)
 #define ANOMALY_05000183 (0)
 #define ANOMALY_05000198 (0)
+#define ANOMALY_05000202 (0)
 #define ANOMALY_05000215 (0)
 #define ANOMALY_05000220 (0)
 #define ANOMALY_05000227 (0)
 #define ANOMALY_05000230 (0)
 #define ANOMALY_05000231 (0)
 #define ANOMALY_05000233 (0)
+#define ANOMALY_05000234 (0)
 #define ANOMALY_05000242 (0)
 #define ANOMALY_05000244 (0)
 #define ANOMALY_05000248 (0)
 #define ANOMALY_05000250 (0)
+#define ANOMALY_05000257 (0)
 #define ANOMALY_05000261 (0)
 #define ANOMALY_05000263 (0)
 #define ANOMALY_05000266 (0)
 #define ANOMALY_05000273 (0)
 #define ANOMALY_05000274 (0)
 #define ANOMALY_05000278 (0)
+#define ANOMALY_05000281 (0)
+#define ANOMALY_05000283 (0)
 #define ANOMALY_05000285 (0)
 #define ANOMALY_05000287 (0)
 #define ANOMALY_05000301 (0)
@@ -220,6 +230,7 @@
 #define ANOMALY_05000307 (0)
 #define ANOMALY_05000311 (0)
 #define ANOMALY_05000312 (0)
+#define ANOMALY_05000315 (0)
 #define ANOMALY_05000323 (0)
 #define ANOMALY_05000362 (1)
 #define ANOMALY_05000363 (0)
diff --git a/arch/blackfin/mach-bf533/include/mach/anomaly.h b/arch/blackfin/mach-bf533/include/mach/anomaly.h
index 31145b5..70a0ad6 100644
--- a/arch/blackfin/mach-bf533/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf533/include/mach/anomaly.h
@@ -34,7 +34,7 @@
 # define ANOMALY_BF533 0
 #endif
 
-/* Multi-issue instruction with dsp32shiftimm in slot1 and P-reg store in slot 2 not supported */
+/* Multi-Issue Instruction with dsp32shiftimm in slot1 and P-reg Store in slot2 Not Supported */
 #define ANOMALY_05000074 (1)
 /* UART Line Status Register (UART_LSR) Bits Are Not Updated at the Same Time */
 #define ANOMALY_05000099 (__SILICON_REVISION__ < 5)
@@ -46,7 +46,7 @@
 #define ANOMALY_05000122 (1)
 /* Instruction DMA Can Cause Data Cache Fills to Fail (Boot Implications) */
 #define ANOMALY_05000158 (__SILICON_REVISION__ < 5)
-/* PPI Data Lengths Between 8 and 16 Do Not Zero Out Upper Bits */
+/* PPI Data Lengths between 8 and 16 Do Not Zero Out Upper Bits */
 #define ANOMALY_05000166 (1)
 /* Turning SPORTs on while External Frame Sync Is Active May Corrupt Data */
 #define ANOMALY_05000167 (1)
@@ -56,13 +56,13 @@
 #define ANOMALY_05000180 (1)
 /* Timer Pin Limitations for PPI TX Modes with External Frame Syncs */
 #define ANOMALY_05000183 (__SILICON_REVISION__ < 4)
-/* False Protection Exceptions */
+/* False Protection Exceptions when Speculative Fetch Is Cancelled */
 #define ANOMALY_05000189 (__SILICON_REVISION__ < 4)
 /* False I/O Pin Interrupts on Edge-Sensitive Inputs When Polarity Setting Is Changed */
 #define ANOMALY_05000193 (__SILICON_REVISION__ < 4)
 /* Restarting SPORT in Specific Modes May Cause Data Corruption */
 #define ANOMALY_05000194 (__SILICON_REVISION__ < 4)
-/* Failing MMR Accesses When Stalled by Preceding Memory Read */
+/* Failing MMR Accesses when Preceding Memory Read Stalls */
 #define ANOMALY_05000198 (__SILICON_REVISION__ < 5)
 /* Current DMA Address Shows Wrong Value During Carry Fix */
 #define ANOMALY_05000199 (__SILICON_REVISION__ < 4)
@@ -74,7 +74,7 @@
 #define ANOMALY_05000202 (__SILICON_REVISION__ < 5)
 /* Specific Sequence That Can Cause DMA Error or DMA Stopping */
 #define ANOMALY_05000203 (__SILICON_REVISION__ < 4)
-/* Incorrect data read with write-through cache and allocate cache lines on reads only mode */
+/* Incorrect Data Read with Writethrough "Allocate Cache Lines on Reads Only" Cache Mode */
 #define ANOMALY_05000204 (__SILICON_REVISION__ < 4 && ANOMALY_BF533)
 /* Recovery from "Brown-Out" Condition */
 #define ANOMALY_05000207 (__SILICON_REVISION__ < 4)
@@ -106,7 +106,7 @@
 #define ANOMALY_05000244 (__SILICON_REVISION__ < 5)
 /* False Hardware Error from an Access in the Shadow of a Conditional Branch */
 #define ANOMALY_05000245 (1)
-/* Data CPLBs Should Prevent Spurious Hardware Errors */
+/* Data CPLBs Should Prevent False Hardware Errors */
 #define ANOMALY_05000246 (__SILICON_REVISION__ < 5)
 /* Incorrect Bit Shift of Data Word in Multichannel (TDM) Mode in Certain Conditions */
 #define ANOMALY_05000250 (__SILICON_REVISION__ == 4)
@@ -148,21 +148,21 @@
 #define ANOMALY_05000277 (__SILICON_REVISION__ < 6)
 /* Disabling Peripherals with DMA Running May Cause DMA System Instability */
 #define ANOMALY_05000278 (__SILICON_REVISION__ < 6)
-/* False Hardware Error Exception When ISR Context Is Not Restored */
+/* False Hardware Error Exception when ISR Context Is Not Restored */
 #define ANOMALY_05000281 (__SILICON_REVISION__ < 6)
 /* Memory DMA Corruption with 32-Bit Data and Traffic Control */
 #define ANOMALY_05000282 (__SILICON_REVISION__ < 6)
-/* System MMR Write Is Stalled Indefinitely When Killed in a Particular Stage */
+/* System MMR Write Is Stalled Indefinitely when Killed in a Particular Stage */
 #define ANOMALY_05000283 (__SILICON_REVISION__ < 6)
 /* SPORTs May Receive Bad Data If FIFOs Fill Up */
 #define ANOMALY_05000288 (__SILICON_REVISION__ < 6)
 /* Memory-To-Memory DMA Source/Destination Descriptors Must Be in Same Memory Space */
 #define ANOMALY_05000301 (__SILICON_REVISION__ < 6)
-/* SSYNCs After Writes To DMA MMR Registers May Not Be Handled Correctly */
+/* SSYNCs after Writes to DMA MMR Registers May Not Be Handled Correctly */
 #define ANOMALY_05000302 (__SILICON_REVISION__ < 5)
 /* SPORT_HYS Bit in PLL_CTL Register Is Not Functional */
 #define ANOMALY_05000305 (__SILICON_REVISION__ < 5)
-/* New Feature: Additional PPI Frame Sync Sampling Options (Not Available On Older Silicon) */
+/* ALT_TIMING Bit in PPI_CONTROL Register Is Not Functional */
 #define ANOMALY_05000306 (__SILICON_REVISION__ < 5)
 /* SCKELOW Bit Does Not Maintain State Through Hibernate */
 #define ANOMALY_05000307 (1)	/* note: brokenness is noted in documentation, not anomaly sheet */
@@ -170,11 +170,11 @@
 #define ANOMALY_05000310 (1)
 /* Erroneous Flag (GPIO) Pin Operations under Specific Sequences */
 #define ANOMALY_05000311 (__SILICON_REVISION__ < 6)
-/* Errors When SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are Interrupted */
+/* Errors when SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are Interrupted */
 #define ANOMALY_05000312 (__SILICON_REVISION__ < 6)
 /* PPI Is Level-Sensitive on First Transfer In Single Frame Sync Modes */
 #define ANOMALY_05000313 (__SILICON_REVISION__ < 6)
-/* Killed System MMR Write Completes Erroneously On Next System MMR Access */
+/* Killed System MMR Write Completes Erroneously on Next System MMR Access */
 #define ANOMALY_05000315 (__SILICON_REVISION__ < 6)
 /* Internal Voltage Regulator Values of 1.05V, 1.10V and 1.15V Not Allowed for LQFP Packages */
 #define ANOMALY_05000319 ((ANOMALY_BF531 || ANOMALY_BF532) && __SILICON_REVISION__ < 6)
@@ -200,7 +200,7 @@
 #define ANOMALY_05000426 (1)
 /* IFLUSH Instruction at End of Hardware Loop Causes Infinite Stall */
 #define ANOMALY_05000443 (1)
-/* False Hardware Error when RETI points to invalid memory */
+/* False Hardware Error when RETI Points to Invalid Memory */
 #define ANOMALY_05000461 (1)
 
 /* These anomalies have been "phased" out of analog.com anomaly sheets and are
@@ -215,17 +215,17 @@
 #define ANOMALY_05000070 (__SILICON_REVISION__ < 2)
 /* Writing FIO_DIR can corrupt a programmable flag's data */
 #define ANOMALY_05000079 (__SILICON_REVISION__ < 2)
-/* Timer Auto-Baud Mode requires the UART clock to be enabled */
+/* Timer Auto-Baud Mode requires the UART clock to be enabled. */
 #define ANOMALY_05000086 (__SILICON_REVISION__ < 2)
 /* Internal Clocking Modes on SPORT0 not supported */
 #define ANOMALY_05000088 (__SILICON_REVISION__ < 2)
 /* Internal voltage regulator does not wake up from an RTC wakeup */
 #define ANOMALY_05000092 (__SILICON_REVISION__ < 2)
-/* The IFLUSH instruction must be preceded by a CSYNC instruction */
+/* The IFLUSH Instruction Must Be Preceded by a CSYNC Instruction */
 #define ANOMALY_05000093 (__SILICON_REVISION__ < 2)
-/* Vectoring to an instruction that is presently being filled into the instruction cache may cause erroneous behavior */
+/* Vectoring to instruction that is being filled into the i-cache may cause erroneous behavior */
 #define ANOMALY_05000095 (__SILICON_REVISION__ < 2)
-/* PREFETCH, FLUSH, and FLUSHINV must be followed by a CSYNC */
+/* PREFETCH, FLUSH, and FLUSHINV Instructions Must Be Followed by a CSYNC Instruction */
 #define ANOMALY_05000096 (__SILICON_REVISION__ < 2)
 /* Performance Monitor 0 and 1 are swapped when monitoring memory events */
 #define ANOMALY_05000097 (__SILICON_REVISION__ < 2)
@@ -235,45 +235,45 @@
 #define ANOMALY_05000100 (__SILICON_REVISION__ < 2)
 /* Reading X_MODIFY or Y_MODIFY while DMA channel is active */
 #define ANOMALY_05000101 (__SILICON_REVISION__ < 2)
-/* Descriptor-based MemDMA may lock up with 32-bit transfers or if transfers span 64KB buffers */
+/* Descriptor MemDMA may lock up with 32-bit transfers or if transfers span 64KB buffers */
 #define ANOMALY_05000102 (__SILICON_REVISION__ < 2)
-/* Incorrect value written to the cycle counters */
+/* Incorrect Value Written to the Cycle Counters */
 #define ANOMALY_05000103 (__SILICON_REVISION__ < 2)
-/* Stores to L1 Data memory incorrect when a specific sequence is followed */
+/* Stores to L1 Data Memory Incorrect when a Specific Sequence Is Followed */
 #define ANOMALY_05000104 (__SILICON_REVISION__ < 2)
 /* Programmable Flag (PF3) functionality not supported in all PPI modes */
 #define ANOMALY_05000106 (__SILICON_REVISION__ < 2)
 /* Data store can be lost when targeting a cache line fill */
 #define ANOMALY_05000107 (__SILICON_REVISION__ < 2)
-/* Reserved bits in SYSCFG register not set at power on */
+/* Reserved Bits in SYSCFG Register Not Set at Power-On */
 #define ANOMALY_05000109 (__SILICON_REVISION__ < 3)
 /* Infinite Core Stall */
 #define ANOMALY_05000114 (__SILICON_REVISION__ < 2)
-/* PPI_FSx may glitch when generated by the on chip Timers */
+/* PPI_FSx may glitch when generated by the on chip Timers. */
 #define ANOMALY_05000115 (__SILICON_REVISION__ < 2)
-/* Trace Buffers may record discontinuities into emulation mode and/or exception, NMI, reset handlers */
+/* Trace Buffers May Contain Errors in Emulation Mode and/or Exception, NMI, Reset Handlers */
 #define ANOMALY_05000116 (__SILICON_REVISION__ < 3)
 /* DTEST registers allow access to Data Cache when DTEST_COMMAND< 14 >= 0 */
 #define ANOMALY_05000117 (__SILICON_REVISION__ < 2)
 /* Booting from an 8-bit or 24-bit Addressable SPI device is not supported */
 #define ANOMALY_05000118 (__SILICON_REVISION__ < 2)
-/* DTEST_COMMAND initiated memory access may be incorrect if data cache or DMA is active */
+/* DTEST_COMMAND Initiated Memory Access May Be Incorrect If Data Cache or DMA Is Active */
 #define ANOMALY_05000123 (__SILICON_REVISION__ < 3)
 /* DMA Lock-up at CCLK to SCLK ratios of 4:1, 2:1, or 1:1 */
 #define ANOMALY_05000124 (__SILICON_REVISION__ < 3)
-/* Erroneous exception when enabling cache */
+/* Erroneous Exception when Enabling Cache */
 #define ANOMALY_05000125 (__SILICON_REVISION__ < 3)
 /* SPI clock polarity and phase bits incorrect during booting */
 #define ANOMALY_05000126 (__SILICON_REVISION__ < 3)
-/* DMEM_CONTROL is not set on Reset */
+/* DMEM_CONTROL<12> Is Not Set on Reset */
 #define ANOMALY_05000137 (__SILICON_REVISION__ < 3)
 /* SPI boot will not complete if there is a zero fill block in the loader file */
 #define ANOMALY_05000138 (__SILICON_REVISION__ == 2)
-/* Timerx_Config must be set for using the PPI in GP output mode with internal Frame Syncs */
+/* TIMERx_CONFIG[5] must be set for PPI in GP output mode with internal Frame Syncs */
 #define ANOMALY_05000139 (__SILICON_REVISION__ < 2)
 /* Allowing the SPORT RX FIFO to fill will cause an overflow */
 #define ANOMALY_05000140 (__SILICON_REVISION__ < 3)
-/* An Infinite Stall occurs with a particular sequence of consecutive dual dag events */
+/* Infinite Stall may occur with a particular sequence of consecutive dual dag events */
 #define ANOMALY_05000141 (__SILICON_REVISION__ < 3)
 /* Interrupts may be lost when a programmable input flag is configured to be edge sensitive */
 #define ANOMALY_05000142 (__SILICON_REVISION__ < 3)
@@ -287,7 +287,7 @@
 #define ANOMALY_05000146 (__SILICON_REVISION__ < 3)
 /* Source MDMA descriptor may stop with a DMA Error near beginning of descriptor fetch */
 #define ANOMALY_05000147 (__SILICON_REVISION__ < 3)
-/* When booting from a 16-bit asynchronous memory device, the upper 8-bits of each word must be 0x00 */
+/* When booting from 16-bit asynchronous memory, the upper 8 bits of each word must be 0x00 */
 #define ANOMALY_05000148 (__SILICON_REVISION__ < 3)
 /* Frame Delay in SPORT Multichannel Mode */
 #define ANOMALY_05000153 (__SILICON_REVISION__ < 3)
@@ -295,13 +295,13 @@
 #define ANOMALY_05000154 (__SILICON_REVISION__ < 3)
 /* Timer1 can not be used for PWMOUT mode when a certain PPI mode is in use */
 #define ANOMALY_05000155 (__SILICON_REVISION__ < 3)
-/* Killed 32-bit MMR write leads to next system MMR access thinking it should be 32-bit */
+/* Killed 32-Bit MMR Write Leads to Next System MMR Access Thinking It Should Be 32-Bit */
 #define ANOMALY_05000157 (__SILICON_REVISION__ < 3)
-/* SPORT transmit data is not gated by external frame sync in certain conditions */
+/* SPORT Transmit Data Is Not Gated by External Frame Sync in Certain Conditions */
 #define ANOMALY_05000163 (__SILICON_REVISION__ < 3)
-/* SDRAM auto-refresh and subsequent Power Ups */
+/* Undefined Behavior when Power-Up Sequence Is Issued to SDRAM during Auto-Refresh */
 #define ANOMALY_05000168 (__SILICON_REVISION__ < 3)
-/* DATA CPLB page miss can result in lost write-through cache data writes */
+/* DATA CPLB Page Miss Can Result in Lost Write-Through Data Cache Writes */
 #define ANOMALY_05000169 (__SILICON_REVISION__ < 3)
 /* DMA vs Core accesses to external memory */
 #define ANOMALY_05000173 (__SILICON_REVISION__ < 3)
@@ -309,15 +309,15 @@
 #define ANOMALY_05000174 (__SILICON_REVISION__ < 3)
 /* Overlapping Sequencer and Memory Stalls */
 #define ANOMALY_05000175 (__SILICON_REVISION__ < 3)
-/* Multiplication of (-1) by (-1) followed by an accumulator saturation */
+/* Overflow Bit Asserted when Multiplication of -1 by -1 Followed by Accumulator Saturation */
 #define ANOMALY_05000176 (__SILICON_REVISION__ < 3)
-/* Disabling the PPI resets the PPI configuration registers */
+/* Disabling the PPI Resets the PPI Configuration Registers */
 #define ANOMALY_05000181 (__SILICON_REVISION__ < 3)
-/* PPI TX Mode with 2 External Frame Syncs */
+/* Early PPI Transmit when FS1 Asserts before FS2 in TX Mode with 2 External Frame Syncs */
 #define ANOMALY_05000185 (__SILICON_REVISION__ < 3)
 /* PPI does not invert the Driving PPICLK edge in Transmit Modes */
 #define ANOMALY_05000191 (__SILICON_REVISION__ < 3)
-/* In PPI Transmit Modes with External Frame Syncs POLC */
+/* In PPI Transmit Modes with External Frame Syncs POLC bit must be set to 1 */
 #define ANOMALY_05000192 (__SILICON_REVISION__ < 3)
 /* Internal Voltage Regulator may not start up */
 #define ANOMALY_05000206 (__SILICON_REVISION__ < 3)
@@ -326,6 +326,7 @@
 #define ANOMALY_05000120 (0)
 #define ANOMALY_05000149 (0)
 #define ANOMALY_05000171 (0)
+#define ANOMALY_05000182 (0)
 #define ANOMALY_05000220 (0)
 #define ANOMALY_05000248 (0)
 #define ANOMALY_05000266 (0)
@@ -345,5 +346,7 @@
 #define ANOMALY_05000448 (0)
 #define ANOMALY_05000456 (0)
 #define ANOMALY_05000450 (0)
+#define ANOMALY_05000465 (0)
+#define ANOMALY_05000467 (0)
 
 #endif
diff --git a/arch/blackfin/mach-bf537/include/mach/anomaly.h b/arch/blackfin/mach-bf537/include/mach/anomaly.h
index fc96634..57c128c 100644
--- a/arch/blackfin/mach-bf537/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf537/include/mach/anomaly.h
@@ -34,13 +34,13 @@
 # define ANOMALY_BF537 0
 #endif
 
-/* Multi-issue instruction with dsp32shiftimm in slot1 and P-reg store in slot 2 not supported */
+/* Multi-Issue Instruction with dsp32shiftimm in slot1 and P-reg Store in slot2 Not Supported */
 #define ANOMALY_05000074 (1)
 /* DMA_RUN Bit Is Not Valid after a Peripheral Receive Channel DMA Stops */
 #define ANOMALY_05000119 (1)
 /* Rx.H Cannot Be Used to Access 16-bit System MMR Registers */
 #define ANOMALY_05000122 (1)
-/* Killed 32-bit MMR write leads to next system MMR access thinking it should be 32-bit */
+/* Killed 32-Bit MMR Write Leads to Next System MMR Access Thinking It Should Be 32-Bit */
 #define ANOMALY_05000157 (__SILICON_REVISION__ < 2)
 /* PPI_DELAY Not Functional in PPI Modes with 0 Frame Syncs */
 #define ANOMALY_05000180 (1)
@@ -50,11 +50,11 @@
 #define ANOMALY_05000244 (__SILICON_REVISION__ < 3)
 /* False Hardware Error from an Access in the Shadow of a Conditional Branch */
 #define ANOMALY_05000245 (1)
-/* CLKIN Buffer Output Enable Reset Behavior Is Changed */
+/* Buffered CLKIN Output Is Disabled by Default */
 #define ANOMALY_05000247 (1)
 /* Incorrect Bit Shift of Data Word in Multichannel (TDM) Mode in Certain Conditions */
 #define ANOMALY_05000250 (__SILICON_REVISION__ < 3)
-/* EMAC Tx DMA error after an early frame abort */
+/* EMAC TX DMA Error After an Early Frame Abort */
 #define ANOMALY_05000252 (__SILICON_REVISION__ < 3)
 /* Maximum External Clock Speed for Timers */
 #define ANOMALY_05000253 (__SILICON_REVISION__ < 3)
@@ -62,7 +62,7 @@
 #define ANOMALY_05000254 (__SILICON_REVISION__ > 2)
 /* Entering Hibernate State with RTC Seconds Interrupt Not Functional */
 #define ANOMALY_05000255 (__SILICON_REVISION__ < 3)
-/* EMAC MDIO input latched on wrong MDC edge */
+/* EMAC MDIO Input Latched on Wrong MDC Edge */
 #define ANOMALY_05000256 (__SILICON_REVISION__ < 3)
 /* Interrupt/Exception During Short Hardware Loop May Cause Bad Instruction Fetches */
 #define ANOMALY_05000257 (__SILICON_REVISION__ < 3)
@@ -80,7 +80,7 @@
 #define ANOMALY_05000264 (__SILICON_REVISION__ < 3)
 /* Sensitivity To Noise with Slow Input Edge Rates on External SPORT TX and RX Clocks */
 #define ANOMALY_05000265 (1)
-/* Memory DMA error when peripheral DMA is running with non-zero DEB_TRAFFIC_PERIOD */
+/* Memory DMA Error when Peripheral DMA Is Running with Non-Zero DEB_TRAFFIC_PERIOD */
 #define ANOMALY_05000268 (__SILICON_REVISION__ < 3)
 /* High I/O Activity Causes Output Voltage of Internal Voltage Regulator (Vddint) to Decrease */
 #define ANOMALY_05000270 (__SILICON_REVISION__ < 3)
@@ -92,15 +92,15 @@
 #define ANOMALY_05000277 (__SILICON_REVISION__ < 3)
 /* Disabling Peripherals with DMA Running May Cause DMA System Instability */
 #define ANOMALY_05000278 (((ANOMALY_BF536 || ANOMALY_BF537) && __SILICON_REVISION__ < 3) || (ANOMALY_BF534 && __SILICON_REVISION__ < 2))
-/* SPI Master boot mode does not work well with Atmel Data flash devices */
+/* SPI Master Boot Mode Does Not Work Well with Atmel Data Flash Devices */
 #define ANOMALY_05000280 (1)
-/* False Hardware Error Exception When ISR Context Is Not Restored */
+/* False Hardware Error Exception when ISR Context Is Not Restored */
 #define ANOMALY_05000281 (__SILICON_REVISION__ < 3)
 /* Memory DMA Corruption with 32-Bit Data and Traffic Control */
 #define ANOMALY_05000282 (__SILICON_REVISION__ < 3)
-/* System MMR Write Is Stalled Indefinitely When Killed in a Particular Stage */
+/* System MMR Write Is Stalled Indefinitely when Killed in a Particular Stage */
 #define ANOMALY_05000283 (__SILICON_REVISION__ < 3)
-/* New Feature: EMAC TX DMA Word Alignment (Not Available On Older Silicon) */
+/* TXDWA Bit in EMAC_SYSCTL Register Is Not Functional */
 #define ANOMALY_05000285 (__SILICON_REVISION__ < 3)
 /* SPORTs May Receive Bad Data If FIFOs Fill Up */
 #define ANOMALY_05000288 (__SILICON_REVISION__ < 3)
@@ -112,25 +112,25 @@
 #define ANOMALY_05000305 (__SILICON_REVISION__ < 3)
 /* SCKELOW Bit Does Not Maintain State Through Hibernate */
 #define ANOMALY_05000307 (__SILICON_REVISION__ < 3)
-/* Writing UART_THR while UART clock is disabled sends erroneous start bit */
+/* Writing UART_THR While UART Clock Is Disabled Sends Erroneous Start Bit */
 #define ANOMALY_05000309 (__SILICON_REVISION__ < 3)
 /* False Hardware Errors Caused by Fetches at the Boundary of Reserved Memory */
 #define ANOMALY_05000310 (1)
-/* Errors When SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are Interrupted */
+/* Errors when SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are Interrupted */
 #define ANOMALY_05000312 (1)
 /* PPI Is Level-Sensitive on First Transfer In Single Frame Sync Modes */
 #define ANOMALY_05000313 (1)
-/* Killed System MMR Write Completes Erroneously On Next System MMR Access */
+/* Killed System MMR Write Completes Erroneously on Next System MMR Access */
 #define ANOMALY_05000315 (__SILICON_REVISION__ < 3)
-/* EMAC RMII mode: collisions occur in Full Duplex mode */
+/* EMAC RMII Mode: Collisions Occur in Full Duplex Mode */
 #define ANOMALY_05000316 (__SILICON_REVISION__ < 3)
-/* EMAC RMII mode: TX frames in half duplex fail with status No Carrier */
+/* EMAC RMII Mode: TX Frames in Half Duplex Fail with Status "No Carrier" */
 #define ANOMALY_05000321 (__SILICON_REVISION__ < 3)
-/* EMAC RMII mode at 10-Base-T speed: RX frames not received properly */
+/* EMAC RMII Mode at 10-Base-T Speed: RX Frames Not Received Properly */
 #define ANOMALY_05000322 (1)
 /* Ethernet MAC MDIO Reads Do Not Meet IEEE Specification */
 #define ANOMALY_05000341 (__SILICON_REVISION__ >= 3)
-/* New Feature: UART Remains Enabled after UART Boot */
+/* UART Gets Disabled after UART Boot */
 #define ANOMALY_05000350 (__SILICON_REVISION__ >= 3)
 /* Regulator Programming Blocked when Hibernate Wakeup Source Remains Active */
 #define ANOMALY_05000355 (1)
@@ -154,7 +154,7 @@
 #define ANOMALY_05000426 (1)
 /* IFLUSH Instruction at End of Hardware Loop Causes Infinite Stall */
 #define ANOMALY_05000443 (1)
-/* False Hardware Error when RETI points to invalid memory */
+/* False Hardware Error when RETI Points to Invalid Memory */
 #define ANOMALY_05000461 (1)
 
 /* Anomalies that don't exist on this proc */
@@ -165,14 +165,17 @@
 #define ANOMALY_05000158 (0)
 #define ANOMALY_05000171 (0)
 #define ANOMALY_05000179 (0)
+#define ANOMALY_05000182 (0)
 #define ANOMALY_05000183 (0)
 #define ANOMALY_05000198 (0)
+#define ANOMALY_05000202 (0)
 #define ANOMALY_05000215 (0)
 #define ANOMALY_05000220 (0)
 #define ANOMALY_05000227 (0)
 #define ANOMALY_05000230 (0)
 #define ANOMALY_05000231 (0)
 #define ANOMALY_05000233 (0)
+#define ANOMALY_05000234 (0)
 #define ANOMALY_05000242 (0)
 #define ANOMALY_05000248 (0)
 #define ANOMALY_05000266 (0)
@@ -195,5 +198,7 @@
 #define ANOMALY_05000448 (0)
 #define ANOMALY_05000456 (0)
 #define ANOMALY_05000450 (0)
+#define ANOMALY_05000465 (0)
+#define ANOMALY_05000467 (0)
 
 #endif
diff --git a/arch/blackfin/mach-bf538/include/mach/anomaly.h b/arch/blackfin/mach-bf538/include/mach/anomaly.h
index 175ca9e..c97acdf 100644
--- a/arch/blackfin/mach-bf538/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf538/include/mach/anomaly.h
@@ -30,13 +30,13 @@
 # define ANOMALY_BF539 0
 #endif
 
-/* Multi-issue instruction with dsp32shiftimm in slot1 and P-reg store in slot 2 not supported */
+/* Multi-Issue Instruction with dsp32shiftimm in slot1 and P-reg Store in slot2 Not Supported */
 #define ANOMALY_05000074 (1)
 /* DMA_RUN Bit Is Not Valid after a Peripheral Receive Channel DMA Stops */
 #define ANOMALY_05000119 (1)
 /* Rx.H Cannot Be Used to Access 16-bit System MMR Registers */
 #define ANOMALY_05000122 (1)
-/* PPI Data Lengths Between 8 and 16 Do Not Zero Out Upper Bits */
+/* PPI Data Lengths between 8 and 16 Do Not Zero Out Upper Bits */
 #define ANOMALY_05000166 (1)
 /* PPI_COUNT Cannot Be Programmed to 0 in General Purpose TX or RX Modes */
 #define ANOMALY_05000179 (1)
@@ -70,11 +70,11 @@
 #define ANOMALY_05000277 (__SILICON_REVISION__ < 4)
 /* Disabling Peripherals with DMA Running May Cause DMA System Instability */
 #define ANOMALY_05000278 (__SILICON_REVISION__ < 4)
-/* False Hardware Error Exception When ISR Context Is Not Restored */
+/* False Hardware Error Exception when ISR Context Is Not Restored */
 #define ANOMALY_05000281 (__SILICON_REVISION__ < 4)
 /* Memory DMA Corruption with 32-Bit Data and Traffic Control */
 #define ANOMALY_05000282 (__SILICON_REVISION__ < 4)
-/* System MMR Write Is Stalled Indefinitely When Killed in a Particular Stage */
+/* System MMR Write Is Stalled Indefinitely when Killed in a Particular Stage */
 #define ANOMALY_05000283 (__SILICON_REVISION__ < 4)
 /* SPORTs May Receive Bad Data If FIFOs Fill Up */
 #define ANOMALY_05000288 (__SILICON_REVISION__ < 4)
@@ -92,11 +92,11 @@
 #define ANOMALY_05000307 (__SILICON_REVISION__ < 4)
 /* False Hardware Errors Caused by Fetches at the Boundary of Reserved Memory */
 #define ANOMALY_05000310 (1)
-/* Errors When SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are Interrupted */
+/* Errors when SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are Interrupted */
 #define ANOMALY_05000312 (__SILICON_REVISION__ < 5)
 /* PPI Is Level-Sensitive on First Transfer In Single Frame Sync Modes */
 #define ANOMALY_05000313 (__SILICON_REVISION__ < 4)
-/* Killed System MMR Write Completes Erroneously On Next System MMR Access */
+/* Killed System MMR Write Completes Erroneously on Next System MMR Access */
 #define ANOMALY_05000315 (__SILICON_REVISION__ < 4)
 /* PFx Glitch on Write to FIO_FLAG_D or FIO_FLAG_T */
 #define ANOMALY_05000318 (ANOMALY_BF539 && __SILICON_REVISION__ < 4)
@@ -110,7 +110,7 @@
 #define ANOMALY_05000371 (__SILICON_REVISION__ < 5)
 /* Entering Hibernate State with Peripheral Wakeups Enabled Draws Excess Current */
 #define ANOMALY_05000374 (__SILICON_REVISION__ == 4)
-/* New Feature: Open-Drain GPIO Outputs on PC1 and PC4 (Not Available on Older Silicon) */
+/* GPIO Pins PC1 and PC4 Can Function as Normal Outputs */
 #define ANOMALY_05000375 (__SILICON_REVISION__ < 4)
 /* SSYNC Stalls Processor when Executed from Non-Cacheable Memory */
 #define ANOMALY_05000402 (__SILICON_REVISION__ < 4)
@@ -126,26 +126,32 @@
 #define ANOMALY_05000436 (__SILICON_REVISION__ > 3)
 /* IFLUSH Instruction at End of Hardware Loop Causes Infinite Stall */
 #define ANOMALY_05000443 (1)
-/* False Hardware Error when RETI points to invalid memory */
+/* False Hardware Error when RETI Points to Invalid Memory */
 #define ANOMALY_05000461 (1)
 
 /* Anomalies that don't exist on this proc */
 #define ANOMALY_05000099 (0)
 #define ANOMALY_05000120 (0)
+#define ANOMALY_05000125 (0)
 #define ANOMALY_05000149 (0)
 #define ANOMALY_05000158 (0)
 #define ANOMALY_05000171 (0)
+#define ANOMALY_05000182 (0)
 #define ANOMALY_05000198 (0)
+#define ANOMALY_05000202 (0)
 #define ANOMALY_05000215 (0)
 #define ANOMALY_05000220 (0)
 #define ANOMALY_05000227 (0)
 #define ANOMALY_05000230 (0)
 #define ANOMALY_05000231 (0)
+#define ANOMALY_05000234 (0)
 #define ANOMALY_05000242 (0)
 #define ANOMALY_05000248 (0)
 #define ANOMALY_05000250 (0)
 #define ANOMALY_05000254 (0)
+#define ANOMALY_05000257 (0)
 #define ANOMALY_05000263 (0)
+#define ANOMALY_05000266 (0)
 #define ANOMALY_05000274 (0)
 #define ANOMALY_05000287 (0)
 #define ANOMALY_05000305 (0)
@@ -166,5 +172,7 @@
 #define ANOMALY_05000448 (0)
 #define ANOMALY_05000456 (0)
 #define ANOMALY_05000450 (0)
+#define ANOMALY_05000465 (0)
+#define ANOMALY_05000467 (0)
 
 #endif
diff --git a/arch/blackfin/mach-bf548/include/mach/anomaly.h b/arch/blackfin/mach-bf548/include/mach/anomaly.h
index c510ae6..18a4cd2 100644
--- a/arch/blackfin/mach-bf548/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf548/include/mach/anomaly.h
@@ -18,7 +18,7 @@
 # error will not work on BF548 silicon version 0.0, or 0.1
 #endif
 
-/* Multi-issue instruction with dsp32shiftimm in slot1 and P-reg store in slot 2 not supported */
+/* Multi-Issue Instruction with dsp32shiftimm in slot1 and P-reg Store in slot2 Not Supported */
 #define ANOMALY_05000074 (1)
 /* DMA_RUN Bit Is Not Valid after a Peripheral Receive Channel DMA Stops */
 #define ANOMALY_05000119 (1)
@@ -30,17 +30,17 @@
 #define ANOMALY_05000265 (1)
 /* Certain Data Cache Writethrough Modes Fail for Vddint <= 0.9V */
 #define ANOMALY_05000272 (1)
-/* False Hardware Error Exception When ISR Context Is Not Restored */
+/* False Hardware Error Exception when ISR Context Is Not Restored */
 #define ANOMALY_05000281 (__SILICON_REVISION__ < 1)
 /* SSYNCs After Writes To CAN/DMA MMR Registers Are Not Always Handled Correctly */
 #define ANOMALY_05000304 (__SILICON_REVISION__ < 1)
 /* False Hardware Errors Caused by Fetches at the Boundary of Reserved Memory */
 #define ANOMALY_05000310 (1)
-/* Errors When SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are Interrupted */
+/* Errors when SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are Interrupted */
 #define ANOMALY_05000312 (__SILICON_REVISION__ < 1)
 /* TWI Slave Boot Mode Is Not Functional */
 #define ANOMALY_05000324 (__SILICON_REVISION__ < 1)
-/* External FIFO Boot Mode Is Not Functional */
+/* FIFO Boot Mode Not Functional */
 #define ANOMALY_05000325 (__SILICON_REVISION__ < 2)
 /* Data Lost When Core and DMA Accesses Are Made to the USB FIFO Simultaneously */
 #define ANOMALY_05000327 (__SILICON_REVISION__ < 1)
@@ -178,8 +178,12 @@
 #define ANOMALY_05000450 (1)
 /* USB Receive Interrupt Is Not Generated in DMA Mode 1 */
 #define ANOMALY_05000456 (__SILICON_REVISION__ < 3)
-/* False Hardware Error when RETI points to invalid memory */
+/* False Hardware Error when RETI Points to Invalid Memory */
 #define ANOMALY_05000461 (1)
+/* USB Rx DMA hang */
+#define ANOMALY_05000465 (1)
+/* Possible RX data corruption when control & data EP FIFOs are accessed via the core */
+#define ANOMALY_05000467 (1)
 
 /* Anomalies that don't exist on this proc */
 #define ANOMALY_05000099 (0)
@@ -189,30 +193,36 @@
 #define ANOMALY_05000158 (0)
 #define ANOMALY_05000171 (0)
 #define ANOMALY_05000179 (0)
+#define ANOMALY_05000182 (0)
 #define ANOMALY_05000183 (0)
 #define ANOMALY_05000198 (0)
+#define ANOMALY_05000202 (0)
 #define ANOMALY_05000215 (0)
 #define ANOMALY_05000220 (0)
 #define ANOMALY_05000227 (0)
 #define ANOMALY_05000230 (0)
 #define ANOMALY_05000231 (0)
 #define ANOMALY_05000233 (0)
+#define ANOMALY_05000234 (0)
 #define ANOMALY_05000242 (0)
 #define ANOMALY_05000244 (0)
 #define ANOMALY_05000248 (0)
 #define ANOMALY_05000250 (0)
 #define ANOMALY_05000254 (0)
+#define ANOMALY_05000257 (0)
 #define ANOMALY_05000261 (0)
 #define ANOMALY_05000263 (0)
 #define ANOMALY_05000266 (0)
 #define ANOMALY_05000273 (0)
 #define ANOMALY_05000274 (0)
 #define ANOMALY_05000278 (0)
+#define ANOMALY_05000283 (0)
 #define ANOMALY_05000287 (0)
 #define ANOMALY_05000301 (0)
 #define ANOMALY_05000305 (0)
 #define ANOMALY_05000307 (0)
 #define ANOMALY_05000311 (0)
+#define ANOMALY_05000315 (0)
 #define ANOMALY_05000323 (0)
 #define ANOMALY_05000362 (1)
 #define ANOMALY_05000363 (0)
diff --git a/arch/blackfin/mach-bf561/include/mach/anomaly.h b/arch/blackfin/mach-bf561/include/mach/anomaly.h
index dccd396..94b8e27 100644
--- a/arch/blackfin/mach-bf561/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf561/include/mach/anomaly.h
@@ -18,19 +18,19 @@
 # error will not work on BF561 silicon version 0.0, 0.1, 0.2, or 0.4
 #endif
 
-/* Multi-issue instruction with dsp32shiftimm in slot1 and P-reg store in slot 2 not supported */
+/* Multi-Issue Instruction with dsp32shiftimm in slot1 and P-reg Store in slot2 Not Supported */
 #define ANOMALY_05000074 (1)
 /* UART Line Status Register (UART_LSR) Bits Are Not Updated at the Same Time */
 #define ANOMALY_05000099 (__SILICON_REVISION__ < 5)
-/* Trace Buffers may record discontinuities into emulation mode and/or exception, NMI, reset handlers */
+/* Trace Buffers May Contain Errors in Emulation Mode and/or Exception, NMI, Reset Handlers */
 #define ANOMALY_05000116 (__SILICON_REVISION__ < 3)
-/* Testset instructions restricted to 32-bit aligned memory locations */
+/* TESTSET Instructions Restricted to 32-Bit Aligned Memory Locations */
 #define ANOMALY_05000120 (1)
 /* Rx.H Cannot Be Used to Access 16-bit System MMR Registers */
 #define ANOMALY_05000122 (1)
-/* Erroneous exception when enabling cache */
+/* Erroneous Exception when Enabling Cache */
 #define ANOMALY_05000125 (__SILICON_REVISION__ < 3)
-/* Signbits instruction not functional under certain conditions */
+/* SIGNBITS Instruction Not Functional under Certain Conditions */
 #define ANOMALY_05000127 (1)
 /* Two bits in the Watchpoint Status Register (WPSTAT) are swapped */
 #define ANOMALY_05000134 (__SILICON_REVISION__ < 3)
@@ -40,7 +40,7 @@
 #define ANOMALY_05000136 (__SILICON_REVISION__ < 3)
 /* Allowing the SPORT RX FIFO to fill will cause an overflow */
 #define ANOMALY_05000140 (__SILICON_REVISION__ < 3)
-/* An Infinite Stall occurs with a particular sequence of consecutive dual dag events */
+/* Infinite Stall may occur with a particular sequence of consecutive dual dag events */
 #define ANOMALY_05000141 (__SILICON_REVISION__ < 3)
 /* Interrupts may be lost when a programmable input flag is configured to be edge sensitive */
 #define ANOMALY_05000142 (__SILICON_REVISION__ < 3)
@@ -52,7 +52,7 @@
 #define ANOMALY_05000146 (__SILICON_REVISION__ < 3)
 /* Source MDMA descriptor may stop with a DMA Error near beginning of descriptor fetch */
 #define ANOMALY_05000147 (__SILICON_REVISION__ < 3)
-/* IMDMA S1/D1 channel may stall */
+/* IMDMA S1/D1 Channel May Stall */
 #define ANOMALY_05000149 (1)
 /* DMA engine may lose data due to incorrect handshaking */
 #define ANOMALY_05000150 (__SILICON_REVISION__ < 3)
@@ -66,7 +66,7 @@
 #define ANOMALY_05000154 (__SILICON_REVISION__ < 3)
 /* Timers in PWM-Out Mode with PPI GP Receive (Input) Mode with 0 Frame Syncs */
 #define ANOMALY_05000156 (__SILICON_REVISION__ < 4)
-/* Killed 32-bit MMR write leads to next system MMR access thinking it should be 32-bit */
+/* Killed 32-Bit MMR Write Leads to Next System MMR Access Thinking It Should Be 32-Bit */
 #define ANOMALY_05000157 (__SILICON_REVISION__ < 3)
 /* DMA Lock-up at CCLK to SCLK ratios of 4:1, 2:1, or 1:1 */
 #define ANOMALY_05000159 (__SILICON_REVISION__ < 3)
@@ -76,17 +76,17 @@
 #define ANOMALY_05000161 (__SILICON_REVISION__ < 3)
 /* DMEM_CONTROL<12> is not set on Reset */
 #define ANOMALY_05000162 (__SILICON_REVISION__ < 3)
-/* SPORT transmit data is not gated by external frame sync in certain conditions */
+/* SPORT Transmit Data Is Not Gated by External Frame Sync in Certain Conditions */
 #define ANOMALY_05000163 (__SILICON_REVISION__ < 3)
-/* PPI Data Lengths Between 8 and 16 Do Not Zero Out Upper Bits */
+/* PPI Data Lengths between 8 and 16 Do Not Zero Out Upper Bits */
 #define ANOMALY_05000166 (1)
 /* Turning SPORTs on while External Frame Sync Is Active May Corrupt Data */
 #define ANOMALY_05000167 (1)
-/* SDRAM auto-refresh and subsequent Power Ups */
+/* Undefined Behavior when Power-Up Sequence Is Issued to SDRAM during Auto-Refresh */
 #define ANOMALY_05000168 (__SILICON_REVISION__ < 5)
-/* DATA CPLB page miss can result in lost write-through cache data writes */
+/* DATA CPLB Page Miss Can Result in Lost Write-Through Data Cache Writes */
 #define ANOMALY_05000169 (__SILICON_REVISION__ < 5)
-/* Boot-ROM code modifies SICA_IWRx wakeup registers */
+/* Boot-ROM Modifies SICA_IWRx Wakeup Registers */
 #define ANOMALY_05000171 (__SILICON_REVISION__ < 5)
 /* DSPID register values incorrect */
 #define ANOMALY_05000172 (__SILICON_REVISION__ < 3)
@@ -96,29 +96,29 @@
 #define ANOMALY_05000174 (__SILICON_REVISION__ < 5)
 /* Overlapping Sequencer and Memory Stalls */
 #define ANOMALY_05000175 (__SILICON_REVISION__ < 5)
-/* Multiplication of (-1) by (-1) followed by an accumulator saturation */
+/* Overflow Bit Asserted when Multiplication of -1 by -1 Followed by Accumulator Saturation */
 #define ANOMALY_05000176 (__SILICON_REVISION__ < 5)
 /* PPI_COUNT Cannot Be Programmed to 0 in General Purpose TX or RX Modes */
 #define ANOMALY_05000179 (__SILICON_REVISION__ < 5)
 /* PPI_DELAY Not Functional in PPI Modes with 0 Frame Syncs */
 #define ANOMALY_05000180 (1)
-/* Disabling the PPI resets the PPI configuration registers */
+/* Disabling the PPI Resets the PPI Configuration Registers */
 #define ANOMALY_05000181 (__SILICON_REVISION__ < 5)
-/* IMDMA does not operate to full speed for 600MHz and higher devices */
+/* Internal Memory DMA Does Not Operate at Full Speed */
 #define ANOMALY_05000182 (1)
-/* Timer Pin limitations for PPI TX Modes with External Frame Syncs */
+/* Timer Pin Limitations for PPI TX Modes with External Frame Syncs */
 #define ANOMALY_05000184 (__SILICON_REVISION__ < 5)
-/* PPI TX Mode with 2 External Frame Syncs */
+/* Early PPI Transmit when FS1 Asserts before FS2 in TX Mode with 2 External Frame Syncs */
 #define ANOMALY_05000185 (__SILICON_REVISION__ < 5)
-/* PPI packing with Data Length greater than 8 bits (not a meaningful mode) */
+/* Upper PPI Pins Driven when PPI Packing Enabled and Data Length >8 Bits */
 #define ANOMALY_05000186 (__SILICON_REVISION__ < 5)
 /* IMDMA Corrupted Data after a Halt */
 #define ANOMALY_05000187 (1)
 /* IMDMA Restrictions on Descriptor and Buffer Placement in Memory */
 #define ANOMALY_05000188 (__SILICON_REVISION__ < 5)
-/* False Protection Exceptions */
+/* False Protection Exceptions when Speculative Fetch Is Cancelled */
 #define ANOMALY_05000189 (__SILICON_REVISION__ < 5)
-/* PPI not functional at core voltage < 1Volt */
+/* PPI Not Functional at Core Voltage < 1Volt */
 #define ANOMALY_05000190 (1)
 /* PPI does not invert the Driving PPICLK edge in Transmit Modes */
 #define ANOMALY_05000191 (__SILICON_REVISION__ < 3)
@@ -126,7 +126,7 @@
 #define ANOMALY_05000193 (__SILICON_REVISION__ < 5)
 /* Restarting SPORT in Specific Modes May Cause Data Corruption */
 #define ANOMALY_05000194 (__SILICON_REVISION__ < 5)
-/* Failing MMR Accesses When Stalled by Preceding Memory Read */
+/* Failing MMR Accesses when Preceding Memory Read Stalls */
 #define ANOMALY_05000198 (__SILICON_REVISION__ < 5)
 /* Current DMA Address Shows Wrong Value During Carry Fix */
 #define ANOMALY_05000199 (__SILICON_REVISION__ < 5)
@@ -134,9 +134,9 @@
 #define ANOMALY_05000200 (__SILICON_REVISION__ < 5)
 /* Possible Infinite Stall with Specific Dual-DAG Situation */
 #define ANOMALY_05000202 (__SILICON_REVISION__ < 5)
-/* Incorrect data read with write-through cache and allocate cache lines on reads only mode */
+/* Incorrect Data Read with Writethrough "Allocate Cache Lines on Reads Only" Cache Mode */
 #define ANOMALY_05000204 (__SILICON_REVISION__ < 5)
-/* Specific sequence that can cause DMA error or DMA stopping */
+/* Specific Sequence that Can Cause DMA Error or DMA Stopping */
 #define ANOMALY_05000205 (__SILICON_REVISION__ < 5)
 /* Recovery from "Brown-Out" Condition */
 #define ANOMALY_05000207 (__SILICON_REVISION__ < 5)
@@ -158,7 +158,7 @@
 #define ANOMALY_05000230 (__SILICON_REVISION__ < 5)
 /* UART STB Bit Incorrectly Affects Receiver Setting */
 #define ANOMALY_05000231 (__SILICON_REVISION__ < 5)
-/* SPORT data transmit lines are incorrectly driven in multichannel mode */
+/* SPORT Data Transmit Lines Are Incorrectly Driven in Multichannel Mode */
 #define ANOMALY_05000232 (__SILICON_REVISION__ < 5)
 /* DF Bit in PLL_CTL Register Does Not Respond to Hardware Reset */
 #define ANOMALY_05000242 (__SILICON_REVISION__ < 5)
@@ -166,7 +166,7 @@
 #define ANOMALY_05000244 (__SILICON_REVISION__ < 5)
 /* False Hardware Error from an Access in the Shadow of a Conditional Branch */
 #define ANOMALY_05000245 (__SILICON_REVISION__ < 5)
-/* TESTSET operation forces stall on the other core */
+/* TESTSET Operation Forces Stall on the Other Core */
 #define ANOMALY_05000248 (__SILICON_REVISION__ < 5)
 /* Incorrect Bit Shift of Data Word in Multichannel (TDM) Mode in Certain Conditions */
 #define ANOMALY_05000250 (__SILICON_REVISION__ > 2 && __SILICON_REVISION__ < 5)
@@ -192,9 +192,9 @@
 #define ANOMALY_05000264 (__SILICON_REVISION__ < 5)
 /* Sensitivity To Noise with Slow Input Edge Rates on External SPORT TX and RX Clocks */
 #define ANOMALY_05000265 (__SILICON_REVISION__ < 5)
-/* IMDMA destination IRQ status must be read prior to using IMDMA */
+/* IMDMA Destination IRQ Status Must Be Read Prior to Using IMDMA */
 #define ANOMALY_05000266 (__SILICON_REVISION__ > 3)
-/* IMDMA may corrupt data under certain conditions */
+/* IMDMA May Corrupt Data under Certain Conditions */
 #define ANOMALY_05000267 (1)
 /* High I/O Activity Causes Output Voltage of Internal Voltage Regulator (Vddint) to Increase */
 #define ANOMALY_05000269 (1)
@@ -202,7 +202,7 @@
 #define ANOMALY_05000270 (1)
 /* Certain Data Cache Writethrough Modes Fail for Vddint <= 0.9V */
 #define ANOMALY_05000272 (1)
-/* Data cache write back to external synchronous memory may be lost */
+/* Data Cache Write Back to External Synchronous Memory May Be Lost */
 #define ANOMALY_05000274 (1)
 /* PPI Timing and Sampling Information Updates */
 #define ANOMALY_05000275 (__SILICON_REVISION__ > 2)
@@ -212,17 +212,17 @@
 #define ANOMALY_05000277 (__SILICON_REVISION__ < 3)
 /* Disabling Peripherals with DMA Running May Cause DMA System Instability */
 #define ANOMALY_05000278 (__SILICON_REVISION__ < 5)
-/* False Hardware Error Exception When ISR Context Is Not Restored */
+/* False Hardware Error Exception when ISR Context Is Not Restored */
 #define ANOMALY_05000281 (__SILICON_REVISION__ < 5)
-/* System MMR Write Is Stalled Indefinitely When Killed in a Particular Stage */
+/* System MMR Write Is Stalled Indefinitely when Killed in a Particular Stage */
 #define ANOMALY_05000283 (1)
-/* A read will receive incorrect data under certain conditions */
+/* Reads Will Receive Incorrect Data under Certain Conditions */
 #define ANOMALY_05000287 (__SILICON_REVISION__ < 5)
 /* SPORTs May Receive Bad Data If FIFOs Fill Up */
 #define ANOMALY_05000288 (__SILICON_REVISION__ < 5)
 /* Memory-To-Memory DMA Source/Destination Descriptors Must Be in Same Memory Space */
 #define ANOMALY_05000301 (1)
-/* SSYNCs After Writes To DMA MMR Registers May Not Be Handled Correctly */
+/* SSYNCs after Writes to DMA MMR Registers May Not Be Handled Correctly */
 #define ANOMALY_05000302 (1)
 /* SPORT_HYS Bit in PLL_CTL Register Is Not Functional */
 #define ANOMALY_05000305 (__SILICON_REVISION__ < 5)
@@ -230,25 +230,25 @@
 #define ANOMALY_05000307 (__SILICON_REVISION__ < 5)
 /* False Hardware Errors Caused by Fetches at the Boundary of Reserved Memory */
 #define ANOMALY_05000310 (1)
-/* Errors When SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are Interrupted */
+/* Errors when SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are Interrupted */
 #define ANOMALY_05000312 (1)
 /* PPI Is Level-Sensitive on First Transfer In Single Frame Sync Modes */
 #define ANOMALY_05000313 (1)
-/* Killed System MMR Write Completes Erroneously On Next System MMR Access */
+/* Killed System MMR Write Completes Erroneously on Next System MMR Access */
 #define ANOMALY_05000315 (1)
-/* PF2 Output Remains Asserted After SPI Master Boot */
+/* PF2 Output Remains Asserted after SPI Master Boot */
 #define ANOMALY_05000320 (__SILICON_REVISION__ > 3)
-/* Erroneous GPIO Flag Pin Operations Under Specific Sequences */
+/* Erroneous GPIO Flag Pin Operations under Specific Sequences */
 #define ANOMALY_05000323 (1)
-/* SPORT Secondary Receive Channel Not Functional When Word Length Exceeds 16 Bits */
+/* SPORT Secondary Receive Channel Not Functional when Word Length >16 Bits */
 #define ANOMALY_05000326 (__SILICON_REVISION__ > 3)
-/* New Feature: 24-Bit SPI Boot Mode Support (Not Available On Older Silicon) */
+/* 24-Bit SPI Boot Mode Is Not Functional */
 #define ANOMALY_05000331 (__SILICON_REVISION__ < 5)
-/* New Feature: Slave SPI Boot Mode Supported (Not Available On Older Silicon) */
+/* Slave SPI Boot Mode Is Not Functional */
 #define ANOMALY_05000332 (__SILICON_REVISION__ < 5)
-/* Flag Data Register Writes One SCLK Cycle After Edge Is Detected May Clear Interrupt Status */
+/* Flag Data Register Writes One SCLK Cycle after Edge Is Detected May Clear Interrupt Status */
 #define ANOMALY_05000333 (__SILICON_REVISION__ < 5)
-/* New Feature: Additional PPI Frame Sync Sampling Options (Not Available on Older Silicon) */
+/* ALT_TIMING Bit in PLL_CTL Register Is Not Functional */
 #define ANOMALY_05000339 (__SILICON_REVISION__ < 5)
 /* Memory DMA FIFO Causes Throughput Degradation on Writes to External Memory */
 #define ANOMALY_05000343 (__SILICON_REVISION__ < 5)
@@ -276,7 +276,7 @@
 #define ANOMALY_05000428 (__SILICON_REVISION__ > 3)
 /* IFLUSH Instruction at End of Hardware Loop Causes Infinite Stall */
 #define ANOMALY_05000443 (1)
-/* False Hardware Error when RETI points to invalid memory */
+/* False Hardware Error when RETI Points to Invalid Memory */
 #define ANOMALY_05000461 (1)
 
 /* Anomalies that don't exist on this proc */
@@ -284,6 +284,7 @@
 #define ANOMALY_05000158 (0)
 #define ANOMALY_05000183 (0)
 #define ANOMALY_05000233 (0)
+#define ANOMALY_05000234 (0)
 #define ANOMALY_05000273 (0)
 #define ANOMALY_05000311 (0)
 #define ANOMALY_05000353 (1)
@@ -298,5 +299,7 @@
 #define ANOMALY_05000448 (0)
 #define ANOMALY_05000456 (0)
 #define ANOMALY_05000450 (0)
+#define ANOMALY_05000465 (0)
+#define ANOMALY_05000467 (0)
 
 #endif
-- 
1.6.3.1

