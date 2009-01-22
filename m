Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbZAVRyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbZAVRyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760124AbZAVRuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:50:39 -0500
Received: from relay2.sgi.com ([192.48.179.30]:39028 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759364AbZAVRu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:50:29 -0500
Message-Id: <20090122175025.834895000@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 22 Jan 2009 11:49:19 -0600
From: steiner@sgi.com
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 02/14] Add definitions of ia64 GRU MMRs.
References: <20090122174917.563627000@sgi.com>
Content-Disposition: inline; filename=uv_mmrs_gru_ia64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Add definitions for IA64 GRU MMRs.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 arch/ia64/include/asm/uv/uv_mmrs.h |  158 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 155 insertions(+), 3 deletions(-)

Index: linux/arch/ia64/include/asm/uv/uv_mmrs.h
===================================================================
--- linux.orig/arch/ia64/include/asm/uv/uv_mmrs.h	2009-01-11 07:28:11.000000000 -0600
+++ linux/arch/ia64/include/asm/uv/uv_mmrs.h	2009-01-11 07:28:34.000000000 -0600
@@ -8,8 +8,8 @@
  * Copyright (C) 2007-2008 Silicon Graphics, Inc. All rights reserved.
  */
 
-#ifndef __ASM_IA64_UV_MMRS__
-#define __ASM_IA64_UV_MMRS__
+#ifndef _ASM_IA64_UV_UV_MMRS_H
+#define _ASM_IA64_UV_UV_MMRS_H
 
 #define UV_MMR_ENABLE		(1UL << 63)
 
