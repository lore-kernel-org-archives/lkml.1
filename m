Return-Path: <linux-kernel-owner+w=401wt.eu-S1761665AbXFWNbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761665AbXFWNbZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758218AbXFWNWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:22:36 -0400
Received: from www.osadl.org ([213.239.205.134]:59335 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757150AbXFWNWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:22:22 -0400
Message-Id: <20070623124031.406753630@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 23 Jun 2007 13:32:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch -mm 28/28] x86_64: enable high resolution timers and dynticks
Content-Disposition: inline; filename=x86-64-enable-highres-dyntick.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Chris Wright <chrisw@sous-sol.org>

Everything is in place, enable the HIGHRES andf NO_HZ config options.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>

---
 arch/x86_64/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.22-rc4-mm/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/x86_64/Kconfig	2007-06-23 14:39:00.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/x86_64/Kconfig	2007-06-23 14:39:01.000000000 +0200
@@ -150,6 +150,8 @@ source "init/Kconfig"
 
 menu "Processor type and features"
 
+source "kernel/time/Kconfig"
+
 choice
 	prompt "Subarchitecture Type"
 	default X86_PC

-- 

