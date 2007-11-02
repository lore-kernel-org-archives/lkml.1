Return-Path: <linux-kernel-owner+w=401wt.eu-S1761165AbXKBCFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761165AbXKBCFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 22:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbXKBCF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 22:05:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:41585 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbXKBCFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 22:05:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,360,1188802800"; 
   d="scan'208";a="231427132"
Subject: [PATCH 2/2 -v3] x86_64 EFI boot support: EFI boot document
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: akpm@linux-foundation.org, Andi Kleen <ak@suse.de>,
       "Antonino A. Daplas" <adaplas@pol.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 02 Nov 2007 10:08:18 +0800
Message-Id: <1193969298.11724.18.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 02 Nov 2007 02:05:10.0767 (UTC) FILETIME=[CC71D7F0:01C81CF4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds document for EFI x86_64 boot support. The setup and
operation guide of EFI based system is documented in
Documentation/x86_64/uefi.txt.

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 Documentation/x86_64/uefi.txt |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

Index: linux-2.6.24-rc1/Documentation/x86_64/uefi.txt
===================================================================
--- /dev/null
+++ linux-2.6.24-rc1/Documentation/x86_64/uefi.txt
@@ -0,0 +1,29 @@
+General note on [U]EFI x86_64 support
+-------------------------------------
+
+The nomenclature EFI and UEFI are used interchangeably in this document.
+
+Although the tools below are _not_ needed for building the kernel,
+the needed bootloader support and associated tools for x86_64 platforms
+with EFI firmware and specifications are listed below.
+
+1. UEFI specification:  http://www.uefi.org
+
+2. Booting Linux kernel on UEFI x86_64 platform requires bootloader
+   support. Elilo with x86_64 support can be used.
+
+3. x86_64 platform with EFI/UEFI firmware.
+
+Mechanics:
+---------
+- Build the kernel with the following configuration.
+	CONFIG_FB_EFI=y
+	CONFIG_FRAMEBUFFER_CONSOLE=y
+- Create a VFAT partition on the disk
+- Copy the following to the VFAT partition:
+	elilo bootloader with x86_64 support, elilo configuration file,
+	kernel image built in first step and corresponding
+	initrd. Instructions on building elilo	and its dependencies
+	can be found in the elilo sourceforge project.
+- Boot to EFI shell and invoke elilo choosing the kernel image built
+  in first step.
