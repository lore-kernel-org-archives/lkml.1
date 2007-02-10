Return-Path: <linux-kernel-owner+w=401wt.eu-S933414AbXBJLu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414AbXBJLu5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933412AbXBJLu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:50:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933408AbXBJLuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:50:50 -0500
From: Andi Kleen <ak@suse.de>
References: <200702101250.142420000@suse.de>
In-Reply-To: <200702101250.142420000@suse.de>
To: Adrian Bunk <bunk@stusta.de>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21 review I] [25/25] i386: arch/i386/kernel/e820.c should #include <asm/setup.h
Message-Id: <20070210115038.A5E4913DDE@wotan.suse.de>
Date: Sat, 10 Feb 2007 12:50:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Adrian Bunk <bunk@stusta.de>

Every file should #include the headers containing the prototypes for
its global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/e820.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/i386/kernel/e820.c
===================================================================
--- linux.orig/arch/i386/kernel/e820.c
+++ linux/arch/i386/kernel/e820.c
@@ -14,6 +14,7 @@
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/e820.h>
+#include <asm/setup.h>
 
 #ifdef CONFIG_EFI
 int efi_enabled = 0;
