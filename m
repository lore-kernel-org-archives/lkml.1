Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbYGKUSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbYGKUSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261AbYGKUR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:17:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:2955 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbYGKURz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:17:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,347,1212390000"; 
   d="scan'208";a="355062090"
Message-Id: <20080711201442.769225000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 11 Jul 2008 13:11:55 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, x86@kernel.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/3] x2apic: uninline uv_init_apic_ldr()
Content-Disposition: inline; filename=fix_inline_uv.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew says:
> There's no point in declaring it inline if it's always called indirectly.

And point taken!

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/genx2apic_uv_x.c	2008-07-11 10:58:31.000000000 -0700
+++ tree-x86/arch/x86/kernel/genx2apic_uv_x.c	2008-07-11 11:03:45.000000000 -0700
@@ -120,7 +120,7 @@
 	return 1;
 }
 
-static inline void uv_init_apic_ldr(void)
+static void uv_init_apic_ldr(void)
 {
 }
 

-- 

