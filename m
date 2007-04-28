Return-Path: <linux-kernel-owner+w=401wt.eu-S1161217AbXD1SRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161217AbXD1SRe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163452AbXD1SP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:15:58 -0400
Received: from ns1.suse.de ([195.135.220.2]:34418 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163290AbXD1Rwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:36 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: "Jan Beulich" <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [11/35] x86_64: adjust inclusion of asm/vsyscall32.h
Message-Id: <20070428175235.8D639151D1@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
Avoid including asm/vsyscall32.h in virtually every source file.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/ia32/syscall32.c |    1 +
 include/asm-x86_64/fixmap.h  |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86_64/ia32/syscall32.c
===================================================================
--- linux.orig/arch/x86_64/ia32/syscall32.c
+++ linux/arch/x86_64/ia32/syscall32.c
@@ -13,6 +13,7 @@
 #include <asm/proto.h>
 #include <asm/tlbflush.h>
 #include <asm/ia32_unistd.h>
+#include <asm/vsyscall32.h>
 
 extern unsigned char syscall32_syscall[], syscall32_syscall_end[];
 extern unsigned char syscall32_sysenter[], syscall32_sysenter_end[];
Index: linux/include/asm-x86_64/fixmap.h
===================================================================
--- linux.orig/include/asm-x86_64/fixmap.h
+++ linux/include/asm-x86_64/fixmap.h
@@ -15,7 +15,6 @@
 #include <asm/apicdef.h>
 #include <asm/page.h>
 #include <asm/vsyscall.h>
-#include <asm/vsyscall32.h>
 
 /*
  * Here we define all the compile-time 'special' virtual
