Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbZBXNMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbZBXNMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 08:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbZBXNMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 08:12:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:5584 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbZBXNMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 08:12:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,259,1233561600"; 
   d="scan'208";a="492638751"
Date: Tue, 24 Feb 2009 14:12:34 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com
Subject: [patch] x86, ptrace: remove CONFIG guards around declarations
Message-ID: <20090224141234.A26125@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary CONFIG guards around type declarations and macro
definitions.


Reported-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: ftrace/arch/x86/include/asm/ptrace-abi.h
===================================================================
--- ftrace.orig/arch/x86/include/asm/ptrace-abi.h
+++ ftrace/arch/x86/include/asm/ptrace-abi.h
@@ -80,8 +80,6 @@
 
 #define PTRACE_SINGLEBLOCK	33	/* resume execution until next branch */
 
-#ifdef CONFIG_X86_PTRACE_BTS
-
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
 
@@ -140,6 +138,5 @@ struct ptrace_bts_config {
    BTS records are read from oldest to newest.
    Returns number of BTS records drained.
 */
-#endif /* CONFIG_X86_PTRACE_BTS */
 
 #endif /* _ASM_X86_PTRACE_ABI_H */
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

