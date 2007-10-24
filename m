Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbXJXJaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbXJXJaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 05:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbXJXJ3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 05:29:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:30266 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbXJXJ3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:29:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,323,1188802800"; 
   d="scan'208";a="184743228"
Subject: [PATCH 2/2 -v2 resend] x86_64 EFI boot support: EFI boot document
From: "Huang, Ying" <ying.huang@intel.com>
To: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Antonino A. Daplas" <adaplas@pol.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 24 Oct 2007 17:32:32 +0800
Message-Id: <1193218352.23935.149.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 24 Oct 2007 09:29:47.0581 (UTC) FILETIME=[6B58DED0:01C81620]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds document for EFI x86_64 boot support. The setup and
operation guide of EFI based system is documented in
Documentation/x86_64/uefi.txt.

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>

---

 uefi.txt |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

Index: linux-2.6.24-rc1/Documentation/x86_64/uefi.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.24-rc1/Documentation/x86_64/uefi.txt	2007-10-24 17:10:21.000000000 +0800
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
