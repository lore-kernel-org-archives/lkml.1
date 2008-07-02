Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbYGBUjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbYGBUjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 16:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbYGBUji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 16:39:38 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42928 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753649AbYGBUjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 16:39:36 -0400
Date: Wed, 2 Jul 2008 15:39:35 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: [PATCH] Update x86 mmr list for SGI uv
Message-ID: <20080702203935.GC6076@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the X86 mmr list for SGI uv.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>


Index: linux/include/asm-x86/uv/uv_mmrs.h
===================================================================
--- linux.orig/include/asm-x86/uv/uv_mmrs.h	2008-07-02 14:15:39.000000000 -0500
+++ linux/include/asm-x86/uv/uv_mmrs.h	2008-07-02 14:16:38.000000000 -0500
@@ -17,7 +17,7 @@
 /*                           UVH_BAU_DATA_CONFIG                             */
 /* ========================================================================= */
 #define UVH_BAU_DATA_CONFIG 0x61680UL
-#define UVH_BAU_DATA_CONFIG_32 0x0450
+#define UVH_BAU_DATA_CONFIG_32 0x0438
 
 #define UVH_BAU_DATA_CONFIG_VECTOR_SHFT 0
 #define UVH_BAU_DATA_CONFIG_VECTOR_MASK 0x00000000000000ffUL
@@ -53,10 +53,248 @@ union uvh_bau_data_config_u {
 };
 
 /* ========================================================================= */
