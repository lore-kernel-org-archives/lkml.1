Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbYENPQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbYENPQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760771AbYENPPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:15:31 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45792 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760700AbYENPPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:15:30 -0400
From: Paul Jackson <pj@sgi.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>
Date: Wed, 14 May 2008 08:15:28 -0700
Message-Id: <20080514151528.148486.31672.sendpatchset@jackhammer.engr.sgi.com>
In-Reply-To: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
References: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH 5/10] x86 boot: minor code format fixes in e820 and efi routines
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Standardize a few pointer declarations to not have the
extra space after the '*' character.

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 arch/x86/kernel/e820_32.c |    2 +-
 arch/x86/kernel/e820_64.c |    2 +-
 arch/x86/kernel/efi_64.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- 2.6.26-rc2-mm1.orig/arch/x86/kernel/e820_32.c	2008-05-14 02:27:19.659222093 -0700
+++ 2.6.26-rc2-mm1/arch/x86/kernel/e820_32.c	2008-05-14 02:50:11.450652182 -0700
@@ -280,7 +280,7 @@ void __init add_memory_region(unsigned l
  * replaces the original e820 map with a new one, removing overlaps.
  *
  */
-int __init sanitize_e820_map(struct e820entry * biosmap, char * pnr_map)
+int __init sanitize_e820_map(struct e820entry *biosmap, char *pnr_map)
 {
 	struct change_member *change_tmp;
 	unsigned long current_type, last_type;
--- 2.6.26-rc2-mm1.orig/arch/x86/kernel/e820_64.c	2008-05-14 02:27:19.687222570 -0700
+++ 2.6.26-rc2-mm1/arch/x86/kernel/e820_64.c	2008-05-14 03:04:29.540729012 -0700
@@ -740,7 +740,7 @@ static void early_panic(char *msg)
 }
 
 /* We're not void only for x86 32-bit compat */
-char * __init machine_specific_memory_setup(void)
+char *__init machine_specific_memory_setup(void)
 {
 	char *who = "BIOS-e820";
 	/*
--- 2.6.26-rc2-mm1.orig/arch/x86/kernel/efi_64.c	2008-05-14 02:27:19.783224204 -0700
+++ 2.6.26-rc2-mm1/arch/x86/kernel/efi_64.c	2008-05-14 02:50:11.474652591 -0700
@@ -103,7 +103,7 @@ void __init efi_reserve_bootmem(void)
 				memmap.nr_map * memmap.desc_size);
 }
 
-void __iomem * __init efi_ioremap(unsigned long phys_addr, unsigned long size)
+void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size)
 {
 	static unsigned pages_mapped __initdata;
 	unsigned i, pages;

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
