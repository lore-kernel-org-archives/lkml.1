Return-Path: <linux-kernel-owner+w=401wt.eu-S1762067AbXE1Ii6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762067AbXE1Ii6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761333AbXE1Igm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:36:42 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:31495 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759086AbXE1Ige (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:36:34 -0400
X-IronPort-AV: i="4.14,586,1170651600"; 
   d="scan'208"; a="40300049:sNHT33760594"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Roy Huang <roy.huang@analog.com>, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 08/20] Blackfin arch: Add header files for BF548
Date: Mon, 28 May 2007 16:37:43 +0800
Message-Id: <11803414781100-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11803414753217-git-send-email-bryan.wu@analog.com>
References: <11803414753217-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roy Huang <roy.huang@analog.com>

Signed-off-by: Roy Huang <roy.huang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 include/asm-blackfin/mach-bf548/anomaly.h         |   72 +++++
 include/asm-blackfin/mach-bf548/bf548.h           |  284 +++++++++++++++++++
 include/asm-blackfin/mach-bf548/bfin_serial_5xx.h |  147 ++++++++++
 include/asm-blackfin/mach-bf548/blackfin.h        |  166 +++++++++++
 include/asm-blackfin/mach-bf548/dma.h             |   63 +++++
 include/asm-blackfin/mach-bf548/irq.h             |  306 +++++++++++++++++++++
 include/asm-blackfin/mach-bf548/mem_init.h        |  189 +++++++++++++
 include/asm-blackfin/mach-bf548/mem_map.h         |   97 +++++++
 8 files changed, 1324 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-blackfin/mach-bf548/anomaly.h
 create mode 100644 include/asm-blackfin/mach-bf548/bf548.h
 create mode 100644 include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
 create mode 100644 include/asm-blackfin/mach-bf548/blackfin.h
 create mode 100644 include/asm-blackfin/mach-bf548/dma.h
 create mode 100644 include/asm-blackfin/mach-bf548/irq.h
 create mode 100644 include/asm-blackfin/mach-bf548/mem_init.h
 create mode 100644 include/asm-blackfin/mach-bf548/mem_map.h

