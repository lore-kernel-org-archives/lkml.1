Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbZIIHbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbZIIHbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 03:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZIIHbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 03:31:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbZIIHbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 03:31:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: Add missing linux/tracehook.h #inclusions
To: jmorris@namei.org, sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Wed, 09 Sep 2009 08:30:21 +0100
Message-ID: <20090909073021.21257.61971.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090908104012.ff4bd25f.sfr@canb.auug.org.au>
References: <20090908104012.ff4bd25f.sfr@canb.auug.org.au>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add #inclusions of linux/tracehook.h to those arch files that had the tracehook
call for TIF_NOTIFY_RESUME added when support for that flag was added to that
arch.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/alpha/kernel/signal.c  |    1 +
 arch/arm/kernel/signal.c    |    1 +
 arch/avr32/kernel/signal.c  |    1 +
 arch/cris/kernel/ptrace.c   |    1 +
 arch/h8300/kernel/signal.c  |    1 +
 arch/m32r/kernel/signal.c   |    1 +
 arch/mips/kernel/signal.c   |    1 +
 arch/parisc/kernel/signal.c |    1 +
 8 files changed, 8 insertions(+), 0 deletions(-)


diff --git a/arch/alpha/kernel/signal.c b/arch/alpha/kernel/signal.c
index d91aaa7..0932dbb 100644
--- a/arch/alpha/kernel/signal.c
+++ b/arch/alpha/kernel/signal.c
@@ -20,6 +20,7 @@
 #include <linux/binfmts.h>
 #include <linux/bitops.h>
 #include <linux/syscalls.h>
+#include <linux/tracehook.h>
 
 #include <asm/uaccess.h>
 #include <asm/sigcontext.h>
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index ea4ad3a..b76fe06 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -12,6 +12,7 @@
 #include <linux/personality.h>
 #include <linux/freezer.h>
 #include <linux/uaccess.h>
+#include <linux/tracehook.h>
 
 #include <asm/elf.h>
 #include <asm/cacheflush.h>
diff --git a/arch/avr32/kernel/signal.c b/arch/avr32/kernel/signal.c
index de9f7fe..64f886f 100644
--- a/arch/avr32/kernel/signal.c
+++ b/arch/avr32/kernel/signal.c
@@ -16,6 +16,7 @@
 #include <linux/ptrace.h>
 #include <linux/unistd.h>
 #include <linux/freezer.h>
+#include <linux/tracehook.h>
 
 #include <asm/uaccess.h>
 #include <asm/ucontext.h>
diff --git a/arch/cris/kernel/ptrace.c b/arch/cris/kernel/ptrace.c
index 32e9d5e..48b0f39 100644
--- a/arch/cris/kernel/ptrace.c
+++ b/arch/cris/kernel/ptrace.c
@@ -16,6 +16,7 @@
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
+#include <linux/tracehook.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
diff --git a/arch/h8300/kernel/signal.c b/arch/h8300/kernel/signal.c
index abac3ee..af842c3 100644
--- a/arch/h8300/kernel/signal.c
+++ b/arch/h8300/kernel/signal.c
@@ -39,6 +39,7 @@
 #include <linux/tty.h>
 #include <linux/binfmts.h>
 #include <linux/freezer.h>
+#include <linux/tracehook.h>
 
 #include <asm/setup.h>
 #include <asm/uaccess.h>
diff --git a/arch/m32r/kernel/signal.c b/arch/m32r/kernel/signal.c
index f80bac1..144b0f1 100644
--- a/arch/m32r/kernel/signal.c
+++ b/arch/m32r/kernel/signal.c
@@ -21,6 +21,7 @@
 #include <linux/stddef.h>
 #include <linux/personality.h>
 #include <linux/freezer.h>
+#include <linux/tracehook.h>
 #include <asm/cacheflush.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
diff --git a/arch/mips/kernel/signal.c b/arch/mips/kernel/signal.c
index c2acf31..6254041 100644
--- a/arch/mips/kernel/signal.c
+++ b/arch/mips/kernel/signal.c
@@ -21,6 +21,7 @@
 #include <linux/compiler.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
+#include <linux/tracehook.h>
 
 #include <asm/abi.h>
 #include <asm/asm.h>
diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
index 5ca1c02..8eb3c63 100644
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -25,6 +25,7 @@
 #include <linux/stddef.h>
 #include <linux/compat.h>
 #include <linux/elf.h>
+#include <linux/tracehook.h>
 #include <asm/ucontext.h>
 #include <asm/rt_sigframe.h>
 #include <asm/uaccess.h>

