Return-Path: <linux-kernel-owner+w=401wt.eu-S965606AbXD3Kat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965606AbXD3Kat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965564AbXD3K3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:29:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965287AbXD3K2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:28:05 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [30/40] x86: update for i386 and x86-64 check_bugs
Message-Id: <20070430102804.DE17F151D3@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:28:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>

Remove spurious comments, headers and keywords from x86-64 bugs.[ch].

Use identify_boot_cpu()

AK: merged with other patch

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/bugs.c |    9 +--------
 include/asm-i386/bugs.h   |    2 +-
 2 files changed, 2 insertions(+), 9 deletions(-)

===================================================================
Index: linux/arch/x86_64/kernel/bugs.c
===================================================================
--- linux.orig/arch/x86_64/kernel/bugs.c
+++ linux/arch/x86_64/kernel/bugs.c
@@ -3,19 +3,12 @@
  *
  *  Copyright (C) 1994  Linus Torvalds
  *  Copyright (C) 2000  SuSE
- *
- * This is included by init/main.c to check for architecture-dependent bugs.
- *
- * Needs:
- *	void check_bugs(void);
  */
 
 #include <linux/kernel.h>
+#include <linux/init.h>
 #include <asm/alternative.h>
 #include <asm/processor.h>
-#include <asm/i387.h>
-#include <asm/msr.h>
-#include <asm/pda.h>
 
 void __init check_bugs(void)
 {
Index: linux/include/asm-i386/bugs.h
===================================================================
--- linux.orig/include/asm-i386/bugs.h
+++ linux/include/asm-i386/bugs.h
@@ -7,6 +7,6 @@
 #ifndef _ASM_I386_BUG_H
 #define _ASM_I386_BUG_H
 
-extern void __init check_bugs(void);
+void check_bugs(void);
 
 #endif	/* _ASM_I386_BUG_H */
