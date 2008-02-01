Return-Path: <linux-kernel-owner+w=401wt.eu-S1764932AbYBAFOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764932AbYBAFOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 00:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbYBAFOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 00:14:31 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:40871 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbYBAFOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 00:14:30 -0500
Date: Fri, 1 Feb 2008 00:13:58 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@osdl.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] fix directory entry in arch-x86-Makefile
Message-ID: <Pine.LNX.4.58.0802010011180.10877@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Doing a make randconfig I came across this error in the Makefile.

This patch makes a directory out of arch/x86/mach-default for
CONFIG_X86_RDC321X

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

---
 arch/x86/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-compile-i386.git/arch/x86/Makefile
===================================================================
--- linux-compile-i386.git.orig/arch/x86/Makefile	2008-01-31 21:00:44.000000000 -0500
+++ linux-compile-i386.git/arch/x86/Makefile	2008-02-01 00:09:54.000000000 -0500
@@ -143,7 +143,7 @@ mcore-$(CONFIG_X86_ES7000)	:= arch/x86/m

 # RDC R-321x subarch support
 mflags-$(CONFIG_X86_RDC321X)	:= -Iinclude/asm-x86/mach-rdc321x
-mcore-$(CONFIG_X86_RDC321X)	:= arch/x86/mach-default
+mcore-$(CONFIG_X86_RDC321X)	:= arch/x86/mach-default/
 core-$(CONFIG_X86_RDC321X)	+= arch/x86/mach-rdc321x/

 # default subarch .h files

