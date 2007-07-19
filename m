Return-Path: <linux-kernel-owner+w=401wt.eu-S938880AbXGSOFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938880AbXGSOFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933942AbXGSNtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:49:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:48677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765102AbXGSNtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:49:07 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: jbeulich@novell.com, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [35/48] x86_64: remove __smp_alt* sections
Message-Id: <20070719134905.C1FC114E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:49:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
Leftovers from the removal of the more general (but abandoned) SMP
alternatives.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

 arch/x86_64/kernel/vmlinux.lds.S |    9 ---------
 1 file changed, 9 deletions(-)

Index: linux/arch/x86_64/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/x86_64/kernel/vmlinux.lds.S
+++ linux/arch/x86_64/kernel/vmlinux.lds.S
@@ -141,20 +141,11 @@ SECTIONS
   /* might get freed after init */
   . = ALIGN(4096);
   __smp_alt_begin = .;
-  __smp_alt_instructions = .;
-  .smp_altinstructions : AT(ADDR(.smp_altinstructions) - LOAD_OFFSET) {
-	*(.smp_altinstructions)
-  }
-  __smp_alt_instructions_end = .;
-  . = ALIGN(8);
   __smp_locks = .;
   .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
 	*(.smp_locks)
   }
   __smp_locks_end = .;
-  .smp_altinstr_replacement : AT(ADDR(.smp_altinstr_replacement) - LOAD_OFFSET) {
-	*(.smp_altinstr_replacement)
-  }
   . = ALIGN(4096);
   __smp_alt_end = .;
 
