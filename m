Return-Path: <linux-kernel-owner+w=401wt.eu-S1759899AbYGJSqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899AbYGJSqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758753AbYGJSl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:41:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:28099 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757618AbYGJSlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:41:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="409061807"
Message-Id: <20080710182239.635284000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:17:00 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 26/26] x64, x2apic/intr-remap: introduce CONFIG_INTR_REMAP
Content-Disposition: inline; filename=introduce_config_intr_remap.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/arch/x86/Kconfig
===================================================================
--- tree-x86.orig/arch/x86/Kconfig	2008-07-10 09:51:44.000000000 -0700
+++ tree-x86/arch/x86/Kconfig	2008-07-10 09:52:43.000000000 -0700
@@ -1657,6 +1657,14 @@
 	 workaround will setup a 1:1 mapping for the first
 	 16M to make floppy (an ISA device) work.
 
+config INTR_REMAP
+	bool "Support for Interrupt Remapping (EXPERIMENTAL)"
+	depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI && EXPERIMENTAL
+	help
+	 Supports Interrupt remapping for IO-APIC and MSI devices.
+	 To use x2apic mode in the CPU's which support x2APIC enhancements or
+	 to support platforms with CPU's having > 8 bit APIC ID, say Y.
+
 source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pci/Kconfig"

-- 

