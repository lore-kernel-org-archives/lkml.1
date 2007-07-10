Return-Path: <linux-kernel-owner+w=401wt.eu-S1759686AbXGJFMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686AbXGJFMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 01:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbXGJFMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 01:12:03 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42970 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbXGJFMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 01:12:00 -0400
Date: Tue, 10 Jul 2007 10:43:35 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       davem@davemloft.net, dwilder@us.ibm.com, hskinnemoen@atmel.com,
       akpm@linux-foundation.org, Jim Keniston <jkenisto@us.ibm.com>,
       rpjday@mindspring.com, srikar@linux.vnet.ibm.com
Subject: [PATCH] Kprobes on select architectures no longer EXPERIMENTAL
Message-ID: <20070710051335.GA30663@in.ibm.com>
Reply-To: ananth@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Based on usage and testing over the past couple of years, kprobes on
i386, ia64, powerpc and x86_64 is no longer EXPERIMENTAL.

This is a follow-up to Robert P.J. Day's patch making "Instrumentation
support" non-EXPERIMENTAL:

	http://marc.info/?l=linux-kernel&m=118396955423812&w=2

Arch maintainers for sparc64, avr32 and s390 need to take a similar call.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 arch/i386/Kconfig    |    4 ++--
 arch/ia64/Kconfig    |    4 ++--
 arch/powerpc/Kconfig |    4 ++--
 arch/x86_64/Kconfig  |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6.22/arch/i386/Kconfig
===================================================================
--- linux-2.6.22.orig/arch/i386/Kconfig
+++ linux-2.6.22/arch/i386/Kconfig
@@ -1218,8 +1218,8 @@ menu "Instrumentation Support"
 source "arch/i386/oprofile/Kconfig"
 
 config KPROBES
-	bool "Kprobes (EXPERIMENTAL)"
-	depends on KALLSYMS && EXPERIMENTAL && MODULES
+	bool "Kprobes"
+	depends on KALLSYMS && MODULES
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
Index: linux-2.6.22/arch/ia64/Kconfig
===================================================================
--- linux-2.6.22.orig/arch/ia64/Kconfig
+++ linux-2.6.22/arch/ia64/Kconfig
@@ -580,8 +580,8 @@ menu "Instrumentation Support"
 source "arch/ia64/oprofile/Kconfig"
 
 config KPROBES
-	bool "Kprobes (EXPERIMENTAL)"
-	depends on KALLSYMS && EXPERIMENTAL && MODULES
+	bool "Kprobes"
+	depends on KALLSYMS && MODULES
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
Index: linux-2.6.22/arch/powerpc/Kconfig
===================================================================
--- linux-2.6.22.orig/arch/powerpc/Kconfig
+++ linux-2.6.22/arch/powerpc/Kconfig
@@ -894,8 +894,8 @@ menu "Instrumentation Support"
 source "arch/powerpc/oprofile/Kconfig"
 
 config KPROBES
-	bool "Kprobes (EXPERIMENTAL)"
-	depends on !BOOKE && !4xx && KALLSYMS && EXPERIMENTAL && MODULES
+	bool "Kprobes"
+	depends on !BOOKE && !4xx && KALLSYMS && MODULES
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
Index: linux-2.6.22/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.22.orig/arch/x86_64/Kconfig
+++ linux-2.6.22/arch/x86_64/Kconfig
@@ -770,8 +770,8 @@ menu "Instrumentation Support"
 source "arch/x86_64/oprofile/Kconfig"
 
 config KPROBES
-	bool "Kprobes (EXPERIMENTAL)"
-	depends on KALLSYMS && EXPERIMENTAL && MODULES
+	bool "Kprobes"
+	depends on KALLSYMS && MODULES
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
