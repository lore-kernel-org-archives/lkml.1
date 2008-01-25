Return-Path: <linux-kernel-owner+w=401wt.eu-S1755615AbYAYF5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbYAYF5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 00:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbYAYF4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 00:56:53 -0500
Received: from mga03.intel.com ([143.182.124.21]:39197 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbYAYF4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 00:56:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,248,1199692800"; 
   d="scan'208";a="371109572"
Subject: [PATCH 5/6] x86: use reboot_type on EFI 32
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Jan 2008 13:55:04 +0800
Message-Id: <1201240504.15972.47.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 25 Jan 2008 05:54:21.0886 (UTC) FILETIME=[BB7315E0:01C85F16]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes reboot_type of BOOT_EFI is used on i386 too. Because
correpsonding reboot code of i386 and x86_64 is merged.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/efi.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -371,11 +371,9 @@ void __init efi_init(void)
 		printk(KERN_WARNING "Kernel-defined memdesc"
 		       "doesn't match the one from EFI!\n");
 
-#ifdef CONFIG_X86_64
 	/* Setup for EFI runtime service */
 	reboot_type = BOOT_EFI;
 
-#endif
 #if EFI_DEBUG
 	print_efi_memmap();
 #endif

