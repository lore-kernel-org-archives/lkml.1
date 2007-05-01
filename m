Return-Path: <linux-kernel-owner+w=401wt.eu-S1946440AbXEAECH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946440AbXEAECH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946438AbXEAEBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:01:46 -0400
Received: from ns1.suse.de ([195.135.220.2]:60924 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946456AbXEAD6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:09 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [11/30] i386: Drop -traditional in arch/i386/boot
Message-Id: <20070501035808.D3F3E13CAF@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Needed for followon patch

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/boot/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/i386/boot/Makefile
===================================================================
--- linux.orig/arch/i386/boot/Makefile
+++ linux/arch/i386/boot/Makefile
@@ -36,9 +36,9 @@ HOSTCFLAGS_build.o := $(LINUXINCLUDE)
 # ---------------------------------------------------------------------------
 
 $(obj)/zImage:  IMAGE_OFFSET := 0x1000
-$(obj)/zImage:  EXTRA_AFLAGS := -traditional $(SVGA_MODE) $(RAMDISK)
+$(obj)/zImage:  EXTRA_AFLAGS := $(SVGA_MODE) $(RAMDISK)
 $(obj)/bzImage: IMAGE_OFFSET := 0x100000
-$(obj)/bzImage: EXTRA_AFLAGS := -traditional $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
+$(obj)/bzImage: EXTRA_AFLAGS := $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
 $(obj)/bzImage: BUILDFLAGS   := -b
 
 quiet_cmd_image = BUILD   $@
