Return-Path: <linux-kernel-owner+w=401wt.eu-S2992972AbXDRSBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992972AbXDRSBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 14:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992973AbXDRSBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 14:01:32 -0400
Received: from verein.lst.de ([213.95.11.210]:54852 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992972AbXDRSBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 14:01:31 -0400
Date: Wed, 18 Apr 2007 20:01:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: akpm@osdl.org, roland@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] utrace: remove exports
Message-ID: <20070418180113.GA18485@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0.925 () BAYES_20,DOMAIN_BODY
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All the exports in utrace are totally unused, and not really something
I'd want modules to use anyway :)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/i386/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/i386/kernel/ptrace.c	2007-04-13 15:56:17.000000000 +0200
+++ linux-2.6/arch/i386/kernel/ptrace.c	2007-04-13 15:56:20.000000000 +0200
@@ -729,7 +729,6 @@ const struct utrace_regset_view utrace_i
 	.name = "i386", .e_machine = EM_386,
 	.regsets = native_regsets, .n = ARRAY_SIZE(native_regsets)
 };
-EXPORT_SYMBOL_GPL(utrace_i386_native);
 
 #ifdef CONFIG_PTRACE
 static const struct ptrace_layout_segment i386_uarea[] = {
Index: linux-2.6/arch/ia64/ia32/sys_ia32.c
===================================================================
--- linux-2.6.orig/arch/ia64/ia32/sys_ia32.c	2007-04-13 15:55:26.000000000 +0200
+++ linux-2.6/arch/ia64/ia32/sys_ia32.c	2007-04-13 15:55:29.000000000 +0200
@@ -2337,7 +2337,6 @@ const struct utrace_regset_view utrace_i
 	.name = "i386", .e_machine = EM_386,
 	.regsets = ia32_regsets, .n = ARRAY_SIZE(ia32_regsets)
 };
-EXPORT_SYMBOL_GPL(utrace_ia32_view);
 
 #ifdef CONFIG_PTRACE
 /*
Index: linux-2.6/arch/ia64/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/ptrace.c	2007-04-13 15:55:33.000000000 +0200
+++ linux-2.6/arch/ia64/kernel/ptrace.c	2007-04-13 15:55:35.000000000 +0200
@@ -1547,7 +1547,6 @@ const struct utrace_regset_view utrace_i
 	.e_machine = EM_IA_64,
 	.regsets = native_regsets, .n = ARRAY_SIZE(native_regsets)
 };
-EXPORT_SYMBOL_GPL(utrace_ia64_native);
 
 #ifdef CONFIG_PTRACE
 
Index: linux-2.6/arch/powerpc/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/ptrace.c	2007-04-13 15:56:03.000000000 +0200
+++ linux-2.6/arch/powerpc/kernel/ptrace.c	2007-04-13 15:56:07.000000000 +0200
@@ -346,8 +346,6 @@ const struct utrace_regset_view utrace_p
 	.name = UTS_MACHINE, .e_machine = ELF_ARCH,
 	.regsets = native_regsets, .n = ARRAY_SIZE(native_regsets)
 };
-EXPORT_SYMBOL_GPL(utrace_ppc_native_view);
-
 
 #ifdef CONFIG_PPC64
 #include <linux/compat.h>
@@ -458,7 +456,6 @@ const struct utrace_regset_view utrace_p
 	.name = "ppc", .e_machine = EM_PPC,
 	.regsets = ppc32_regsets, .n = ARRAY_SIZE(ppc32_regsets)
 };
-EXPORT_SYMBOL_GPL(utrace_ppc32_view);
 #endif
 
 
Index: linux-2.6/arch/s390/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/ptrace.c	2007-04-13 15:55:07.000000000 +0200
+++ linux-2.6/arch/s390/kernel/ptrace.c	2007-04-13 15:55:14.000000000 +0200
@@ -315,8 +315,6 @@ const struct utrace_regset_view utrace_s
 	.name = UTS_MACHINE, .e_machine = ELF_ARCH,
 	.regsets = native_regsets, .n = ARRAY_SIZE(native_regsets)
 };
-EXPORT_SYMBOL_GPL(utrace_s390_native_view);
-
 
 #ifdef CONFIG_COMPAT
 static int
@@ -564,7 +562,6 @@ const struct utrace_regset_view utrace_s
 	.name = "s390", .e_machine = EM_S390,
 	.regsets = s390_compat_regsets, .n = ARRAY_SIZE(s390_compat_regsets)
 };
-EXPORT_SYMBOL_GPL(utrace_s390_compat_view);
 #endif	/* CONFIG_COMPAT */
 
 