diff --git a/include/asm-blackfin/mach-bf548/anomaly.h b/include/asm-blackfin/mach-bf548/anomaly.h
new file mode 100644
index 0000000..e3af815
--- /dev/null
+++ b/include/asm-blackfin/mach-bf548/anomaly.h
@@ -0,0 +1,72 @@
+
+/*
+ * File:         include/asm-blackfin/mach-bf548/anomaly.h
+ * Based on:
+ * Author:
+ *
+ * Created:
+ * Description:
+ *
+ * Rev:
+ *
+ * Modified:
+ *
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.
+ * If not, write to the Free Software Foundation,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef _MACH_ANOMALY_H_
+#define _MACH_ANOMALY_H_
+#define ANOMALY_05000074 /* A multi issue instruction with dsp32shiftimm in
+			    slot1 and store of a P register in slot 2 is not
+			    supported */
+#define ANOMALY_05000119 /* DMA_RUN bit is not valid after a Peripheral Receive
+			    Channel DMA stops */
+#define ANOMALY_05000122 /* Rx.H can not be used to access 16-bit System MMR
+			    registers. */
+#define ANOMALY_05000245 /* Spurious Hardware Error from an Access in the 
+			    Shadow of a Conditional Branch */
+#define ANOMALY_05000255 /* Entering Hibernate Mode with RTC Seconds event
+			    interrupt not functional */
+#define ANOMALY_05000265 /* Sensitivity to noise with slow input edge rates on
+			    SPORT external receive and transmit clocks. */
+#define ANOMALY_05000272 /* Certain data cache write through modes fail for
+			    VDDint <=0.9V */
+#define ANOMALY_05000310 /* False Hardware Errors Caused by Fetches at the 
+			    Boundary of Reserved Memory */
+#define ANOMALY_05000312 /* Errors When SSYNC, CSYNC, or Loads to LT, LB and
+			    LC Registers Are Interrupted */
+#define ANOMALY_05000324 /* TWI Slave Boot Mode Is Not Functional */
+#define ANOMALY_05000325 /* External FIFO Boot Mode Is Not Functional */
+#define ANOMALY_05000327 /* Data Lost When Core and DMA Accesses Are Made to
+			    the USB FIFO Simultaneously */
+#define ANOMALY_05000328 /* Incorrect Access of OTP_STATUS During otp_write()
+			    function */
+#define ANOMALY_05000329 /* Synchronous Burst Flash Boot Mode Is Not Functional
+			    */
+#define ANOMALY_05000330 /* Host DMA Boot Mode Is Not Functional */
+#define ANOMALY_05000334 /* Inadequate Timing Margins on DDR DQS to DQ and DQM
+			    Skew */
+#define ANOMALY_05000335 /* Inadequate Rotary Debounce Logic Duration */
+#define ANOMALY_05000336 /* Phantom Interrupt Occurs After First Configuration
+			    of Host DMA Port */
+#define ANOMALY_05000337 /* Disallowed Configuration Prevents Subsequent
+			    Allowed Configuration on Host DMA Port */
+#define ANOMALY_05000338 /* Slave-Mode SPI0 MISO Failure With CPHA = 0 */
+
+#endif /* _MACH_ANOMALY_H_ */
diff --git a/include/asm-blackfin/mach-bf548/bf548.h b/include/asm-blackfin/mach-bf548/bf548.h
new file mode 100644
index 0000000..0b21102
--- /dev/null
+++ b/include/asm-blackfin/mach-bf548/bf548.h
@@ -0,0 +1,284 @@
+/*
+ * File:         include/asm-blackfin/mach-bf548/bf548.h
+ * Based on:
+ * Author:
+ *
+ * Created:
+ * Description:  System MMR register and memory map for ADSP-BF548
+ *
+ * Modified:
+ *               Copyright 2004-2007 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#ifndef __MACH_BF548_H__
+#define __MACH_BF548_H__
+
+/* Masks for generic ERROR IRQ demultiplexing used in int-priority-sc.c */
+
+#define SPI_ERR_MASK (TXCOL | RBSY | MODF | TXE)	/* SPI_STAT */
+#define SPORT_ERR_MASK (ROVF | RUVF | TOVF | TUVF)	/* SPORTx_STAT */
+#define PPI_ERR_MASK (0xFFFF & ~FLD)	/* PPI_STATUS */
+#define UART_ERR_MASK_STAT1 (0x4)	/* UARTx_IIR */
+#define UART_ERR_MASK_STAT0 (0x2)	/* UARTx_IIR */
+#define CAN_ERR_MASK  (EWTIF | EWRIF | EPIF | BOIF | WUIF | UIAIF | AAIF | \
+		RMLIF | UCEIF | EXTIF | ADIF)	/* CAN_GIF */
+
+#define OFFSET_(x) ((x) & 0x0000FFFF)
+
+/*some misc defines*/
+#define IMASK_IVG15		0x8000
+#define IMASK_IVG14		0x4000
+#define IMASK_IVG13		0x2000
+#define IMASK_IVG12		0x1000
+
+#define IMASK_IVG11		0x0800
+#define IMASK_IVG10		0x0400
+#define IMASK_IVG9		0x0200
+#define IMASK_IVG8		0x0100
+
+#define IMASK_IVG7		0x0080
+#define IMASK_IVGTMR	0x0040
+#define IMASK_IVGHW		0x0020
+
+/***************************/
+
+
+#define BLKFIN_DSUBBANKS	4
+#define BLKFIN_DWAYS		2
+#define BLKFIN_DLINES		64
+#define BLKFIN_ISUBBANKS	4
+#define BLKFIN_IWAYS		4
+#define BLKFIN_ILINES		32
+
+#define WAY0_L			0x1
+#define WAY1_L			0x2
+#define WAY01_L			0x3
+#define WAY2_L			0x4
+#define WAY02_L			0x5
+#define	WAY12_L			0x6
+#define	WAY012_L		0x7
+
+#define	WAY3_L			0x8
+#define	WAY03_L			0x9
+#define	WAY13_L			0xA
+#define	WAY013_L		0xB
+
+#define	WAY32_L			0xC
+#define	WAY320_L		0xD
+#define	WAY321_L		0xE
+#define	WAYALL_L		0xF
+
+#define DMC_ENABLE (2<<2)	/*yes, 2, not 1 */
+
+/********************************* EBIU Settings ************************************/
+#define AMBCTL0VAL	((CONFIG_BANK_1 << 16) | CONFIG_BANK_0)
+#define AMBCTL1VAL	((CONFIG_BANK_3 << 16) | CONFIG_BANK_2)
+
+#ifdef CONFIG_C_AMBEN_ALL
+#define V_AMBEN AMBEN_ALL
+#endif
+#ifdef CONFIG_C_AMBEN
+#define V_AMBEN 0x0
+#endif
+#ifdef CONFIG_C_AMBEN_B0
+#define V_AMBEN AMBEN_B0
+#endif
+#ifdef CONFIG_C_AMBEN_B0_B1
+#define V_AMBEN AMBEN_B0_B1
+#endif
+#ifdef CONFIG_C_AMBEN_B0_B1_B2
+#define V_AMBEN AMBEN_B0_B1_B2
+#endif
+#ifdef CONFIG_C_AMCKEN
+#define V_AMCKEN AMCKEN
+#else
+#define V_AMCKEN 0x0
+#endif
+#ifdef CONFIG_C_CDPRIO
+#define V_CDPRIO 0x100
+#else
+#define V_CDPRIO 0x0
+#endif
+
+#define AMGCTLVAL	(V_AMBEN | V_AMCKEN | V_CDPRIO)
+
+#define MAX_VC	650000000
+#define MIN_VC	50000000
+
+/********************************PLL Settings **************************************/
+#ifdef CONFIG_BFIN_KERNEL_CLOCK
+#if (CONFIG_VCO_MULT < 0)
+#error "VCO Multiplier is less than 0. Please select a different value"
+#endif
+
+#if (CONFIG_VCO_MULT == 0)
+#error "VCO Multiplier should be greater than 0. Please select a different value"
+#endif
+
+#if (CONFIG_VCO_MULT > 64)
+#error "VCO Multiplier is more than 64. Please select a different value"
+#endif
+
+#ifndef CONFIG_CLKIN_HALF
+#define CONFIG_VCO_HZ	(CONFIG_CLKIN_HZ * CONFIG_VCO_MULT)
+#else
+#define CONFIG_VCO_HZ	((CONFIG_CLKIN_HZ * CONFIG_VCO_MULT)/2)
+#endif
+
+#ifndef CONFIG_PLL_BYPASS
+#define CONFIG_CCLK_HZ	(CONFIG_VCO_HZ/CONFIG_CCLK_DIV)
+#define CONFIG_SCLK_HZ	(CONFIG_VCO_HZ/CONFIG_SCLK_DIV)
+#else
+#define CONFIG_CCLK_HZ	CONFIG_CLKIN_HZ
+#define CONFIG_SCLK_HZ	CONFIG_CLKIN_HZ
+#endif
+
+#if (CONFIG_SCLK_DIV < 1)
+#error "SCLK DIV cannot be less than 1 or more than 15. Please select a proper value"
+#endif
+
+#if (CONFIG_SCLK_DIV > 15)
+#error "SCLK DIV cannot be less than 1 or more than 15. Please select a proper value"
+#endif
+
+#if (CONFIG_CCLK_DIV != 1)
+#if (CONFIG_CCLK_DIV != 2)
+#if (CONFIG_CCLK_DIV != 4)
+#if (CONFIG_CCLK_DIV != 8)
+#error "CCLK DIV can be 1,2,4 or 8 only. Please select a proper value"
+#endif
+#endif
+#endif
+#endif
+
+#if (CONFIG_VCO_HZ > MAX_VC)
+#error "VCO selected is more than maximum value. Please change the VCO multipler"
+#endif
+
+#if (CONFIG_SCLK_HZ > 133000000)
+#error "Sclk value selected is more than maximum. Please select a proper value for SCLK multiplier"
+#endif
+
+#if (CONFIG_SCLK_HZ < 27000000)
+#error "Sclk value selected is less than minimum. Please select a proper value for SCLK multiplier"
+#endif
+
+#if (CONFIG_SCLK_HZ >= CONFIG_CCLK_HZ)
+#if (CONFIG_SCLK_HZ != CONFIG_CLKIN_HZ)
+#if (CONFIG_CCLK_HZ != CONFIG_CLKIN_HZ)
+#error "Please select sclk less than cclk"
+#endif
+#endif
+#endif
+
+#if (CONFIG_CCLK_DIV == 1)
+#define CONFIG_CCLK_ACT_DIV   CCLK_DIV1
+#endif
+#if (CONFIG_CCLK_DIV == 2)
+#define CONFIG_CCLK_ACT_DIV   CCLK_DIV2
+#endif
+#if (CONFIG_CCLK_DIV == 4)
+#define CONFIG_CCLK_ACT_DIV   CCLK_DIV4
+#endif
+#if (CONFIG_CCLK_DIV == 8)
+#define CONFIG_CCLK_ACT_DIV   CCLK_DIV8
+#endif
+#ifndef CONFIG_CCLK_ACT_DIV
+#define CONFIG_CCLK_ACT_DIV   CONFIG_CCLK_DIV_not_defined_properly
+#endif
+
+#endif	/* CONFIG_BFIN_KERNEL_CLOCK */
+
+#ifdef CONFIG_BF542
+#define CPU "BF542"
+#define CPUID 0x027c8000
+#endif
+#ifdef CONFIG_BF544
+#define CPU "BF544"
+#define CPUID 0x027c8000
+#endif
+#ifdef CONFIG_BF548
+#define CPU "BF548"
+#define CPUID 0x027c6000
+#endif
+#ifdef CONFIG_BF549
+#define CPU "BF549"
+#endif
+#ifndef CPU
+#define	CPU "UNKNOWN"
+#define CPUID 0x0
+#endif
+
+#if (CONFIG_MEM_SIZE % 4)
+#error "SDRAM mem size must be multible of 4MB"
+#endif
+
+#define SDRAM_IGENERIC    (CPLB_L1_CHBL | CPLB_USER_RD | CPLB_VALID | CPLB_PORTPRIO)
+#define SDRAM_IKERNEL     (SDRAM_IGENERIC | CPLB_LOCK)
+#define L1_IMEMORY        (               CPLB_USER_RD | CPLB_VALID | CPLB_LOCK)
+#define SDRAM_INON_CHBL   (               CPLB_USER_RD | CPLB_VALID)
+
+/*Use the menuconfig cache policy here - CONFIG_BLKFIN_WT/CONFIG_BLKFIN_WB*/
+
+#define ANOMALY_05000158_WORKAROUND		0x200
+#ifdef CONFIG_BLKFIN_WB		/*Write Back Policy */
+#define SDRAM_DGENERIC   (CPLB_L1_CHBL | CPLB_DIRTY \
+			| CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND)
+#else				/*Write Through */
+#define SDRAM_DGENERIC   (CPLB_L1_CHBL | CPLB_WT | CPLB_L1_AOW \
+			| CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_DIRTY )
+#endif
+
+
+#define L1_DMEMORY       (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_LOCK | CPLB_DIRTY )
+#define SDRAM_DNON_CHBL  (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_DIRTY )
+#define SDRAM_EBIU       (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_DIRTY )
+#define SDRAM_OOPS  	 (CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_LOCK | CPLB_DIRTY )
+
+#define SIZE_1K 0x00000400	/* 1K */
+#define SIZE_4K 0x00001000	/* 4K */
+#define SIZE_1M 0x00100000	/* 1M */
+#define SIZE_4M 0x00400000	/* 4M */
+
+#define MAX_CPLBS (16 * 2)
+
+/*
+* Number of required data CPLB switchtable entries
+* MEMSIZE / 4 (we mostly install 4M page size CPLBs
+* approx 16 for smaller 1MB page size CPLBs for allignment purposes
+* 1 for L1 Data Memory
+* 1 for CONFIG_DEBUG_HUNT_FOR_ZERO
+* 1 for ASYNC Memory
+*/
+
+
+#define MAX_SWITCH_D_CPLBS (((CONFIG_MEM_SIZE / 4) + 16 + 1 + 1 + 1) * 2)
+
+/*
+* Number of required instruction CPLB switchtable entries
+* MEMSIZE / 4 (we mostly install 4M page size CPLBs
+* approx 12 for smaller 1MB page size CPLBs for allignment purposes
+* 1 for L1 Instruction Memory
+* 1 for CONFIG_DEBUG_HUNT_FOR_ZERO
+*/
+
+#define MAX_SWITCH_I_CPLBS (((CONFIG_MEM_SIZE / 4) + 12 + 1 + 1) * 2)
+
+#endif	/* __MACH_BF48_H__  */
diff --git a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
new file mode 100644
index 0000000..8f5d9c4
--- /dev/null
+++ b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
@@ -0,0 +1,147 @@
+#include <linux/serial.h>
+#include <asm/dma.h>
+
+#define NR_PORTS		2
+
+#define OFFSET_THR              0x00	/* Transmit Holding register            */
+#define OFFSET_RBR              0x00	/* Receive Buffer register              */
+#define OFFSET_DLL              0x00	/* Divisor Latch (Low-Byte)             */
+#define OFFSET_IER              0x04	/* Interrupt Enable Register            */
+#define OFFSET_DLH              0x04	/* Divisor Latch (High-Byte)            */
+#define OFFSET_IIR              0x08	/* Interrupt Identification Register    */
+#define OFFSET_LCR              0x0C	/* Line Control Register                */
+#define OFFSET_MCR              0x10	/* Modem Control Register               */
+#define OFFSET_LSR              0x14	/* Line Status Register                 */
+#define OFFSET_MSR              0x18	/* Modem Status Register                */
+#define OFFSET_SCR              0x1C	/* SCR Scratch Register                 */
+#define OFFSET_GCTL             0x24	/* Global Control Register              */
+
+#define UART_GET_CHAR(uart)     bfin_read16(((uart)->port.membase + OFFSET_RBR))
+#define UART_GET_DLL(uart)	bfin_read16(((uart)->port.membase + OFFSET_DLL))
+#define UART_GET_IER(uart)      bfin_read16(((uart)->port.membase + OFFSET_IER))
+#define UART_GET_DLH(uart)	bfin_read16(((uart)->port.membase + OFFSET_DLH))
+#define UART_GET_IIR(uart)      bfin_read16(((uart)->port.membase + OFFSET_IIR))
+#define UART_GET_LCR(uart)      bfin_read16(((uart)->port.membase + OFFSET_LCR))
+#define UART_GET_LSR(uart)      bfin_read16(((uart)->port.membase + OFFSET_LSR))
+#define UART_GET_GCTL(uart)     bfin_read16(((uart)->port.membase + OFFSET_GCTL))
+
+#define UART_PUT_CHAR(uart,v)   bfin_write16(((uart)->port.membase + OFFSET_THR),v)
+#define UART_PUT_DLL(uart,v)    bfin_write16(((uart)->port.membase + OFFSET_DLL),v)
+#define UART_PUT_IER(uart,v)    bfin_write16(((uart)->port.membase + OFFSET_IER),v)
+#define UART_PUT_DLH(uart,v)    bfin_write16(((uart)->port.membase + OFFSET_DLH),v)
+#define UART_PUT_LCR(uart,v)    bfin_write16(((uart)->port.membase + OFFSET_LCR),v)
+#define UART_PUT_GCTL(uart,v)   bfin_write16(((uart)->port.membase + OFFSET_GCTL),v)
+
+#if defined(CONFIG_BFIN_UART0_CTSRTS) || defined(CONFIG_BFIN_UART1_CTSRTS)
+# define CONFIG_SERIAL_BFIN_CTSRTS
+
+# ifndef CONFIG_UART0_CTS_PIN
+#  define CONFIG_UART0_CTS_PIN -1
+# endif
+
+# ifndef CONFIG_UART0_RTS_PIN
+#  define CONFIG_UART0_RTS_PIN -1
+# endif
+
+# ifndef CONFIG_UART1_CTS_PIN
+#  define CONFIG_UART1_CTS_PIN -1
+# endif
+
+# ifndef CONFIG_UART1_RTS_PIN
+#  define CONFIG_UART1_RTS_PIN -1
+# endif
+#endif
+/*
+ * The pin configuration is different from schematic
+ */
+struct bfin_serial_port {
+        struct uart_port        port;
+        unsigned int            old_status;
+#ifdef CONFIG_SERIAL_BFIN_DMA
+	int			tx_done;
+	int			tx_count;
+	struct circ_buf		rx_dma_buf;
+	struct timer_list       rx_dma_timer;
+	int			rx_dma_nrows;
+	unsigned int		tx_dma_channel;
+	unsigned int		rx_dma_channel;
+	struct work_struct	tx_dma_workqueue;
+#else
+	struct work_struct 	cts_workqueue;
+#endif
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	int		cts_pin;
+	int 		rts_pin;
+#endif
+};
+
+struct bfin_serial_port bfin_serial_ports[NR_PORTS];
+struct bfin_serial_res {
+	unsigned long	uart_base_addr;
+	int		uart_irq;
+#ifdef CONFIG_SERIAL_BFIN_DMA
+	unsigned int	uart_tx_dma_channel;
+	unsigned int	uart_rx_dma_channel;
+#endif
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	int	uart_cts_pin;
+	int	uart_rts_pin;
+#endif
+};
+
+struct bfin_serial_res bfin_serial_resource[] = {
+#ifdef CONFIG_SERIAL_BFIN_UART0
+	{
+	0xFFC00400,
+	IRQ_UART0_RX,
+#ifdef CONFIG_SERIAL_BFIN_DMA
+	CH_UART0_TX,
+	CH_UART0_RX,
+#endif
+#ifdef CONFIG_BFIN_UART0_CTSRTS
+	CONFIG_UART0_CTS_PIN,
+	CONFIG_UART0_RTS_PIN,
+#endif
+	},
+#endif
+#ifdef CONFIG_SERIAL_BFIN_UART1
+	{
+	0xFFC02000,
+	IRQ_UART1_RX,
+#ifdef CONFIG_SERIAL_BFIN_DMA
+	CH_UART1_TX,
+	CH_UART1_RX,
+#endif
+#ifdef CONFIG_BFIN_UART1_CTSRTS
+	CONFIG_UART1_CTS_PIN,
+	CONFIG_UART1_RTS_PIN,
+#endif
+	},
+#endif
+};
+
+int nr_ports = ARRAY_SIZE(bfin_serial_resource);
+
+static void bfin_serial_hw_init(struct bfin_serial_port *uart)
+{
+	unsigned short val;
+	val = bfin_read16(BFIN_PORT_MUX);
+	val &= ~(PFDE | PFTE);
+	bfin_write16(BFIN_PORT_MUX, val);
+
+	val = bfin_read16(PORTF_FER);
+	val |= 0xF;
+	bfin_write16(PORTF_FER, val);
+
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	if (uart->cts_pin >= 0) {
+		gpio_request(uart->cts_pin, NULL);
+		gpio_direction_input(uart->cts_pin);
+	}
+
+	if (uart->rts_pin >= 0) {
+		gpio_request(uart->rts_pin, NULL);
+		gpio_direction_output(uart->rts_pin);
+	}
+#endif
+}
diff --git a/include/asm-blackfin/mach-bf548/blackfin.h b/include/asm-blackfin/mach-bf548/blackfin.h
new file mode 100644
index 0000000..094c41a
--- /dev/null
+++ b/include/asm-blackfin/mach-bf548/blackfin.h
@@ -0,0 +1,166 @@
+/*
+ * File:         include/asm-blackfin/mach-bf548/blackfin.h
+ * Based on:
+ * Author:
+ *
+ * Created:
+ * Description:
+ *
+ * Rev:
+ *
+ * Modified:
+ *
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.
+ * If not, write to the Free Software Foundation,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef _MACH_BLACKFIN_H_
+#define _MACH_BLACKFIN_H_
+
+#define BF548_FAMILY
+
+#ifdef CONFIG_BF542
+#include "bf542.h"
+
+#ifdef CONFIG_BF544
+#include "bf544.h"
+#endif
+
+#ifdef CONFIG_BF548
+#include "bf548.h"
+#endif
+
+#ifdef CONFIG_BF549
+#include "bf549.h"
+#endif
+
+#include "mem_map.h"
+#include "anomaly.h"
+
+#if !(defined(__ASSEMBLY__) || defined(ASSEMBLY))
+#ifdef CONFIG_BF542
+#include "cdefBF542.h"
+#endif
+
+#ifdef CONFIG_BF544
+#include "cdefBF544.h"
+#endif
+#ifdef CONFIG_BF548
+#include "cdefBF548.h"
+#endif
+#ifdef CONFIG_BF549
+#include "cdefBF549.h"
+#endif
+
+/* UART 1*/
+#define bfin_read_UART_THR()		bfin_read_UART1_THR()
+#define bfin_write_UART_THR(val)	bfin_write_UART1_THR(val)
+#define bfin_read_UART_RBR()		bfin_read_UART1_RBR()
+#define bfin_write_UART_RBR(val)	bfin_write_UART1_RBR(val)
+#define bfin_read_UART_DLL()		bfin_read_UART1_DLL()
+#define bfin_write_UART_DLL(val)	bfin_write_UART1_DLL(val)
+#define bfin_read_UART_IER()		bfin_read_UART1_IER()
+#define bfin_write_UART_IER(val)	bfin_write_UART1_IER(val)
+#define bfin_read_UART_DLH()		bfin_read_UART1_DLH()
+#define bfin_write_UART_DLH(val)	bfin_write_UART1_DLH(val)
+#define bfin_read_UART_IIR()		bfin_read_UART1_IIR()
+#define bfin_write_UART_IIR(val)	bfin_write_UART1_IIR(val)
+#define bfin_read_UART_LCR()		bfin_read_UART1_LCR()
+#define bfin_write_UART_LCR(val)	bfin_write_UART1_LCR(val)
+#define bfin_read_UART_MCR()		bfin_read_UART1_MCR()
+#define bfin_write_UART_MCR(val)	bfin_write_UART1_MCR(val)
+#define bfin_read_UART_LSR()		bfin_read_UART1_LSR()
+#define bfin_write_UART_LSR(val)	bfin_write_UART1_LSR(val)
+#define bfin_read_UART_SCR()		bfin_read_UART1_SCR()
+#define bfin_write_UART_SCR(val)	bfin_write_UART1_SCR(val)
+#define bfin_read_UART_GCTL()		bfin_read_UART1_GCTL()
+#define bfin_write_UART_GCTL(val)	bfin_write_UART1_GCTL(val)
+
+#endif
+
+/* MAP used DEFINES from BF533 to BF54x - so we don't need to change 
+ * them in the driver, kernel, etc. */
+
+/* UART_IIR Register */
+#define STATUS(x)	((x << 1) & 0x06)
+#define STATUS_P1	0x02
+#define STATUS_P0	0x01
+
+/* UART 0*/
+
+/* DMA Channnel */
+#define bfin_read_CH_UART_RX()		bfin_read_CH_UART1_RX()
+#define bfin_write_CH_UART_RX(val)	bfin_write_CH_UART1_RX(val)
+#define bfin_read_CH_UART_TX()		bfin_read_CH_UART1_TX()
+#define bfin_write_CH_UART_TX(val)	bfin_write_CH_UART1_TX(val)
+#define CH_UART_RX			CH_UART1_RX
+#define CH_UART_TX			CH_UART1_TX
+
+/* System Interrupt Controller */
+#define bfin_read_IRQ_UART_RX()		bfin_read_IRQ_UART1_RX()
+#define bfin_write_IRQ_UART_RX(val)	bfin_write_IRQ_UART1_RX(val)
+#define bfin_read_IRQ_UART_TX()		bfin_read_IRQ_UART1_TX()
+#define bfin_write_IRQ_UART_TX(val)	bfin_write_IRQ_UART1_TX(val)
+#define bfin_read_IRQ_UART_ERROR()	bfin_read_IRQ_UART1_ERROR()
+#define bfin_write_IRQ_UART_ERROR(val)	bfin_write_IRQ_UART1_ERROR(val)
+#define IRQ_UART_RX			IRQ_UART1_RX
+#define	IRQ_UART_TX			IRQ_UART1_TX
+#define	IRQ_UART_ERROR			IRQ_UART1_ERROR
+
+/* MMR Registers*/
+#define bfin_read_UART_THR()		bfin_read_UART1_THR()
+#define bfin_write_UART_THR(val)	bfin_write_UART1_THR(val)
+#define bfin_read_UART_RBR()		bfin_read_UART1_RBR()
+#define bfin_write_UART_RBR(val)	bfin_write_UART1_RBR(val)
+#define bfin_read_UART_DLL()		bfin_read_UART1_DLL()
+#define bfin_write_UART_DLL(val)	bfin_write_UART1_DLL(val)
+#define bfin_read_UART_IER()		bfin_read_UART1_IER()
+#define bfin_write_UART_IER(val)	bfin_write_UART1_IER(val)
+#define bfin_read_UART_DLH()		bfin_read_UART1_DLH()
+#define bfin_write_UART_DLH(val)	bfin_write_UART1_DLH(val)
+#define bfin_read_UART_IIR()		bfin_read_UART1_IIR()
+#define bfin_write_UART_IIR(val)	bfin_write_UART1_IIR(val)
+#define bfin_read_UART_LCR()		bfin_read_UART1_LCR()
+#define bfin_write_UART_LCR(val)	bfin_write_UART1_LCR(val)
+#define bfin_read_UART_MCR()		bfin_read_UART1_MCR()
+#define bfin_write_UART_MCR(val)	bfin_write_UART1_MCR(val)
+#define bfin_read_UART_LSR()		bfin_read_UART1_LSR()
+#define bfin_write_UART_LSR(val)	bfin_write_UART1_LSR(val)
+#define bfin_read_UART_SCR()		bfin_read_UART1_SCR()
+#define bfin_write_UART_SCR(val)	bfin_write_UART1_SCR(val)
+#define bfin_read_UART_GCTL()		bfin_read_UART1_GCTL()
+#define bfin_write_UART_GCTL(val)	bfin_write_UART1_GCTL(val)
+#define UART_THR			UART1_THR
+#define UART_RBR			UART1_RBR
+#define UART_DLL			UART1_DLL
+#define UART_IER			UART1_IER
+#define UART_DLH			UART1_DLH
+#define UART_IIR			UART1_IIR
+#define UART_LCR			UART1_LCR
+#define UART_MCR			UART1_MCR
+#define UART_LSR			UART1_LSR
+#define UART_SCR			UART1_SCR
+#define UART_GCTL			UART1_GCTL
+
+/* PLL_DIV Masks */
+#define CCLK_DIV1 CSEL_DIV1	/* CCLK = VCO / 1 */
+#define CCLK_DIV2 CSEL_DIV2	/* CCLK = VCO / 2 */
+#define CCLK_DIV4 CSEL_DIV4	/* CCLK = VCO / 4 */
+#define CCLK_DIV8 CSEL_DIV8	/* CCLK = VCO / 8 */
+
+#endif
diff --git a/include/asm-blackfin/mach-bf548/dma.h b/include/asm-blackfin/mach-bf548/dma.h
new file mode 100644
index 0000000..5a334c8
--- /dev/null
+++ b/include/asm-blackfin/mach-bf548/dma.h
@@ -0,0 +1,63 @@
+/*
+ * file:         include/asm-blackfin/mach-bf548/dma.h
+ * based on:
+ * author:
+ *
+ * created:
+ * description:
+ *	system mmr register map
+ * rev:
+ *
+ * modified:
+ *
+ *
+ * bugs:         enter bugs at http://blackfin.uclinux.org/
+ *
+ * this program is free software; you can redistribute it and/or modify
+ * it under the terms of the gnu general public license as published by
+ * the free software foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * this program is distributed in the hope that it will be useful,
+ * but without any warranty; without even the implied warranty of
+ * merchantability or fitness for a particular purpose.  see the
+ * gnu general public license for more details.
+ *
+ * you should have received a copy of the gnu general public license
+ * along with this program; see the file copying.
+ * if not, write to the free software foundation,
+ * 59 temple place - suite 330, boston, ma 02111-1307, usa.
+ */
+
+#ifndef _MACH_DMA_H_
+#define _MACH_DMA_H_
+
+#define CH_SPORT0_RX		0
+#define CH_SPORT0_TX		1
+#define CH_SPORT1_RX		2
+#define CH_SPORT1_TX		3
+#define CH_SPI0			4
+#define CH_SPI1			5
+#define CH_UART0_RX 		6
+#define CH_UART0_TX 		7
+#define CH_UART1_RX 		8
+#define CH_UART1_TX 		9
+#define CH_ATAPI_RX		10
+#define CH_ATAPI_TX		11
+
+#define CH_EPPI0		12
+#define CH_EPPI1		13
+#define CH_EPPI2		14
+#define CH_PIXC_IMAGE		15
+#define CH_PIXC_OVERLAY		16
+#define CH_PIXC_OUTPUT		17
+#define CH_SPORT2_RX		18
+#define CH_SPORT2_TX		19
+#define CH_SPORT3_RX		20
+#define CH_SPORT3_TX		21
+#define CH_SDH			22
+#define CH_SPI2			23
+
+#define MAX_BLACKFIN_DMA_CHANNEL CH_SPI2
+
+#endif
diff --git a/include/asm-blackfin/mach-bf548/irq.h b/include/asm-blackfin/mach-bf548/irq.h
new file mode 100644
index 0000000..a7f6703
--- /dev/null
+++ b/include/asm-blackfin/mach-bf548/irq.h
@@ -0,0 +1,306 @@
+/*
+ * file:	include/asm-blackfin/mach-bf548/irq.h
+ * based on:	include/asm-blackfin/mach-bf537/irq.h 
+ * author:	Roy Huang (roy.huang@analog.com)
+ *
+ * created:
+ * description:
+ *	system mmr register map
+ * rev:
+ *
+ * modified:
+ *
+ *
+ * bugs:         enter bugs at http://blackfin.uclinux.org/
+ *
+ * this program is free software; you can redistribute it and/or modify
+ * it under the terms of the gnu general public license as published by
+ * the free software foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * this program is distributed in the hope that it will be useful,
+ * but without any warranty; without even the implied warranty of
+ * merchantability or fitness for a particular purpose.  see the
+ * gnu general public license for more details.
+ *
+ * you should have received a copy of the gnu general public license
+ * along with this program; see the file copying.
+ * if not, write to the free software foundation,
+ * 59 temple place - suite 330, boston, ma 02111-1307, usa.
+ */
+
+#ifndef _BF548_IRQ_H_
+#define _BF548_IRQ_H_
+
+/*
+ * Interrupt source definitions
+            Event Source    Core Event Name
+Core        Emulation               **
+Events         (highest priority)  EMU         0
+            Reset                   RST         1
+            NMI                     NMI         2
+            Exception               EVX         3
+            Reserved                --          4
+            Hardware Error          IVHW        5
+            Core Timer              IVTMR       6 *
+
+.....
+
+            Software Interrupt 1    IVG14       31
+            Software Interrupt 2    --
+                 (lowest priority)  IVG15       32 *
+ */
+
+#define NR_PERI_INTS    32
+
+/* The ABSTRACT IRQ definitions */
+/** the first seven of the following are fixed, the rest you change if you need to **/
+#define IRQ_EMU		0	/* Emulation */
+#define IRQ_RST		1	/* reset */
+#define IRQ_NMI		2	/* Non Maskable */
+#define IRQ_EVX		3	/* Exception */
+#define IRQ_UNUSED	4	/* - unused interrupt*/
+#define IRQ_HWERR	5	/* Hardware Error */
+#define IRQ_CORETMR	6	/* Core timer */
+
+#define BFIN_IRQ(x)	((x) + 7)
+
+#define IRQ_PLL_WAKEUP	BFIN_IRQ(0)	/* PLL Wakeup Interrupt */
+#define IRQ_DMAC0_ERR	BFIN_IRQ(1)	/* DMAC0 Status Interrupt */
+#define IRQ_EPPI0_ERR	BFIN_IRQ(2)	/* EPPI0 Error Interrupt */
+#define IRQ_SPORT0_ERR	BFIN_IRQ(3)	/* SPORT0 Error Interrupt */
+#define IRQ_SPORT1_ERR	BFIN_IRQ(4)	/* SPORT1 Error Interrupt */
+#define IRQ_SPI0_ERR	BFIN_IRQ(5)	/* SPI0 Status(Error) Interrupt */
+#define IRQ_UART0_ERR	BFIN_IRQ(6)	/* UART0 Status(Error) Interrupt */
+#define IRQ_RTC		BFIN_IRQ(7)	/* RTC Interrupt */
+#define IRQ_EPPI0	BFIN_IRQ(8)	/* EPPI0 Interrupt (DMA12) */
+#define IRQ_SPORT0_RX	BFIN_IRQ(9)	/* SPORT0 RX Interrupt (DMA0) */
+#define IRQ_SPORT0_TX	BFIN_IRQ(10)	/* SPORT0 TX Interrupt (DMA1) */
+#define IRQ_SPORT1_RX	BFIN_IRQ(11)	/* SPORT1 RX Interrupt (DMA2) */
+#define IRQ_SPORT1_TX	BFIN_IRQ(12)	/* SPORT1 TX Interrupt (DMA3) */
+#define IRQ_SPI0	BFIN_IRQ(13)	/* SPI0 Interrupt (DMA4) */
+#define IRQ_UART0_RX	BFIN_IRQ(14)	/* UART0 RX Interrupt (DMA6) */
+#define IRQ_UART0_TX	BFIN_IRQ(15)	/* UART0 TX Interrupt (DMA7) */
+#define IRQ_TIMER8	BFIN_IRQ(16)	/* TIMER 8 Interrupt */
+#define IRQ_TIMER9	BFIN_IRQ(17)	/* TIMER 9 Interrupt */
+#define IRQ_TIMER10	BFIN_IRQ(18)	/* TIMER 10 Interrupt */
+#define IRQ_PINT0	BFIN_IRQ(19)	/* PINT0 Interrupt */
+#define IRQ_PINT1	BFIN_IRQ(20)	/* PINT1 Interrupt */
+#define IRQ_MDMAS0	BFIN_IRQ(21)	/* MDMA Stream 0 Interrupt */
+#define IRQ_MDMAS1	BFIN_IRQ(22)	/* MDMA Stream 1 Interrupt */
+#define IRQ_WATCHDOG	BFIN_IRQ(23)	/* Watchdog Interrupt */
+#define IRQ_DMAC1_ERR	BFIN_IRQ(24)	/* DMAC1 Status (Error) Interrupt */
+#define IRQ_SPORT2_ERR	BFIN_IRQ(25)	/* SPORT2 Error Interrupt */
+#define IRQ_SPORT3_ERR	BFIN_IRQ(26)	/* SPORT3 Error Interrupt */
+#define IRQ_MXVR	BFIN_IRQ(27)	/* SPORT3 Error Interrupt */
+#define IRQ_SPI1_ERR	BFIN_IRQ(28)	/* SPI1 Status (Error) Interrupt */
+#define IRQ_SPI2_ERR	BFIN_IRQ(29)	/* SPI2 Status (Error) Interrupt */
+#define IRQ_UART1_ERR	BFIN_IRQ(30)	/* UART1 Status (Error) Interrupt */
+#define IRQ_UART2_ERR	BFIN_IRQ(31)	/* UART2 Status (Error) Interrupt */
+#define IRQ_CAN0_ERR	BFIN_IRQ(32)	/* CAN0 Status (Error) Interrupt */
+#define IRQ_SPORT2_RX	BFIN_IRQ(33)	/* SPORT2 RX (DMA18) Interrupt */
+#define IRQ_SPORT2_TX	BFIN_IRQ(34)	/* SPORT2 TX (DMA19) Interrupt */
+#define IRQ_SPORT3_RX	BFIN_IRQ(35)	/* SPORT3 RX (DMA20) Interrupt */
+#define IRQ_SPORT3_TX	BFIN_IRQ(36)	/* SPORT3 TX (DMA21) Interrupt */
+#define IRQ_EPP1	BFIN_IRQ(37)	/* EPP1 (DMA13) Interrupt */
+#define IRQ_EPP2	BFIN_IRQ(38)	/* EPP2 (DMA14) Interrupt */
+#define IRQ_SPI1	BFIN_IRQ(39)	/* SPI1 (DMA5) Interrupt */
+#define IRQ_SPI2	BFIN_IRQ(40)	/* SPI2 (DMA23) Interrupt */
+#define IRQ_UART1_RX	BFIN_IRQ(41)	/* UART1 RX (DMA8) Interrupt */
+#define IRQ_UART1_TX	BFIN_IRQ(42)	/* UART1 TX (DMA9) Interrupt */
+#define IRQ_ATAPI_RX	BFIN_IRQ(43)	/* ATAPI RX (DMA10) Interrupt */
+#define IRQ_ATAPI_TX	BFIN_IRQ(44)	/* ATAPI TX (DMA11) Interrupt */
+#define IRQ_TWI0	BFIN_IRQ(45)	/* TWI0 Interrupt */
+#define IRQ_TWI1	BFIN_IRQ(46)	/* TWI1 Interrupt */
+#define IRQ_CAN0_RX	BFIN_IRQ(47)	/* CAN0 Receive Interrupt */
+#define IRQ_CAN0_TX	BFIN_IRQ(48)	/* CAN0 Transmit Interrupt */
+#define IRQ_MDMAS2	BFIN_IRQ(49)	/* MDMA Stream 2 Interrupt */
+#define IRQ_MDMAS3	BFIN_IRQ(50)	/* MDMA Stream 3 Interrupt */
+#define IRQ_MXVR_ERR	BFIN_IRQ(51)	/* MXVR Status (Error) Interrupt */
+#define IRQ_MXVR_MSG	BFIN_IRQ(52)	/* MXVR Message Interrupt */
+#define IRQ_MXVR_PKT	BFIN_IRQ(53)	/* MXVR Packet Interrupt */
+#define IRQ_EPP1_ERR	BFIN_IRQ(54)	/* EPPI1 Error Interrupt */
+#define IRQ_EPP2_ERR	BFIN_IRQ(55)	/* EPPI2 Error Interrupt */
+#define IRQ_UART3_ERR	BFIN_IRQ(56)	/* UART3 Status (Error) Interrupt */
+#define IRQ_HOST_ERR	BFIN_IRQ(57)	/* HOST Status (Error) Interrupt */
+#define IRQ_PIXC_ERR	BFIN_IRQ(59)	/* PIXC Status (Error) Interrupt */
+#define IRQ_NFC_ERR	BFIN_IRQ(60)	/* NFC Error Interrupt */
+#define IRQ_ATAPI_ERR	BFIN_IRQ(61)	/* ATAPI Error Interrupt */
+#define IRQ_CAN1_ERR	BFIN_IRQ(62)	/* CAN1 Status (Error) Interrupt */
+#define IRQ_HS_DMA_ERR	BFIN_IRQ(63)	/* Handshake DMA Status Interrupt */
+#define IRQ_PIXC_IN0	BFIN_IRQ(64)	/* PIXC IN0 (DMA15) Interrupt */
+#define IRQ_PIXC_IN1	BFIN_IRQ(65)	/* PIXC IN1 (DMA16) Interrupt */
+#define IRQ_PIXC_OUT	BFIN_IRQ(66)	/* PIXC OUT (DMA17) Interrupt */
+#define IRQ_SDH		BFIN_IRQ(67)	/* SDH/NFC (DMA22) Interrupt */
+#define IRQ_CNT		BFIN_IRQ(68)	/* CNT Interrupt */
+#define IRQ_KEY		BFIN_IRQ(69)	/* KEY Interrupt */
+#define IRQ_CAN1_RX	BFIN_IRQ(70)	/* CAN1 RX Interrupt */
+#define IRQ_CAN1_TX	BFIN_IRQ(71)	/* CAN1 TX Interrupt */
+#define IRQ_SDH_MASK0	BFIN_IRQ(72)	/* SDH Mask 0 Interrupt */
+#define IRQ_SDH_MASK1	BFIN_IRQ(73)	/* SDH Mask 1 Interrupt */
+#define IRQ_USB_INT0	BFIN_IRQ(75)	/* USB INT0 Interrupt */
+#define IRQ_USB_INT1	BFIN_IRQ(76)	/* USB INT1 Interrupt */
+#define IRQ_USB_INT2	BFIN_IRQ(77)	/* USB INT2 Interrupt */
+#define IRQ_USB_DMA	BFIN_IRQ(78)	/* USB DMA Interrupt */
+#define IRQ_OPTSEC	BFIN_IRQ(79)	/* OTPSEC Interrupt */
+#define IRQ_TMR0	BFIN_IRQ(86)	/* Timer 0 Interrupt */
+#define IRQ_TMR1	BFIN_IRQ(87)	/* Timer 1 Interrupt */
+#define IRQ_TMR2	BFIN_IRQ(88)	/* Timer 2 Interrupt */
+#define IRQ_TMR3	BFIN_IRQ(89)	/* Timer 3 Interrupt */
+#define IRQ_TMR4	BFIN_IRQ(90)	/* Timer 4 Interrupt */
+#define IRQ_TMR5	BFIN_IRQ(91)	/* Timer 5 Interrupt */
+#define IRQ_TMR6	BFIN_IRQ(92)	/* Timer 6 Interrupt */
+#define IRQ_TMR7	BFIN_IRQ(93)	/* Timer 7 Interrupt */
+#define IRQ_PINT2	BFIN_IRQ(94)	/* PINT2 Interrupt */
+#define IRQ_PINT3	BFIN_IRQ(95)	/* PINT3 Interrupt */
+
+#define SYS_IRQS        IRQ_PINT3
+
+#define BFIN_PA_IRQ(x)	((x) + SYS_IRQS + 1)
+#define IRQ_PA0		BFIN_PA_IRQ(0)
+#define IRQ_PA1		BFIN_PA_IRQ(1)
+#define IRQ_PA2		BFIN_PA_IRQ(2)
+#define IRQ_PA3		BFIN_PA_IRQ(3)
+#define IRQ_PA4		BFIN_PA_IRQ(4)
+#define IRQ_PA5		BFIN_PA_IRQ(5)
+#define IRQ_PA6		BFIN_PA_IRQ(6)
+#define IRQ_PA7		BFIN_PA_IRQ(7)
+#define IRQ_PA8		BFIN_PA_IRQ(8)
+#define IRQ_PA9		BFIN_PA_IRQ(9)
+#define IRQ_PA10	BFIN_PA_IRQ(10)
+#define IRQ_PA11	BFIN_PA_IRQ(11)
+#define IRQ_PA12	BFIN_PA_IRQ(12)
+#define IRQ_PA13	BFIN_PA_IRQ(13)
+#define IRQ_PA14	BFIN_PA_IRQ(14)
+#define IRQ_PA15	BFIN_PA_IRQ(15)
+
+#define BFIN_PB_IRQ(x)	((x) + IRQ_PA15 + 1)
+#define IRQ_PB0		BFIN_PB_IRQ(0)
+#define IRQ_PB1		BFIN_PB_IRQ(1)
+#define IRQ_PB2		BFIN_PB_IRQ(2)
+#define IRQ_PB3		BFIN_PB_IRQ(3)
+#define IRQ_PB4		BFIN_PB_IRQ(4)
+#define IRQ_PB5		BFIN_PB_IRQ(5)
+#define IRQ_PB6		BFIN_PB_IRQ(6)
+#define IRQ_PB7		BFIN_PB_IRQ(7)
+#define IRQ_PB8		BFIN_PB_IRQ(8)
+#define IRQ_PB9		BFIN_PB_IRQ(9)
+#define IRQ_PB10	BFIN_PB_IRQ(10)
+#define IRQ_PB11	BFIN_PB_IRQ(11)
+#define IRQ_PB12	BFIN_PB_IRQ(12)
+#define IRQ_PB13	BFIN_PB_IRQ(13)
+#define IRQ_PB14	BFIN_PB_IRQ(14)
+#define IRQ_PB15	BFIN_PB_IRQ(15)
+
+#define BFIN_PC_IRQ(x)	((x) + IRQ_PB15 + 1)
+#define IRQ_PC0		BFIN_PC_IRQ(0)
+#define IRQ_PC1		BFIN_PC_IRQ(1)
+#define IRQ_PC2		BFIN_PC_IRQ(2)
+#define IRQ_PC3		BFIN_PC_IRQ(3)
+#define IRQ_PC4		BFIN_PC_IRQ(4)
+#define IRQ_PC5		BFIN_PC_IRQ(5)
+#define IRQ_PC6		BFIN_PC_IRQ(6)
+#define IRQ_PC7		BFIN_PC_IRQ(7)
+#define IRQ_PC8		BFIN_PC_IRQ(8)
+#define IRQ_PC9		BFIN_PC_IRQ(9)
+#define IRQ_PC10	BFIN_PC_IRQ(10)
+#define IRQ_PC11	BFIN_PC_IRQ(11)
+#define IRQ_PC12	BFIN_PC_IRQ(12)
+#define IRQ_PC13	BFIN_PC_IRQ(13)
+#define IRQ_PC14	BFIN_PC_IRQ(14)
+#define IRQ_PC15	BFIN_PC_IRQ(15)
+
+#define BFIN_PD_IRQ(x)	((x) + IRQ_PC15 + 1)
+#define IRQ_PD0		BFIN_PD_IRQ(0)
+#define IRQ_PD1		BFIN_PD_IRQ(1)
+#define IRQ_PD2		BFIN_PD_IRQ(2)
+#define IRQ_PD3		BFIN_PD_IRQ(3)
+#define IRQ_PD4		BFIN_PD_IRQ(4)
+#define IRQ_PD5		BFIN_PD_IRQ(5)
+#define IRQ_PD6		BFIN_PD_IRQ(6)
+#define IRQ_PD7		BFIN_PD_IRQ(7)
+#define IRQ_PD8		BFIN_PD_IRQ(8)
+#define IRQ_PD9		BFIN_PD_IRQ(9)
+#define IRQ_PD10	BFIN_PD_IRQ(10)
+#define IRQ_PD11	BFIN_PD_IRQ(11)
+#define IRQ_PD12	BFIN_PD_IRQ(12)
+#define IRQ_PD13	BFIN_PD_IRQ(13)
+#define IRQ_PD14	BFIN_PD_IRQ(14)
+#define IRQ_PD15	BFIN_PD_IRQ(15)
+
+#define BFIN_PE_IRQ(x)	((x) + IRQ_PD15 + 1)
+#define IRQ_PE0		BFIN_PE_IRQ(0)
+#define IRQ_PE1		BFIN_PE_IRQ(1)
+#define IRQ_PE2		BFIN_PE_IRQ(2)
+#define IRQ_PE3		BFIN_PE_IRQ(3)
+#define IRQ_PE4		BFIN_PE_IRQ(4)
+#define IRQ_PE5		BFIN_PE_IRQ(5)
+#define IRQ_PE6		BFIN_PE_IRQ(6)
+#define IRQ_PE7		BFIN_PE_IRQ(7)
+#define IRQ_PE8		BFIN_PE_IRQ(8)
+#define IRQ_PE9		BFIN_PE_IRQ(9)
+#define IRQ_PE10	BFIN_PE_IRQ(10)
+#define IRQ_PE11	BFIN_PE_IRQ(11)
+#define IRQ_PE12	BFIN_PE_IRQ(12)
+#define IRQ_PE13	BFIN_PE_IRQ(13)
+#define IRQ_PE14	BFIN_PE_IRQ(14)
+#define IRQ_PE15	BFIN_PE_IRQ(15)
+
+
+#ifdef CONFIG_IRQCHIP_DEMUX_GPIO
+#define NR_IRQS     (IRQ_PH15+1)
+#else
+#define NR_IRQS     (IRQ_UART1_ERROR+1)
+#endif
+
+#define IVG7            7
+#define IVG8            8
+#define IVG9            9
+#define IVG10           10
+#define IVG11           11
+#define IVG12           12
+#define IVG13           13
+#define IVG14           14
+#define IVG15           15
+
+/* IAR0 BIT FIELDS*/
+#define IRQ_PLL_WAKEUP_POS  0
+#define IRQ_DMA_ERROR_POS   4
+#define IRQ_ERROR_POS       8
+#define IRQ_RTC_POS         12
+#define IRQ_PPI_POS         16
+#define IRQ_SPORT0_RX_POS   20
+#define IRQ_SPORT0_TX_POS   24
+#define IRQ_SPORT1_RX_POS   28
+
+/* IAR1 BIT FIELDS*/
+#define IRQ_SPORT1_TX_POS   0
+#define IRQ_TWI_POS         4
+#define IRQ_SPI_POS         8
+#define IRQ_UART0_RX_POS    12
+#define IRQ_UART0_TX_POS    16
+#define IRQ_UART1_RX_POS    20
+#define IRQ_UART1_TX_POS    24
+#define IRQ_CAN_RX_POS      28
+
+/* IAR2 BIT FIELDS*/
+#define IRQ_CAN_TX_POS      0
+#define IRQ_MAC_RX_POS      4
+#define IRQ_MAC_TX_POS      8
+#define IRQ_TMR0_POS        12
+#define IRQ_TMR1_POS        16
+#define IRQ_TMR2_POS        20
+#define IRQ_TMR3_POS        24
+#define IRQ_TMR4_POS        28
+
+/* IAR3 BIT FIELDS*/
+#define IRQ_TMR5_POS        0
+#define IRQ_TMR6_POS        4
+#define IRQ_TMR7_POS        8
+#define IRQ_PROG_INTA_POS   12
+#define IRQ_PORTG_INTB_POS   16
+#define IRQ_MEM_DMA0_POS    20
+#define IRQ_MEM_DMA1_POS    24
+#define IRQ_WATCH_POS       28
+
+#endif				/* _BF537_IRQ_H_ */
diff --git a/include/asm-blackfin/mach-bf548/mem_init.h b/include/asm-blackfin/mach-bf548/mem_init.h
new file mode 100644
index 0000000..0cb279e
--- /dev/null
+++ b/include/asm-blackfin/mach-bf548/mem_init.h
@@ -0,0 +1,189 @@
+/*
+ * File:         include/asm-blackfin/mach-bf548/mem_init.h
+ * Based on:
+ * Author:
+ *
+ * Created:
+ * Description:
+ *
+ * Rev:
+ *
+ * Modified:
+ *               Copyright 2004-2006 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.
+ * If not, write to the Free Software Foundation,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#if (CONFIG_MEM_MT46V32M16)
+
+#if defined CONFIG_CLKIN_HALF
+#define CLKIN_HALF       1
+#else
+#define CLKIN_HALF       0
+#endif
+
+#if defined CONFIG_PLL_BYPASS
+#define PLL_BYPASS      1
+#else
+#define PLL_BYPASS       0
+#endif
+
+/***************************************Currently Not Being Used *********************************/
+#define flash_EBIU_AMBCTL_WAT  ((CONFIG_FLASH_SPEED_BWAT * 4) / (4000000000 / CONFIG_SCLK_HZ)) + 1
+#define flash_EBIU_AMBCTL_RAT  ((CONFIG_FLASH_SPEED_BRAT * 4) / (4000000000 / CONFIG_SCLK_HZ)) + 1
+#define flash_EBIU_AMBCTL_HT   ((CONFIG_FLASH_SPEED_BHT  * 4) / (4000000000 / CONFIG_SCLK_HZ))
+#define flash_EBIU_AMBCTL_ST   ((CONFIG_FLASH_SPEED_BST  * 4) / (4000000000 / CONFIG_SCLK_HZ)) + 1
+#define flash_EBIU_AMBCTL_TT   ((CONFIG_FLASH_SPEED_BTT  * 4) / (4000000000 / CONFIG_SCLK_HZ)) + 1
+
+#if (flash_EBIU_AMBCTL_TT > 3)
+#define flash_EBIU_AMBCTL0_TT   B0TT_4
+#endif
+#if (flash_EBIU_AMBCTL_TT == 3)
+#define flash_EBIU_AMBCTL0_TT   B0TT_3
+#endif
+#if (flash_EBIU_AMBCTL_TT == 2)
+#define flash_EBIU_AMBCTL0_TT   B0TT_2
+#endif
+#if (flash_EBIU_AMBCTL_TT < 2)
+#define flash_EBIU_AMBCTL0_TT   B0TT_1
+#endif
+
+#if (flash_EBIU_AMBCTL_ST > 3)
+#define flash_EBIU_AMBCTL0_ST   B0ST_4
+#endif
+#if (flash_EBIU_AMBCTL_ST == 3)
+#define flash_EBIU_AMBCTL0_ST   B0ST_3
+#endif
+#if (flash_EBIU_AMBCTL_ST == 2)
+#define flash_EBIU_AMBCTL0_ST   B0ST_2
+#endif
+#if (flash_EBIU_AMBCTL_ST < 2)
+#define flash_EBIU_AMBCTL0_ST   B0ST_1
+#endif
+
+#if (flash_EBIU_AMBCTL_HT > 2)
+#define flash_EBIU_AMBCTL0_HT   B0HT_3
+#endif
+#if (flash_EBIU_AMBCTL_HT == 2)
+#define flash_EBIU_AMBCTL0_HT   B0HT_2
+#endif
+#if (flash_EBIU_AMBCTL_HT == 1)
+#define flash_EBIU_AMBCTL0_HT   B0HT_1
+#endif
+#if (flash_EBIU_AMBCTL_HT == 0 && CONFIG_FLASH_SPEED_BHT == 0)
+#define flash_EBIU_AMBCTL0_HT   B0HT_0
+#endif
+#if (flash_EBIU_AMBCTL_HT == 0 && CONFIG_FLASH_SPEED_BHT != 0)
+#define flash_EBIU_AMBCTL0_HT   B0HT_1
+#endif
+
+#if (flash_EBIU_AMBCTL_WAT > 14)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_15
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 14)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_14
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 13)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_13
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 12)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_12
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 11)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_11
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 10)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_10
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 9)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_9
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 8)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_8
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 7)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_7
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 6)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_6
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 5)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_5
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 4)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_4
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 3)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_3
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 2)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_2
+#endif
+#if (flash_EBIU_AMBCTL_WAT == 1)
+#define flash_EBIU_AMBCTL0_WAT  B0WAT_1
+#endif
+
+#if (flash_EBIU_AMBCTL_RAT > 14)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_15
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 14)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_14
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 13)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_13
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 12)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_12
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 11)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_11
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 10)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_10
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 9)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_9
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 8)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_8
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 7)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_7
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 6)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_6
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 5)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_5
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 4)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_4
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 3)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_3
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 2)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_2
+#endif
+#if (flash_EBIU_AMBCTL_RAT == 1)
+#define flash_EBIU_AMBCTL0_RAT  B0RAT_1
+#endif
+
+#define flash_EBIU_AMBCTL0  \
+	(flash_EBIU_AMBCTL0_WAT | flash_EBIU_AMBCTL0_RAT | flash_EBIU_AMBCTL0_HT | \
+	 flash_EBIU_AMBCTL0_ST | flash_EBIU_AMBCTL0_TT | CONFIG_FLASH_SPEED_RDYEN)
diff --git a/include/asm-blackfin/mach-bf548/mem_map.h b/include/asm-blackfin/mach-bf548/mem_map.h
new file mode 100644
index 0000000..72d80e8
--- /dev/null
+++ b/include/asm-blackfin/mach-bf548/mem_map.h
@@ -0,0 +1,97 @@
+/*
+ * file:         include/asm-blackfin/mach-bf548/mem_map.h
+ * based on:
+ * author:
+ *
+ * created:
+ * description:
+ *	Memory MAP Common header file for blackfin BF537/6/4 of processors.
+ * rev:
+ *
+ * modified:
+ *
+ * bugs:         enter bugs at http://blackfin.uclinux.org/
+ *
+ * this program is free software; you can redistribute it and/or modify
+ * it under the terms of the gnu general public license as published by
+ * the free software foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * this program is distributed in the hope that it will be useful,
+ * but without any warranty; without even the implied warranty of
+ * merchantability or fitness for a particular purpose.  see the
+ * gnu general public license for more details.
+ *
+ * you should have received a copy of the gnu general public license
+ * along with this program; see the file copying.
+ * if not, write to the free software foundation,
+ * 59 temple place - suite 330, boston, ma 02111-1307, usa.
+ */
+
+#ifndef _MEM_MAP_548_H_
+#define _MEM_MAP_548_H_
+
+#define COREMMR_BASE           0xFFE00000	 /* Core MMRs */
+#define SYSMMR_BASE            0xFFC00000	 /* System MMRs */
+
+/* Async Memory Banks */
+#define ASYNC_BANK3_BASE	0x2C000000	 /* Async Bank 3 */
+#define ASYNC_BANK3_SIZE	0x04000000	/* 64M */
+#define ASYNC_BANK2_BASE	0x28000000	 /* Async Bank 2 */
+#define ASYNC_BANK2_SIZE	0x04000000	/* 64M */
+#define ASYNC_BANK1_BASE	0x24000000	 /* Async Bank 1 */
+#define ASYNC_BANK1_SIZE	0x04000000	/* 64M */
+#define ASYNC_BANK0_BASE	0x20000000	 /* Async Bank 0 */
+#define ASYNC_BANK0_SIZE	0x04000000	/* 64M */
+
+/* Boot ROM Memory */
+
+#define BOOT_ROM_START		0xEF000000
+
+/* Level 1 Memory */
+
+/* Memory Map for ADSP-BF548 processors */
+#ifdef CONFIG_BLKFIN_ICACHE
+#define BLKFIN_ICACHESIZE	(16*1024)
+#else
+#define BLKFIN_ICACHESIZE	(0*1024)
+#endif
+
+#define L1_CODE_START       0xFFA00000
+#define L1_DATA_A_START     0xFF800000
+#define L1_DATA_B_START     0xFF900000
+
+#define L1_CODE_LENGTH      0xC000
+
+#ifdef CONFIG_BLKFIN_DCACHE
+
+#ifdef CONFIG_BLKFIN_DCACHE_BANKA
+#define DMEM_CNTR (ACACHE_BSRAM | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      (0x8000 - 0x4000)
+#define L1_DATA_B_LENGTH      0x8000
+#define BLKFIN_DCACHESIZE	(16*1024)
+#define BLKFIN_DSUPBANKS	1
+#else
+#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      (0x8000 - 0x4000)
+#define L1_DATA_B_LENGTH      (0x8000 - 0x4000)
+#define BLKFIN_DCACHESIZE	(32*1024)
+#define BLKFIN_DSUPBANKS	2
+#endif
+
+#else
+#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      0x8000
+#define L1_DATA_B_LENGTH      0x8000
+#define BLKFIN_DCACHESIZE	(0*1024)
+#define BLKFIN_DSUPBANKS	0
+#endif /*CONFIG_BLKFIN_DCACHE*/
+
+/* Scratch Pad Memory */
+
+#if defined(CONFIG_BF54x)
+#define L1_SCRATCH_START	0xFFB00000
+#define L1_SCRATCH_LENGTH	0x1000
+#endif
+
+#endif/* _MEM_MAP_548_H_ */
-- 
1.5.2
