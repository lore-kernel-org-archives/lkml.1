Return-Path: <linux-kernel-owner+w=401wt.eu-S1163357AbXD1SAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163357AbXD1SAz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163348AbXD1R7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:59:03 -0400
Received: from ns1.suse.de ([195.135.220.2]:34674 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031939AbXD1R6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:58:52 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428758.455116000@suse.de>
In-Reply-To: <20070428758.455116000@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [5/22] x86_64: Fix early printk to use standard ISA mapping
Message-Id: <20070428175851.CD6E7151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:58:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Vivek Goyal <vgoyal@in.ibm.com>



Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/early_printk.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux/arch/x86_64/kernel/early_printk.c
===================================================================
--- linux.orig/arch/x86_64/kernel/early_printk.c
+++ linux/arch/x86_64/kernel/early_printk.c
@@ -11,11 +11,10 @@
 
 #ifdef __i386__
 #include <asm/setup.h>
-#define VGABASE		(__ISA_IO_base + 0xb8000)
 #else
 #include <asm/bootsetup.h>
-#define VGABASE		((void __iomem *)0xffffffff800b8000UL)
 #endif
+#define VGABASE		(__ISA_IO_base + 0xb8000)
 
 static int max_ypos = 25, max_xpos = 80;
 static int current_ypos = 25, current_xpos = 0;
