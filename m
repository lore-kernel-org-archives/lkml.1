Return-Path: <linux-kernel-owner+w=401wt.eu-S1946408AbXEAECw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946408AbXEAECw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946421AbXEAEBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:01:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:48958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946438AbXEAD6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:08 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [10/30] x86_64: Drop -traditional for arch/x86_64/boot
Message-Id: <20070501035807.C40B613CAF@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:07 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Follows i386 and useful cleanup.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/boot/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86_64/boot/Makefile
===================================================================
--- linux.orig/arch/x86_64/boot/Makefile
+++ linux/arch/x86_64/boot/Makefile
@@ -36,7 +36,7 @@ subdir-		:= compressed/	#Let make clean 
 # ---------------------------------------------------------------------------
 
 $(obj)/bzImage: IMAGE_OFFSET := 0x100000
-$(obj)/bzImage: EXTRA_AFLAGS := -traditional $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
+$(obj)/bzImage: EXTRA_AFLAGS := $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
 $(obj)/bzImage: BUILDFLAGS   := -b
 
 quiet_cmd_image = BUILD   $@