Index: linux-2.6/arch/sparc64/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/sparc64/kernel/ptrace.c	2007-04-13 15:55:45.000000000 +0200
+++ linux-2.6/arch/sparc64/kernel/ptrace.c	2007-04-13 15:55:53.000000000 +0200
@@ -258,7 +258,6 @@ const struct utrace_regset_view utrace_s
 	.name = UTS_MACHINE, .e_machine = ELF_ARCH,
 	.regsets = native_regsets, .n = ARRAY_SIZE(native_regsets)
 };
-EXPORT_SYMBOL_GPL(utrace_sparc64_native_view);
 
 #ifdef CONFIG_COMPAT
 
@@ -596,7 +595,6 @@ const struct utrace_regset_view utrace_s
 	.name = "sparc", .e_machine = EM_SPARC,
 	.regsets = sparc32_regsets, .n = ARRAY_SIZE(sparc32_regsets)
 };
-EXPORT_SYMBOL_GPL(utrace_sparc32_view);
 
 #endif	/* CONFIG_COMPAT */
 
Index: linux-2.6/arch/x86_64/ia32/ptrace32.c
===================================================================
--- linux-2.6.orig/arch/x86_64/ia32/ptrace32.c	2007-04-13 15:54:42.000000000 +0200
+++ linux-2.6/arch/x86_64/ia32/ptrace32.c	2007-04-13 15:54:46.000000000 +0200
@@ -596,8 +596,6 @@ const struct utrace_regset_view utrace_i
 	.name = "i386", .e_machine = EM_386,
 	.regsets = ia32_regsets, .n = ARRAY_SIZE(ia32_regsets)
 };
-EXPORT_SYMBOL_GPL(utrace_ia32_view);
-
 
 #ifdef CONFIG_PTRACE
 /*
Index: linux-2.6/arch/x86_64/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/x86_64/kernel/ptrace.c	2007-04-13 15:54:50.000000000 +0200
+++ linux-2.6/arch/x86_64/kernel/ptrace.c	2007-04-13 15:54:54.000000000 +0200
@@ -703,8 +703,6 @@ const struct utrace_regset_view utrace_x
 	.name = "x86-64", .e_machine = EM_X86_64,
 	.regsets = native_regsets, .n = ARRAY_SIZE(native_regsets)
 };
-EXPORT_SYMBOL_GPL(utrace_x86_64_native);
-
 
 #ifdef CONFIG_PTRACE
 static const struct ptrace_layout_segment x86_64_uarea[] = {
Index: linux-2.6/kernel/utrace.c
===================================================================
--- linux-2.6.orig/kernel/utrace.c	2007-04-13 15:56:28.000000000 +0200
+++ linux-2.6/kernel/utrace.c	2007-04-13 15:56:39.000000000 +0200
@@ -490,7 +490,6 @@ restart:
 
 	return engine;
 }
-EXPORT_SYMBOL_GPL(utrace_attach);
 
 /*
  * When an engine is detached, the target thread may still see it and make
@@ -700,8 +699,6 @@ utrace_detach(struct task_struct *target
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(utrace_detach);
-
 
 /*
  * Called with utrace->lock held.
@@ -900,8 +897,7 @@ restart:			/* See below. */
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(utrace_set_flags);
-
+
 /*
  * While running an engine callback, no locks are held.
  * If a callback updates its engine's action state, then
@@ -1930,8 +1926,6 @@ utrace_inject_signal(struct task_struct 
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(utrace_inject_signal);
-
 
 const struct utrace_regset *
 utrace_regset(struct task_struct *target,
@@ -1946,8 +1940,6 @@ utrace_regset(struct task_struct *target
 
 	return &view->regsets[which];
 }
-EXPORT_SYMBOL_GPL(utrace_regset);
-
 
 /*
  * Return the task_struct for the task using ptrace on this one, or NULL.
