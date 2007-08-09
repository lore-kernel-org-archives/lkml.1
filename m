Return-Path: <linux-kernel-owner+w=401wt.eu-S938890AbXHIIWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938890AbXHIIWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 04:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938220AbXHIIVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 04:21:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:23214 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938096AbXHIIVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 04:21:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,239,1183359600"; 
   d="scan'208";a="276570389"
Subject: [PATCH 2/2] x86_64 EFI boot support: EFI boot document
From: "Huang, Ying" <ying.huang@intel.com>
To: Andi Kleen <ak@suse.de>, akpm@linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 09 Aug 2007 16:20:36 +0800
Message-Id: <1186647636.15539.16.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 09 Aug 2007 08:20:23.0232 (UTC) FILETIME=[21CEA400:01C7DA5E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds document for EFI x86_64 boot support. The setup and
operation guide of EFI based system is documented in
Documentation/x86_64/uefi.txt.

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>

 uefi.txt |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

Index: linux-2.6.23-rc2/Documentation/x86_64/uefi.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.23-rc2/Documentation/x86_64/uefi.txt	2007-08-09 09:58:57.000000000 +0800
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
