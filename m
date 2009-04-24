Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbZDXHpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbZDXHpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 03:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZDXHoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 03:44:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:2249 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbZDXHox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 03:44:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,240,1239001200"; 
   d="scan'208";a="451040912"
Date: Fri, 24 Apr 2009 09:44:48 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch] x86, bts: reenable ptrace branch trace support
Message-ID: <20090424094448.A30216@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The races found by Oleg Nesterov have been fixed.

Reenable branch trace support.


CC: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/Kconfig.cpu |    1 	0 +	1 -	0 !
 1 files changed, 1 deletion(-)

Index: b/arch/x86/Kconfig.cpu
===================================================================
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -506,7 +506,6 @@ config X86_PTRACE_BTS
 	bool "Branch Trace Store"
 	default y
 	depends on X86_DEBUGCTLMSR
-	depends on BROKEN
 	---help---
 	  This adds a ptrace interface to the hardware's branch trace store.
 
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

