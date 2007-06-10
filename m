Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbXFJJiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbXFJJiu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 05:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbXFJJbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 05:31:32 -0400
Received: from www.osadl.org ([213.239.205.134]:43145 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752257AbXFJJbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 05:31:14 -0400
Message-Id: <20070610092447.222892379@inhelltoy.tec.linutronix.de>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 10 Jun 2007 09:44:22 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 23/23] x86_64: enable high resolution timers and dynticks
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
--- linux-2.6.22-rc4-mm.orig/arch/x86_64/Kconfig	2007-06-10 10:44:39.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/x86_64/Kconfig	2007-06-10 10:44:40.000000000 +0200
@@ -146,6 +146,8 @@ source "init/Kconfig"
 
 menu "Processor type and features"
 
+source "kernel/time/Kconfig"
+
 choice
 	prompt "Subarchitecture Type"
 	default X86_PC

-- 

