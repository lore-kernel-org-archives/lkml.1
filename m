Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbZDTUPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbZDTUPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbZDTUPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:15:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:54557 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756032AbZDTUP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:15:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,219,1239001200"; 
   d="scan'208";a="508192091"
Message-Id: <20090420200450.694598000@linux-os.sc.intel.com>
References: <20090420200450.128993000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 20 Apr 2009 13:02:31 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Weidong Han <weidong.han@intel.com>, Jack Steiner <steiner@sgi.com>
Subject: [patch 5/5] x2apic, IR: Make config X86_UV dependent on X86_X2APIC
Content-Disposition: inline; filename=fix_uv_x_config.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of selecting X86_X2APIC, make config X86_UV dependent on X86_X2APIC.
This will eliminate enabling CONFIG_X86_X2APIC with out enabling
CONFIG_INTR_REMAP.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Weidong Han <weidong.han@intel.com>
Cc: Jack Steiner <steiner@sgi.com>
---

Index: tip/arch/x86/Kconfig
===================================================================
--- tip.orig/arch/x86/Kconfig
+++ tip/arch/x86/Kconfig
@@ -356,7 +356,7 @@ config X86_UV
 	depends on X86_64
 	depends on X86_EXTENDED_PLATFORM
 	depends on NUMA
-	select X86_X2APIC
+	depends on X86_X2APIC
 	---help---
 	  This option is needed in order to support SGI Ultraviolet systems.
 	  If you don't have one of these, you should say N here.

-- 

