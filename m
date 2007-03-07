Return-Path: <linux-kernel-owner+w=401wt.eu-S1161285AbXCGH3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161285AbXCGH3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 02:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161293AbXCGH3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 02:29:07 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44997 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161285AbXCGH3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 02:29:04 -0500
Date: Wed, 7 Mar 2007 12:33:44 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       pavel@suse.cz, rjw@sisk.pl
Subject: [PATCH 4/20] x86_64: Fix early printk to use standard ISA mapping
Message-ID: <20070307070344.GE23412@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070307065703.GA23412@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307065703.GA23412@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
---

 arch/x86_64/kernel/early_printk.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/x86_64/kernel/early_printk.c~x86_64-fix-early_printk-to-use-the-standard-ISA-mapping arch/x86_64/kernel/early_printk.c
--- linux-2.6.21-rc2-reloc/arch/x86_64/kernel/early_printk.c~x86_64-fix-early_printk-to-use-the-standard-ISA-mapping	2007-03-07 01:22:33.000000000 +0530
+++ linux-2.6.21-rc2-reloc-root/arch/x86_64/kernel/early_printk.c	2007-03-07 01:22:33.000000000 +0530
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
_