+/*                           UVH_EVENT_OCCURRED0                             */
+/* ========================================================================= */
+#define UVH_EVENT_OCCURRED0 0x70000UL
+#define UVH_EVENT_OCCURRED0_32 0x005e8
+
+#define UVH_EVENT_OCCURRED0_LB_HCERR_SHFT 0
+#define UVH_EVENT_OCCURRED0_LB_HCERR_MASK 0x0000000000000001UL
+#define UVH_EVENT_OCCURRED0_GR0_HCERR_SHFT 1
+#define UVH_EVENT_OCCURRED0_GR0_HCERR_MASK 0x0000000000000002UL
+#define UVH_EVENT_OCCURRED0_GR1_HCERR_SHFT 2
+#define UVH_EVENT_OCCURRED0_GR1_HCERR_MASK 0x0000000000000004UL
+#define UVH_EVENT_OCCURRED0_LH_HCERR_SHFT 3
+#define UVH_EVENT_OCCURRED0_LH_HCERR_MASK 0x0000000000000008UL
+#define UVH_EVENT_OCCURRED0_RH_HCERR_SHFT 4
+#define UVH_EVENT_OCCURRED0_RH_HCERR_MASK 0x0000000000000010UL
+#define UVH_EVENT_OCCURRED0_XN_HCERR_SHFT 5
+#define UVH_EVENT_OCCURRED0_XN_HCERR_MASK 0x0000000000000020UL
+#define UVH_EVENT_OCCURRED0_SI_HCERR_SHFT 6
+#define UVH_EVENT_OCCURRED0_SI_HCERR_MASK 0x0000000000000040UL
+#define UVH_EVENT_OCCURRED0_LB_AOERR0_SHFT 7
+#define UVH_EVENT_OCCURRED0_LB_AOERR0_MASK 0x0000000000000080UL
+#define UVH_EVENT_OCCURRED0_GR0_AOERR0_SHFT 8
+#define UVH_EVENT_OCCURRED0_GR0_AOERR0_MASK 0x0000000000000100UL
+#define UVH_EVENT_OCCURRED0_GR1_AOERR0_SHFT 9
+#define UVH_EVENT_OCCURRED0_GR1_AOERR0_MASK 0x0000000000000200UL
+#define UVH_EVENT_OCCURRED0_LH_AOERR0_SHFT 10
+#define UVH_EVENT_OCCURRED0_LH_AOERR0_MASK 0x0000000000000400UL
+#define UVH_EVENT_OCCURRED0_RH_AOERR0_SHFT 11
+#define UVH_EVENT_OCCURRED0_RH_AOERR0_MASK 0x0000000000000800UL
+#define UVH_EVENT_OCCURRED0_XN_AOERR0_SHFT 12
+#define UVH_EVENT_OCCURRED0_XN_AOERR0_MASK 0x0000000000001000UL
+#define UVH_EVENT_OCCURRED0_SI_AOERR0_SHFT 13
+#define UVH_EVENT_OCCURRED0_SI_AOERR0_MASK 0x0000000000002000UL
+#define UVH_EVENT_OCCURRED0_LB_AOERR1_SHFT 14
+#define UVH_EVENT_OCCURRED0_LB_AOERR1_MASK 0x0000000000004000UL
+#define UVH_EVENT_OCCURRED0_GR0_AOERR1_SHFT 15
+#define UVH_EVENT_OCCURRED0_GR0_AOERR1_MASK 0x0000000000008000UL
+#define UVH_EVENT_OCCURRED0_GR1_AOERR1_SHFT 16
+#define UVH_EVENT_OCCURRED0_GR1_AOERR1_MASK 0x0000000000010000UL
+#define UVH_EVENT_OCCURRED0_LH_AOERR1_SHFT 17
+#define UVH_EVENT_OCCURRED0_LH_AOERR1_MASK 0x0000000000020000UL
+#define UVH_EVENT_OCCURRED0_RH_AOERR1_SHFT 18
+#define UVH_EVENT_OCCURRED0_RH_AOERR1_MASK 0x0000000000040000UL
+#define UVH_EVENT_OCCURRED0_XN_AOERR1_SHFT 19
+#define UVH_EVENT_OCCURRED0_XN_AOERR1_MASK 0x0000000000080000UL
+#define UVH_EVENT_OCCURRED0_SI_AOERR1_SHFT 20
+#define UVH_EVENT_OCCURRED0_SI_AOERR1_MASK 0x0000000000100000UL
+#define UVH_EVENT_OCCURRED0_RH_VPI_INT_SHFT 21
+#define UVH_EVENT_OCCURRED0_RH_VPI_INT_MASK 0x0000000000200000UL
+#define UVH_EVENT_OCCURRED0_SYSTEM_SHUTDOWN_INT_SHFT 22
+#define UVH_EVENT_OCCURRED0_SYSTEM_SHUTDOWN_INT_MASK 0x0000000000400000UL
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_0_SHFT 23
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_0_MASK 0x0000000000800000UL
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_1_SHFT 24
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_1_MASK 0x0000000001000000UL
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_2_SHFT 25
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_2_MASK 0x0000000002000000UL
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_3_SHFT 26
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_3_MASK 0x0000000004000000UL
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_4_SHFT 27
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_4_MASK 0x0000000008000000UL
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_5_SHFT 28
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_5_MASK 0x0000000010000000UL
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_6_SHFT 29
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_6_MASK 0x0000000020000000UL
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_7_SHFT 30
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_7_MASK 0x0000000040000000UL
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_8_SHFT 31
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_8_MASK 0x0000000080000000UL
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_9_SHFT 32
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_9_MASK 0x0000000100000000UL
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_10_SHFT 33
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_10_MASK 0x0000000200000000UL
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_11_SHFT 34
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_11_MASK 0x0000000400000000UL
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_12_SHFT 35
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_12_MASK 0x0000000800000000UL
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_13_SHFT 36
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_13_MASK 0x0000001000000000UL
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_14_SHFT 37
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_14_MASK 0x0000002000000000UL
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_15_SHFT 38
+#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_15_MASK 0x0000004000000000UL
+#define UVH_EVENT_OCCURRED0_L1_NMI_INT_SHFT 39
+#define UVH_EVENT_OCCURRED0_L1_NMI_INT_MASK 0x0000008000000000UL
+#define UVH_EVENT_OCCURRED0_STOP_CLOCK_SHFT 40
+#define UVH_EVENT_OCCURRED0_STOP_CLOCK_MASK 0x0000010000000000UL
+#define UVH_EVENT_OCCURRED0_ASIC_TO_L1_SHFT 41
+#define UVH_EVENT_OCCURRED0_ASIC_TO_L1_MASK 0x0000020000000000UL
+#define UVH_EVENT_OCCURRED0_L1_TO_ASIC_SHFT 42
+#define UVH_EVENT_OCCURRED0_L1_TO_ASIC_MASK 0x0000040000000000UL
+#define UVH_EVENT_OCCURRED0_LTC_INT_SHFT 43
+#define UVH_EVENT_OCCURRED0_LTC_INT_MASK 0x0000080000000000UL
+#define UVH_EVENT_OCCURRED0_LA_SEQ_TRIGGER_SHFT 44
+#define UVH_EVENT_OCCURRED0_LA_SEQ_TRIGGER_MASK 0x0000100000000000UL
+#define UVH_EVENT_OCCURRED0_IPI_INT_SHFT 45
+#define UVH_EVENT_OCCURRED0_IPI_INT_MASK 0x0000200000000000UL
+#define UVH_EVENT_OCCURRED0_EXTIO_INT0_SHFT 46
+#define UVH_EVENT_OCCURRED0_EXTIO_INT0_MASK 0x0000400000000000UL
+#define UVH_EVENT_OCCURRED0_EXTIO_INT1_SHFT 47
+#define UVH_EVENT_OCCURRED0_EXTIO_INT1_MASK 0x0000800000000000UL
+#define UVH_EVENT_OCCURRED0_EXTIO_INT2_SHFT 48
+#define UVH_EVENT_OCCURRED0_EXTIO_INT2_MASK 0x0001000000000000UL
+#define UVH_EVENT_OCCURRED0_EXTIO_INT3_SHFT 49
+#define UVH_EVENT_OCCURRED0_EXTIO_INT3_MASK 0x0002000000000000UL
+#define UVH_EVENT_OCCURRED0_PROFILE_INT_SHFT 50
+#define UVH_EVENT_OCCURRED0_PROFILE_INT_MASK 0x0004000000000000UL
+#define UVH_EVENT_OCCURRED0_RTC0_SHFT 51
+#define UVH_EVENT_OCCURRED0_RTC0_MASK 0x0008000000000000UL
+#define UVH_EVENT_OCCURRED0_RTC1_SHFT 52
+#define UVH_EVENT_OCCURRED0_RTC1_MASK 0x0010000000000000UL
+#define UVH_EVENT_OCCURRED0_RTC2_SHFT 53
+#define UVH_EVENT_OCCURRED0_RTC2_MASK 0x0020000000000000UL
+#define UVH_EVENT_OCCURRED0_RTC3_SHFT 54
+#define UVH_EVENT_OCCURRED0_RTC3_MASK 0x0040000000000000UL
+#define UVH_EVENT_OCCURRED0_BAU_DATA_SHFT 55
+#define UVH_EVENT_OCCURRED0_BAU_DATA_MASK 0x0080000000000000UL
+#define UVH_EVENT_OCCURRED0_POWER_MANAGEMENT_REQ_SHFT 56
+#define UVH_EVENT_OCCURRED0_POWER_MANAGEMENT_REQ_MASK 0x0100000000000000UL
+union uvh_event_occurred0_u {
+    unsigned long	v;
+    struct uvh_event_occurred0_s {
+	unsigned long	lb_hcerr             :  1;  /* RW, W1C */
+	unsigned long	gr0_hcerr            :  1;  /* RW, W1C */
+	unsigned long	gr1_hcerr            :  1;  /* RW, W1C */
+	unsigned long	lh_hcerr             :  1;  /* RW, W1C */
+	unsigned long	rh_hcerr             :  1;  /* RW, W1C */
+	unsigned long	xn_hcerr             :  1;  /* RW, W1C */
+	unsigned long	si_hcerr             :  1;  /* RW, W1C */
+	unsigned long	lb_aoerr0            :  1;  /* RW, W1C */
+	unsigned long	gr0_aoerr0           :  1;  /* RW, W1C */
+	unsigned long	gr1_aoerr0           :  1;  /* RW, W1C */
+	unsigned long	lh_aoerr0            :  1;  /* RW, W1C */
+	unsigned long	rh_aoerr0            :  1;  /* RW, W1C */
+	unsigned long	xn_aoerr0            :  1;  /* RW, W1C */
+	unsigned long	si_aoerr0            :  1;  /* RW, W1C */
+	unsigned long	lb_aoerr1            :  1;  /* RW, W1C */
+	unsigned long	gr0_aoerr1           :  1;  /* RW, W1C */
+	unsigned long	gr1_aoerr1           :  1;  /* RW, W1C */
+	unsigned long	lh_aoerr1            :  1;  /* RW, W1C */
+	unsigned long	rh_aoerr1            :  1;  /* RW, W1C */
+	unsigned long	xn_aoerr1            :  1;  /* RW, W1C */
+	unsigned long	si_aoerr1            :  1;  /* RW, W1C */
+	unsigned long	rh_vpi_int           :  1;  /* RW, W1C */
+	unsigned long	system_shutdown_int  :  1;  /* RW, W1C */
+	unsigned long	lb_irq_int_0         :  1;  /* RW, W1C */
+	unsigned long	lb_irq_int_1         :  1;  /* RW, W1C */
+	unsigned long	lb_irq_int_2         :  1;  /* RW, W1C */
+	unsigned long	lb_irq_int_3         :  1;  /* RW, W1C */
+	unsigned long	lb_irq_int_4         :  1;  /* RW, W1C */
+	unsigned long	lb_irq_int_5         :  1;  /* RW, W1C */
+	unsigned long	lb_irq_int_6         :  1;  /* RW, W1C */
+	unsigned long	lb_irq_int_7         :  1;  /* RW, W1C */
+	unsigned long	lb_irq_int_8         :  1;  /* RW, W1C */
+	unsigned long	lb_irq_int_9         :  1;  /* RW, W1C */
+	unsigned long	lb_irq_int_10        :  1;  /* RW, W1C */
+	unsigned long	lb_irq_int_11        :  1;  /* RW, W1C */
+	unsigned long	lb_irq_int_12        :  1;  /* RW, W1C */
+	unsigned long	lb_irq_int_13        :  1;  /* RW, W1C */
+	unsigned long	lb_irq_int_14        :  1;  /* RW, W1C */
+	unsigned long	lb_irq_int_15        :  1;  /* RW, W1C */
+	unsigned long	l1_nmi_int           :  1;  /* RW, W1C */
+	unsigned long	stop_clock           :  1;  /* RW, W1C */
+	unsigned long	asic_to_l1           :  1;  /* RW, W1C */
+	unsigned long	l1_to_asic           :  1;  /* RW, W1C */
+	unsigned long	ltc_int              :  1;  /* RW, W1C */
+	unsigned long	la_seq_trigger       :  1;  /* RW, W1C */
+	unsigned long	ipi_int              :  1;  /* RW, W1C */
+	unsigned long	extio_int0           :  1;  /* RW, W1C */
+	unsigned long	extio_int1           :  1;  /* RW, W1C */
+	unsigned long	extio_int2           :  1;  /* RW, W1C */
+	unsigned long	extio_int3           :  1;  /* RW, W1C */
+	unsigned long	profile_int          :  1;  /* RW, W1C */
+	unsigned long	rtc0                 :  1;  /* RW, W1C */
+	unsigned long	rtc1                 :  1;  /* RW, W1C */
+	unsigned long	rtc2                 :  1;  /* RW, W1C */
+	unsigned long	rtc3                 :  1;  /* RW, W1C */
+	unsigned long	bau_data             :  1;  /* RW, W1C */
+	unsigned long	power_management_req :  1;  /* RW, W1C */
+	unsigned long	rsvd_57_63           :  7;  /*    */
+    } s;
+};
+
+/* ========================================================================= */
+/*                        UVH_EVENT_OCCURRED0_ALIAS                          */
+/* ========================================================================= */
+#define UVH_EVENT_OCCURRED0_ALIAS 0x0000000000070008UL
+#define UVH_EVENT_OCCURRED0_ALIAS_32 0x005f0
+
+/* ========================================================================= */
+/*                               UVH_INT_CMPB                                */
+/* ========================================================================= */
+#define UVH_INT_CMPB 0x22080UL
+
+#define UVH_INT_CMPB_REAL_TIME_CMPB_SHFT 0
+#define UVH_INT_CMPB_REAL_TIME_CMPB_MASK 0x00ffffffffffffffUL
+
+union uvh_int_cmpb_u {
+    unsigned long	v;
+    struct uvh_int_cmpb_s {
+	unsigned long	real_time_cmpb : 56;  /* RW */
+	unsigned long	rsvd_56_63     :  8;  /*    */
+    } s;
+};
+
+/* ========================================================================= */
+/*                               UVH_INT_CMPC                                */
+/* ========================================================================= */
+#define UVH_INT_CMPC 0x22100UL
+
+#define UVH_INT_CMPC_REAL_TIME_CMPC_SHFT 0
+#define UVH_INT_CMPC_REAL_TIME_CMPC_MASK 0x00ffffffffffffffUL
+
+union uvh_int_cmpc_u {
+    unsigned long	v;
+    struct uvh_int_cmpc_s {
+	unsigned long	real_time_cmpc : 56;  /* RW */
+	unsigned long	rsvd_56_63     :  8;  /*    */
+    } s;
+};
+
+/* ========================================================================= */
+/*                               UVH_INT_CMPD                                */
+/* ========================================================================= */
+#define UVH_INT_CMPD 0x22180UL
+
+#define UVH_INT_CMPD_REAL_TIME_CMPD_SHFT 0
+#define UVH_INT_CMPD_REAL_TIME_CMPD_MASK 0x00ffffffffffffffUL
+
+union uvh_int_cmpd_u {
+    unsigned long	v;
+    struct uvh_int_cmpd_s {
+	unsigned long	real_time_cmpd : 56;  /* RW */
+	unsigned long	rsvd_56_63     :  8;  /*    */
+    } s;
+};
+
+/* ========================================================================= */
 /*                               UVH_IPI_INT                                 */
 /* ========================================================================= */
 #define UVH_IPI_INT 0x60500UL