@@ -243,6 +243,158 @@ union uvh_event_occurred0_u {
 #define UVH_EVENT_OCCURRED0_ALIAS_32 0x005f0
 
 /* ========================================================================= */
+/*                         UVH_GR0_TLB_INT0_CONFIG                           */
+/* ========================================================================= */
+#define UVH_GR0_TLB_INT0_CONFIG 0x61b00UL
+
+#define UVH_GR0_TLB_INT0_CONFIG_VECTOR_SHFT 0
+#define UVH_GR0_TLB_INT0_CONFIG_VECTOR_MASK 0x00000000000000ffUL
+#define UVH_GR0_TLB_INT0_CONFIG_DM_SHFT 8
+#define UVH_GR0_TLB_INT0_CONFIG_DM_MASK 0x0000000000000700UL
+#define UVH_GR0_TLB_INT0_CONFIG_DESTMODE_SHFT 11
+#define UVH_GR0_TLB_INT0_CONFIG_DESTMODE_MASK 0x0000000000000800UL
+#define UVH_GR0_TLB_INT0_CONFIG_STATUS_SHFT 12
+#define UVH_GR0_TLB_INT0_CONFIG_STATUS_MASK 0x0000000000001000UL
+#define UVH_GR0_TLB_INT0_CONFIG_P_SHFT 13
+#define UVH_GR0_TLB_INT0_CONFIG_P_MASK 0x0000000000002000UL
+#define UVH_GR0_TLB_INT0_CONFIG_T_SHFT 15
+#define UVH_GR0_TLB_INT0_CONFIG_T_MASK 0x0000000000008000UL
+#define UVH_GR0_TLB_INT0_CONFIG_M_SHFT 16
+#define UVH_GR0_TLB_INT0_CONFIG_M_MASK 0x0000000000010000UL
+#define UVH_GR0_TLB_INT0_CONFIG_APIC_ID_SHFT 32
+#define UVH_GR0_TLB_INT0_CONFIG_APIC_ID_MASK 0xffffffff00000000UL
+
+union uvh_gr0_tlb_int0_config_u {
+    unsigned long	v;
+    struct uvh_gr0_tlb_int0_config_s {
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
+/*                         UVH_GR0_TLB_INT1_CONFIG                           */
+/* ========================================================================= */
+#define UVH_GR0_TLB_INT1_CONFIG 0x61b40UL
+
+#define UVH_GR0_TLB_INT1_CONFIG_VECTOR_SHFT 0
+#define UVH_GR0_TLB_INT1_CONFIG_VECTOR_MASK 0x00000000000000ffUL
+#define UVH_GR0_TLB_INT1_CONFIG_DM_SHFT 8
+#define UVH_GR0_TLB_INT1_CONFIG_DM_MASK 0x0000000000000700UL
+#define UVH_GR0_TLB_INT1_CONFIG_DESTMODE_SHFT 11
+#define UVH_GR0_TLB_INT1_CONFIG_DESTMODE_MASK 0x0000000000000800UL
+#define UVH_GR0_TLB_INT1_CONFIG_STATUS_SHFT 12
+#define UVH_GR0_TLB_INT1_CONFIG_STATUS_MASK 0x0000000000001000UL
+#define UVH_GR0_TLB_INT1_CONFIG_P_SHFT 13
+#define UVH_GR0_TLB_INT1_CONFIG_P_MASK 0x0000000000002000UL
+#define UVH_GR0_TLB_INT1_CONFIG_T_SHFT 15
+#define UVH_GR0_TLB_INT1_CONFIG_T_MASK 0x0000000000008000UL
+#define UVH_GR0_TLB_INT1_CONFIG_M_SHFT 16
+#define UVH_GR0_TLB_INT1_CONFIG_M_MASK 0x0000000000010000UL
+#define UVH_GR0_TLB_INT1_CONFIG_APIC_ID_SHFT 32
+#define UVH_GR0_TLB_INT1_CONFIG_APIC_ID_MASK 0xffffffff00000000UL
+
+union uvh_gr0_tlb_int1_config_u {
+    unsigned long	v;
+    struct uvh_gr0_tlb_int1_config_s {
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
+/*                         UVH_GR1_TLB_INT0_CONFIG                           */
+/* ========================================================================= */
+#define UVH_GR1_TLB_INT0_CONFIG 0x61f00UL
+
+#define UVH_GR1_TLB_INT0_CONFIG_VECTOR_SHFT 0
+#define UVH_GR1_TLB_INT0_CONFIG_VECTOR_MASK 0x00000000000000ffUL
+#define UVH_GR1_TLB_INT0_CONFIG_DM_SHFT 8
+#define UVH_GR1_TLB_INT0_CONFIG_DM_MASK 0x0000000000000700UL
+#define UVH_GR1_TLB_INT0_CONFIG_DESTMODE_SHFT 11
+#define UVH_GR1_TLB_INT0_CONFIG_DESTMODE_MASK 0x0000000000000800UL
+#define UVH_GR1_TLB_INT0_CONFIG_STATUS_SHFT 12
+#define UVH_GR1_TLB_INT0_CONFIG_STATUS_MASK 0x0000000000001000UL
+#define UVH_GR1_TLB_INT0_CONFIG_P_SHFT 13
+#define UVH_GR1_TLB_INT0_CONFIG_P_MASK 0x0000000000002000UL
+#define UVH_GR1_TLB_INT0_CONFIG_T_SHFT 15
+#define UVH_GR1_TLB_INT0_CONFIG_T_MASK 0x0000000000008000UL
+#define UVH_GR1_TLB_INT0_CONFIG_M_SHFT 16
+#define UVH_GR1_TLB_INT0_CONFIG_M_MASK 0x0000000000010000UL
+#define UVH_GR1_TLB_INT0_CONFIG_APIC_ID_SHFT 32
+#define UVH_GR1_TLB_INT0_CONFIG_APIC_ID_MASK 0xffffffff00000000UL
+
+union uvh_gr1_tlb_int0_config_u {
+    unsigned long	v;
+    struct uvh_gr1_tlb_int0_config_s {
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
+/*                         UVH_GR1_TLB_INT1_CONFIG                           */
+/* ========================================================================= */
+#define UVH_GR1_TLB_INT1_CONFIG 0x61f40UL
+
+#define UVH_GR1_TLB_INT1_CONFIG_VECTOR_SHFT 0
+#define UVH_GR1_TLB_INT1_CONFIG_VECTOR_MASK 0x00000000000000ffUL
+#define UVH_GR1_TLB_INT1_CONFIG_DM_SHFT 8
+#define UVH_GR1_TLB_INT1_CONFIG_DM_MASK 0x0000000000000700UL
+#define UVH_GR1_TLB_INT1_CONFIG_DESTMODE_SHFT 11
+#define UVH_GR1_TLB_INT1_CONFIG_DESTMODE_MASK 0x0000000000000800UL
+#define UVH_GR1_TLB_INT1_CONFIG_STATUS_SHFT 12
+#define UVH_GR1_TLB_INT1_CONFIG_STATUS_MASK 0x0000000000001000UL
+#define UVH_GR1_TLB_INT1_CONFIG_P_SHFT 13
+#define UVH_GR1_TLB_INT1_CONFIG_P_MASK 0x0000000000002000UL
+#define UVH_GR1_TLB_INT1_CONFIG_T_SHFT 15
+#define UVH_GR1_TLB_INT1_CONFIG_T_MASK 0x0000000000008000UL
+#define UVH_GR1_TLB_INT1_CONFIG_M_SHFT 16
+#define UVH_GR1_TLB_INT1_CONFIG_M_MASK 0x0000000000010000UL
+#define UVH_GR1_TLB_INT1_CONFIG_APIC_ID_SHFT 32
+#define UVH_GR1_TLB_INT1_CONFIG_APIC_ID_MASK 0xffffffff00000000UL
+
+union uvh_gr1_tlb_int1_config_u {
+    unsigned long	v;
+    struct uvh_gr1_tlb_int1_config_s {
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
 /*                               UVH_INT_CMPB                                */
 /* ========================================================================= */
 #define UVH_INT_CMPB 0x22080UL
@@ -670,4 +822,4 @@ union uvh_si_alias2_overlay_config_u {
 };
 
 
-#endif /* __ASM_IA64_UV_MMRS__ */
+#endif /* _ASM_IA64_UV_UV_MMRS_H */

