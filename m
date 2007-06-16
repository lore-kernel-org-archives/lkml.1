Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbXFPKcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbXFPKcW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 06:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbXFPKYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 06:24:39 -0400
Received: from www.osadl.org ([213.239.205.134]:37271 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753605AbXFPKY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 06:24:29 -0400
Message-Id: <20070616101637.508135170@inhelltoy.tec.linutronix.de>
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 16 Jun 2007 10:36:26 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch-mm 25/25] x86_64: enable high resolution timers and dynticks
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
--- linux-2.6.22-rc4-mm.orig/arch/x86_64/Kconfig	2007-06-16 12:10:24.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/x86_64/Kconfig	2007-06-16 12:10:25.000000000 +0200
@@ -150,6 +150,8 @@ source "init/Kconfig"
 
 menu "Processor type and features"
 
+source "kernel/time/Kconfig"
+
 choice
 	prompt "Subarchitecture Type"
 	default X86_PC

-- 