-#define UVH_IPI_INT_32 0x0360
+#define UVH_IPI_INT_32 0x0348
 
 #define UVH_IPI_INT_VECTOR_SHFT 0
 #define UVH_IPI_INT_VECTOR_MASK 0x00000000000000ffUL
@@ -86,7 +324,7 @@ union uvh_ipi_int_u {
 /*                   UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST                     */
 /* ========================================================================= */
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST 0x320050UL
-#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST_32 0x009f0
+#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST_32 0x009c0
 
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST_ADDRESS_SHFT 4
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST_ADDRESS_MASK 0x000007fffffffff0UL
@@ -108,7 +346,7 @@ union uvh_lb_bau_intd_payload_queue_firs
 /*                    UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST                     */
 /* ========================================================================= */
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST 0x320060UL
-#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST_32 0x009f8
+#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST_32 0x009c8
 
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST_ADDRESS_SHFT 4
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST_ADDRESS_MASK 0x000007fffffffff0UL
@@ -126,7 +364,7 @@ union uvh_lb_bau_intd_payload_queue_last
 /*                    UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL                     */
 /* ========================================================================= */
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL 0x320070UL
-#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL_32 0x00a00
+#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL_32 0x009d0
 
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL_ADDRESS_SHFT 4
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL_ADDRESS_MASK 0x000007fffffffff0UL
@@ -144,7 +382,7 @@ union uvh_lb_bau_intd_payload_queue_tail
 /*                   UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE                    */
 /* ========================================================================= */
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE 0x320080UL
-#define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_32 0x0aa0
+#define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_32 0x0a68
 
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_PENDING_0_SHFT 0
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_PENDING_0_MASK 0x0000000000000001UL
@@ -205,13 +443,13 @@ union uvh_lb_bau_intd_software_acknowled
 /*                UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS                 */
 /* ========================================================================= */
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS 0x0000000000320088UL
-#define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS_32 0x0aa8
+#define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS_32 0x0a70
 
 /* ========================================================================= */
 /*                     UVH_LB_BAU_SB_ACTIVATION_CONTROL                      */
 /* ========================================================================= */
 #define UVH_LB_BAU_SB_ACTIVATION_CONTROL 0x320020UL
-#define UVH_LB_BAU_SB_ACTIVATION_CONTROL_32 0x009d8
+#define UVH_LB_BAU_SB_ACTIVATION_CONTROL_32 0x009a8
 
 #define UVH_LB_BAU_SB_ACTIVATION_CONTROL_INDEX_SHFT 0
 #define UVH_LB_BAU_SB_ACTIVATION_CONTROL_INDEX_MASK 0x000000000000003fUL
@@ -234,7 +472,7 @@ union uvh_lb_bau_sb_activation_control_u
 /*                    UVH_LB_BAU_SB_ACTIVATION_STATUS_0                      */
 /* ========================================================================= */
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_0 0x320030UL
-#define UVH_LB_BAU_SB_ACTIVATION_STATUS_0_32 0x009e0
+#define UVH_LB_BAU_SB_ACTIVATION_STATUS_0_32 0x009b0
 
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_0_STATUS_SHFT 0
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_0_STATUS_MASK 0xffffffffffffffffUL
@@ -250,7 +488,7 @@ union uvh_lb_bau_sb_activation_status_0_
 /*                    UVH_LB_BAU_SB_ACTIVATION_STATUS_1                      */
 /* ========================================================================= */
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_1 0x320040UL
-#define UVH_LB_BAU_SB_ACTIVATION_STATUS_1_32 0x009e8
+#define UVH_LB_BAU_SB_ACTIVATION_STATUS_1_32 0x009b8
 
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_1_STATUS_SHFT 0
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_1_STATUS_MASK 0xffffffffffffffffUL
@@ -266,7 +504,7 @@ union uvh_lb_bau_sb_activation_status_1_
 /*                      UVH_LB_BAU_SB_DESCRIPTOR_BASE                        */
 /* ========================================================================= */
 #define UVH_LB_BAU_SB_DESCRIPTOR_BASE 0x320010UL
-#define UVH_LB_BAU_SB_DESCRIPTOR_BASE_32 0x009d0
+#define UVH_LB_BAU_SB_DESCRIPTOR_BASE_32 0x009a0
 
 #define UVH_LB_BAU_SB_DESCRIPTOR_BASE_PAGE_ADDRESS_SHFT 12
 #define UVH_LB_BAU_SB_DESCRIPTOR_BASE_PAGE_ADDRESS_MASK 0x000007fffffff000UL
@@ -333,46 +571,48 @@ union uvh_lb_bau_sb_descriptor_base_u {
 #define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REP_OBESE_MSG_MASK 0x0000000000100000UL
 #define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REP_DATA_SB_ERR_SHFT 21
 #define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REP_DATA_SB_ERR_MASK 0x0000000000200000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_TIMEOUT_SHFT 22
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_TIMEOUT_MASK 0x0000000000400000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_SPURIOUS_EVENT_SHFT 23
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_SPURIOUS_EVENT_MASK 0x0000000000800000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_IOH_DESTINATION_TABLE_PARITY_SHFT 24
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_IOH_DESTINATION_TABLE_PARITY_MASK 0x0000000001000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_GET_HAD_ERROR_REPLY_SHFT 25
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_GET_HAD_ERROR_REPLY_MASK 0x0000000002000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_GET_TIMEOUT_SHFT 26
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_GET_TIMEOUT_MASK 0x0000000004000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_LOCK_MANAGER_HAD_ERROR_REPLY_SHFT 27
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_LOCK_MANAGER_HAD_ERROR_REPLY_MASK 0x0000000008000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_PUT_HAD_ERROR_REPLY_SHFT 28
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_PUT_HAD_ERROR_REPLY_MASK 0x0000000010000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_PUT_TIMEOUT_SHFT 29
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_PUT_TIMEOUT_MASK 0x0000000020000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_SB_ACTIVATION_OVERRUN_SHFT 30
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_SB_ACTIVATION_OVERRUN_MASK 0x0000000040000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_COMPLETED_GB_ACTIVATION_HAD_ERROR_REPLY_SHFT 31
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_COMPLETED_GB_ACTIVATION_HAD_ERROR_REPLY_MASK 0x0000000080000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_COMPLETED_GB_ACTIVATION_TIMEOUT_SHFT 32
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_COMPLETED_GB_ACTIVATION_TIMEOUT_MASK 0x0000000100000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_DESCRIPTOR_BUFFER_0_PARITY_SHFT 33
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_DESCRIPTOR_BUFFER_0_PARITY_MASK 0x0000000200000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_DESCRIPTOR_BUFFER_1_PARITY_SHFT 34
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_DESCRIPTOR_BUFFER_1_PARITY_MASK 0x0000000400000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_SOCKET_DESTINATION_TABLE_PARITY_SHFT 35
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_SOCKET_DESTINATION_TABLE_PARITY_MASK 0x0000000800000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_BAU_REPLY_PAYLOAD_CORRUPTION_SHFT 36
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_BAU_REPLY_PAYLOAD_CORRUPTION_MASK 0x0000001000000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_IO_PORT_DESTINATION_TABLE_PARITY_SHFT 37
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_IO_PORT_DESTINATION_TABLE_PARITY_MASK 0x0000002000000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INTD_SOFT_ACK_TIMEOUT_SHFT 38
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INTD_SOFT_ACK_TIMEOUT_MASK 0x0000004000000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_REP_OBESE_MSG_SHFT 39
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_REP_OBESE_MSG_MASK 0x0000008000000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_REP_COMMAND_ERR_SHFT 40
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_REP_COMMAND_ERR_MASK 0x0000010000000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_TIMEOUT_SHFT 41
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_TIMEOUT_MASK 0x0000020000000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_AMO_TIMEOUT_SHFT 22
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_AMO_TIMEOUT_MASK 0x0000000000400000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_PUT_TIMEOUT_SHFT 23
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_PUT_TIMEOUT_MASK 0x0000000000800000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_SPURIOUS_EVENT_SHFT 24
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_SPURIOUS_EVENT_MASK 0x0000000001000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_IOH_DESTINATION_TABLE_PARITY_SHFT 25
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_IOH_DESTINATION_TABLE_PARITY_MASK 0x0000000002000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_GET_HAD_ERROR_REPLY_SHFT 26
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_GET_HAD_ERROR_REPLY_MASK 0x0000000004000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_GET_TIMEOUT_SHFT 27
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_GET_TIMEOUT_MASK 0x0000000008000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_LOCK_MANAGER_HAD_ERROR_REPLY_SHFT 28
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_LOCK_MANAGER_HAD_ERROR_REPLY_MASK 0x0000000010000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_PUT_HAD_ERROR_REPLY_SHFT 29
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_PUT_HAD_ERROR_REPLY_MASK 0x0000000020000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_PUT_TIMEOUT_SHFT 30
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_PUT_TIMEOUT_MASK 0x0000000040000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_SB_ACTIVATION_OVERRUN_SHFT 31
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_SB_ACTIVATION_OVERRUN_MASK 0x0000000080000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_COMPLETED_GB_ACTIVATION_HAD_ERROR_REPLY_SHFT 32
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_COMPLETED_GB_ACTIVATION_HAD_ERROR_REPLY_MASK 0x0000000100000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_COMPLETED_GB_ACTIVATION_TIMEOUT_SHFT 33
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_COMPLETED_GB_ACTIVATION_TIMEOUT_MASK 0x0000000200000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_DESCRIPTOR_BUFFER_0_PARITY_SHFT 34
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_DESCRIPTOR_BUFFER_0_PARITY_MASK 0x0000000400000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_DESCRIPTOR_BUFFER_1_PARITY_SHFT 35
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_DESCRIPTOR_BUFFER_1_PARITY_MASK 0x0000000800000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_SOCKET_DESTINATION_TABLE_PARITY_SHFT 36
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_SOCKET_DESTINATION_TABLE_PARITY_MASK 0x0000001000000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_BAU_REPLY_PAYLOAD_CORRUPTION_SHFT 37
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_BAU_REPLY_PAYLOAD_CORRUPTION_MASK 0x0000002000000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_IO_PORT_DESTINATION_TABLE_PARITY_SHFT 38
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_IO_PORT_DESTINATION_TABLE_PARITY_MASK 0x0000004000000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INTD_SOFT_ACK_TIMEOUT_SHFT 39
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INTD_SOFT_ACK_TIMEOUT_MASK 0x0000008000000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_REP_OBESE_MSG_SHFT 40
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_REP_OBESE_MSG_MASK 0x0000010000000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_REP_COMMAND_ERR_SHFT 41
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_REP_COMMAND_ERR_MASK 0x0000020000000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_TIMEOUT_SHFT 42
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_TIMEOUT_MASK 0x0000040000000000UL
 
 union uvh_lb_mcast_aoerr0_rpt_enable_u {
     unsigned long	v;
@@ -399,7 +639,8 @@ union uvh_lb_mcast_aoerr0_rpt_enable_u {
 	unsigned long	macc_rep_runt_msg                       :  1;  /* RW */
 	unsigned long	macc_rep_obese_msg                      :  1;  /* RW */
 	unsigned long	macc_rep_data_sb_err                    :  1;  /* RW */
-	unsigned long	macc_timeout                            :  1;  /* RW */
+	unsigned long	macc_amo_timeout                        :  1;  /* RW */
+	unsigned long	macc_put_timeout                        :  1;  /* RW */
 	unsigned long	macc_spurious_event                     :  1;  /* RW */
 	unsigned long	ioh_destination_table_parity            :  1;  /* RW */
 	unsigned long	get_had_error_reply                     :  1;  /* RW */
@@ -419,7 +660,7 @@ union uvh_lb_mcast_aoerr0_rpt_enable_u {
 	unsigned long	int_rep_obese_msg                       :  1;  /* RW */
 	unsigned long	int_rep_command_err                     :  1;  /* RW */
 	unsigned long	int_timeout                             :  1;  /* RW */
-	unsigned long	rsvd_42_63                              : 22;  /*    */
+	unsigned long	rsvd_43_63                              : 21;  /*    */
     } s;
 };
 
@@ -713,14 +954,34 @@ union uvh_rh_gam_alias210_redirect_confi
 };
 
 /* ========================================================================= */
+/*                    UVH_RH_GAM_CFG_OVERLAY_CONFIG_MMR                      */
+/* ========================================================================= */
+#define UVH_RH_GAM_CFG_OVERLAY_CONFIG_MMR 0x1600020UL
+
+#define UVH_RH_GAM_CFG_OVERLAY_CONFIG_MMR_BASE_SHFT 26
+#define UVH_RH_GAM_CFG_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003ffffc000000UL
+#define UVH_RH_GAM_CFG_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
+#define UVH_RH_GAM_CFG_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
+
+union uvh_rh_gam_cfg_overlay_config_mmr_u {
+    unsigned long	v;
+    struct uvh_rh_gam_cfg_overlay_config_mmr_s {
+	unsigned long	rsvd_0_25: 26;  /*    */
+	unsigned long	base   : 20;  /* RW */
+	unsigned long	rsvd_46_62: 17;  /*    */
+	unsigned long	enable :  1;  /* RW */
+    } s;
+};
+
+/* ========================================================================= */
 /*                    UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR                      */
 /* ========================================================================= */
 #define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR 0x1600010UL
 
 #define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_SHFT 28
 #define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003ffff0000000UL
-#define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_GR4_SHFT 46
-#define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_GR4_MASK 0x0000400000000000UL
+#define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_GR4_SHFT 48
+#define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_GR4_MASK 0x0001000000000000UL
 #define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_SHFT 52
 #define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_MASK 0x00f0000000000000UL
 #define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
@@ -731,8 +992,9 @@ union uvh_rh_gam_gru_overlay_config_mmr_
     struct uvh_rh_gam_gru_overlay_config_mmr_s {
 	unsigned long	rsvd_0_27: 28;  /*    */
 	unsigned long	base   : 18;  /* RW */
+	unsigned long	rsvd_46_47:  2;  /*    */
 	unsigned long	gr4    :  1;  /* RW */
-	unsigned long	rsvd_47_51:  5;  /*    */
+	unsigned long	rsvd_49_51:  3;  /*    */
 	unsigned long	n_gru  :  4;  /* RW */
 	unsigned long	rsvd_56_62:  7;  /*    */
 	unsigned long	enable :  1;  /* RW */
@@ -740,6 +1002,32 @@ union uvh_rh_gam_gru_overlay_config_mmr_
 };
 
 /* ========================================================================= */
+/*                   UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR                     */
+/* ========================================================================= */
+#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR 0x1600030UL
+
+#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_SHFT 30
+#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003fffc0000000UL
+#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_M_IO_SHFT 46
+#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_M_IO_MASK 0x000fc00000000000UL
+#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_N_IO_SHFT 52
+#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_N_IO_MASK 0x00f0000000000000UL
+#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
+#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
+
+union uvh_rh_gam_mmioh_overlay_config_mmr_u {
+    unsigned long	v;
+    struct uvh_rh_gam_mmioh_overlay_config_mmr_s {
+	unsigned long	rsvd_0_29: 30;  /*    */
+	unsigned long	base   : 16;  /* RW */
+	unsigned long	m_io   :  6;  /* RW */
+	unsigned long	n_io   :  4;  /* RW */
+	unsigned long	rsvd_56_62:  7;  /*    */
+	unsigned long	enable :  1;  /* RW */
+    } s;
+};
+
+/* ========================================================================= */
 /*                    UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR                      */
 /* ========================================================================= */
 #define UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR 0x1600028UL
@@ -765,7 +1053,7 @@ union uvh_rh_gam_mmr_overlay_config_mmr_
 /* ========================================================================= */
 /*                                 UVH_RTC                                   */
 /* ========================================================================= */
-#define UVH_RTC 0x28000UL
+#define UVH_RTC 0x340000UL
 
 #define UVH_RTC_REAL_TIME_CLOCK_SHFT 0
 #define UVH_RTC_REAL_TIME_CLOCK_MASK 0x00ffffffffffffffUL
@@ -779,6 +1067,139 @@ union uvh_rtc_u {
 };
 
 /* ========================================================================= */
+/*                           UVH_RTC1_INT_CONFIG                             */
+/* ========================================================================= */
+#define UVH_RTC1_INT_CONFIG 0x615c0UL
+
+#define UVH_RTC1_INT_CONFIG_VECTOR_SHFT 0
+#define UVH_RTC1_INT_CONFIG_VECTOR_MASK 0x00000000000000ffUL
+#define UVH_RTC1_INT_CONFIG_DM_SHFT 8
+#define UVH_RTC1_INT_CONFIG_DM_MASK 0x0000000000000700UL
+#define UVH_RTC1_INT_CONFIG_DESTMODE_SHFT 11
+#define UVH_RTC1_INT_CONFIG_DESTMODE_MASK 0x0000000000000800UL
+#define UVH_RTC1_INT_CONFIG_STATUS_SHFT 12
+#define UVH_RTC1_INT_CONFIG_STATUS_MASK 0x0000000000001000UL
+#define UVH_RTC1_INT_CONFIG_P_SHFT 13
+#define UVH_RTC1_INT_CONFIG_P_MASK 0x0000000000002000UL
+#define UVH_RTC1_INT_CONFIG_T_SHFT 15
+#define UVH_RTC1_INT_CONFIG_T_MASK 0x0000000000008000UL
+#define UVH_RTC1_INT_CONFIG_M_SHFT 16
+#define UVH_RTC1_INT_CONFIG_M_MASK 0x0000000000010000UL
+#define UVH_RTC1_INT_CONFIG_APIC_ID_SHFT 32
+#define UVH_RTC1_INT_CONFIG_APIC_ID_MASK 0xffffffff00000000UL
+
+union uvh_rtc1_int_config_u {
+    unsigned long	v;
+    struct uvh_rtc1_int_config_s {
+	unsigned long	vector_  :  8;  /* RW */
+	unsigned long	dm       :  3;  /* RW */
+	unsigned long	destmode :  1;  /* RW */
+	unsigned long	status   :  1;  /* RO */
+	unsigned long	p        :  1;  /* RO */
+	unsigned long	rsvd_14  :  1;  /*    */
+	unsigned long	t        :  1;  /* RO */
+	unsigned long	m        :  1;  /* RW */
+	unsigned long	rsvd_17_31: 15;  /*    */
+	unsigned long	apic_id  : 32;  /* RW */
+    } s;
+};
+
+/* ========================================================================= */
+/*                           UVH_RTC2_INT_CONFIG                             */
+/* ========================================================================= */
+#define UVH_RTC2_INT_CONFIG 0x61600UL
+
+#define UVH_RTC2_INT_CONFIG_VECTOR_SHFT 0
+#define UVH_RTC2_INT_CONFIG_VECTOR_MASK 0x00000000000000ffUL
+#define UVH_RTC2_INT_CONFIG_DM_SHFT 8
+#define UVH_RTC2_INT_CONFIG_DM_MASK 0x0000000000000700UL
+#define UVH_RTC2_INT_CONFIG_DESTMODE_SHFT 11
+#define UVH_RTC2_INT_CONFIG_DESTMODE_MASK 0x0000000000000800UL
+#define UVH_RTC2_INT_CONFIG_STATUS_SHFT 12
+#define UVH_RTC2_INT_CONFIG_STATUS_MASK 0x0000000000001000UL
+#define UVH_RTC2_INT_CONFIG_P_SHFT 13
+#define UVH_RTC2_INT_CONFIG_P_MASK 0x0000000000002000UL
+#define UVH_RTC2_INT_CONFIG_T_SHFT 15
+#define UVH_RTC2_INT_CONFIG_T_MASK 0x0000000000008000UL
+#define UVH_RTC2_INT_CONFIG_M_SHFT 16
+#define UVH_RTC2_INT_CONFIG_M_MASK 0x0000000000010000UL
+#define UVH_RTC2_INT_CONFIG_APIC_ID_SHFT 32
+#define UVH_RTC2_INT_CONFIG_APIC_ID_MASK 0xffffffff00000000UL
+
+union uvh_rtc2_int_config_u {
+    unsigned long	v;
+    struct uvh_rtc2_int_config_s {
+	unsigned long	vector_  :  8;  /* RW */
+	unsigned long	dm       :  3;  /* RW */
+	unsigned long	destmode :  1;  /* RW */
+	unsigned long	status   :  1;  /* RO */
+	unsigned long	p        :  1;  /* RO */
+	unsigned long	rsvd_14  :  1;  /*    */
+	unsigned long	t        :  1;  /* RO */
+	unsigned long	m        :  1;  /* RW */
+	unsigned long	rsvd_17_31: 15;  /*    */
+	unsigned long	apic_id  : 32;  /* RW */
+    } s;
+};
+
+/* ========================================================================= */
+/*                           UVH_RTC3_INT_CONFIG                             */
+/* ========================================================================= */
+#define UVH_RTC3_INT_CONFIG 0x61640UL
+
+#define UVH_RTC3_INT_CONFIG_VECTOR_SHFT 0
+#define UVH_RTC3_INT_CONFIG_VECTOR_MASK 0x00000000000000ffUL
+#define UVH_RTC3_INT_CONFIG_DM_SHFT 8
+#define UVH_RTC3_INT_CONFIG_DM_MASK 0x0000000000000700UL
+#define UVH_RTC3_INT_CONFIG_DESTMODE_SHFT 11
+#define UVH_RTC3_INT_CONFIG_DESTMODE_MASK 0x0000000000000800UL
+#define UVH_RTC3_INT_CONFIG_STATUS_SHFT 12
+#define UVH_RTC3_INT_CONFIG_STATUS_MASK 0x0000000000001000UL
+#define UVH_RTC3_INT_CONFIG_P_SHFT 13
+#define UVH_RTC3_INT_CONFIG_P_MASK 0x0000000000002000UL
+#define UVH_RTC3_INT_CONFIG_T_SHFT 15
+#define UVH_RTC3_INT_CONFIG_T_MASK 0x0000000000008000UL
+#define UVH_RTC3_INT_CONFIG_M_SHFT 16
+#define UVH_RTC3_INT_CONFIG_M_MASK 0x0000000000010000UL
+#define UVH_RTC3_INT_CONFIG_APIC_ID_SHFT 32
+#define UVH_RTC3_INT_CONFIG_APIC_ID_MASK 0xffffffff00000000UL
+
+union uvh_rtc3_int_config_u {
+    unsigned long	v;
+    struct uvh_rtc3_int_config_s {
+	unsigned long	vector_  :  8;  /* RW */
+	unsigned long	dm       :  3;  /* RW */
+	unsigned long	destmode :  1;  /* RW */
+	unsigned long	status   :  1;  /* RO */
+	unsigned long	p        :  1;  /* RO */
+	unsigned long	rsvd_14  :  1;  /*    */
+	unsigned long	t        :  1;  /* RO */
+	unsigned long	m        :  1;  /* RW */
+	unsigned long	rsvd_17_31: 15;  /*    */
+	unsigned long	apic_id  : 32;  /* RW */
+    } s;
+};
+
+/* ========================================================================= */
+/*                            UVH_RTC_INC_RATIO                              */
+/* ========================================================================= */
+#define UVH_RTC_INC_RATIO 0x350000UL
+
+#define UVH_RTC_INC_RATIO_FRACTION_SHFT 0
+#define UVH_RTC_INC_RATIO_FRACTION_MASK 0x00000000000fffffUL
+#define UVH_RTC_INC_RATIO_RATIO_SHFT 20
+#define UVH_RTC_INC_RATIO_RATIO_MASK 0x0000000000700000UL
+
+union uvh_rtc_inc_ratio_u {
+    unsigned long	v;
+    struct uvh_rtc_inc_ratio_s {
+	unsigned long	fraction : 20;  /* RW */
+	unsigned long	ratio    :  3;  /* RW */
+	unsigned long	rsvd_23_63: 41;  /*    */
+    } s;
+};
+
+/* ========================================================================= */
 /*                          UVH_SI_ADDR_MAP_CONFIG                           */
 /* ========================================================================= */
 #define UVH_SI_ADDR_MAP_CONFIG 0xc80000UL
