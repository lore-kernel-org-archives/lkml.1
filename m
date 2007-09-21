Return-Path: <linux-kernel-owner+w=401wt.eu-S932646AbXIUWmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646AbXIUWmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763971AbXIUWch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:37 -0400
Received: from mail.suse.de ([195.135.220.2]:57066 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762379AbXIUWc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:29 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: jbeulich@novell.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [28/50] i386: remove stub early_printk.c
Message-Id: <20070921223227.A49D713DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
.. and handle use of the x86-64 file by make logic instead.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

 arch/i386/kernel/Makefile       |    1 +
 arch/i386/kernel/early_printk.c |    2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

Index: linux/arch/i386/kernel/Makefile
===================================================================
--- linux.orig/arch/i386/kernel/Makefile
+++ linux/arch/i386/kernel/Makefile
@@ -86,6 +86,7 @@ $(obj)/vsyscall-syms.o: $(src)/vsyscall.
 			$(obj)/vsyscall-sysenter.o $(obj)/vsyscall-note.o FORCE
 	$(call if_changed,syscall)
 
+early_printk-y            += ../../x86_64/kernel/early_printk.o
 k8-y                      += ../../x86_64/kernel/k8.o
 stacktrace-y		  += ../../x86_64/kernel/stacktrace.o
 early-quirks-y		  += ../../x86_64/kernel/early-quirks.o
Index: linux/arch/i386/kernel/early_printk.c
===================================================================
--- linux.orig/arch/i386/kernel/early_printk.c
+++ /dev/null
@@ -1,2 +0,0 @@
-
-#include "../../x86_64/kernel/early_printk.c"
