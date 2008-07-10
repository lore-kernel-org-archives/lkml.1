Return-Path: <linux-kernel-owner+w=401wt.eu-S1760847AbYGJSnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760847AbYGJSnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757921AbYGJSls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:41:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:60434 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755851AbYGJSlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:41:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="409061683"
Message-Id: <20080710182238.916522000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:55 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 21/26] x64, x2apic/intr-remap: setup init_apic_ldr for UV
Content-Disposition: inline; filename=uv_init_apic_ldr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Jack Steiner <steiner@sgi.com>
---

Index: tree-x86/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/genx2apic_uv_x.c	2008-07-10 09:52:12.000000000 -0700
+++ tree-x86/arch/x86/kernel/genx2apic_uv_x.c	2008-07-10 09:52:29.000000000 -0700
@@ -120,6 +120,10 @@
 	return 1;
 }
 
+static inline void uv_init_apic_ldr(void)
+{
+}
+
 static unsigned int uv_cpu_mask_to_apicid(cpumask_t cpumask)
 {
 	int cpu;
@@ -164,6 +168,7 @@
 	.target_cpus = uv_target_cpus,
 	.vector_allocation_domain = uv_vector_allocation_domain,/* Fixme ZZZ */
 	.apic_id_registered = uv_apic_id_registered,
+	.init_apic_ldr = uv_init_apic_ldr,
 	.send_IPI_all = uv_send_IPI_all,
 	.send_IPI_allbutself = uv_send_IPI_allbutself,
 	.send_IPI_mask = uv_send_IPI_mask,

-- 

