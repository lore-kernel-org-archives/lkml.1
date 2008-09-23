Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbYIWXcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYIWXcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 19:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbYIWXcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 19:32:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42762 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbYIWXcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 19:32:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: Add missing idle.h include to process_32.c
Date: Wed, 24 Sep 2008 01:37:39 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809240137.40403.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This fixes a very recent compilation breakage on 32-bit x86.

Please apply.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

x86: Add missing idle.h include to process_32.c

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/process_32.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process_32.c
+++ linux-2.6/arch/x86/kernel/process_32.c
@@ -55,6 +55,7 @@
 #include <asm/tlbflush.h>
 #include <asm/cpu.h>
 #include <asm/kdebug.h>
+#include <asm/idle.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
