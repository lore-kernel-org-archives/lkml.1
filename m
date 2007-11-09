Return-Path: <linux-kernel-owner+w=401wt.eu-S1759844AbXKIXWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759844AbXKIXWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757897AbXKIXTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:19:22 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:60650 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486AbXKIXTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:19:08 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 10/11] x86: drop backward compatibility symlinks to i386/boot and x86_64/boot
Date: Sat, 10 Nov 2007 00:20:44 +0100
Message-Id: <11946504463205-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <20071109230812.GA5176@uranus.ravnborg.org>
References: <20071109230812.GA5176@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the final step of full transition to the
unified x86 architecture from the build system point of view.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/Makefile_32 |    2 --
 arch/x86/Makefile_64 |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Makefile_32 b/arch/x86/Makefile_32
index 346ac07..45c2ddf 100644
--- a/arch/x86/Makefile_32
+++ b/arch/x86/Makefile_32
@@ -138,8 +138,6 @@ zImage zlilo zdisk: KBUILD_IMAGE := arch/x86/boot/zImage
 
 zImage bzImage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(KBUILD_IMAGE)
-	$(Q)mkdir -p $(objtree)/arch/i386/boot
-	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/i386/boot/bzImage
 
 compressed: zImage
 
diff --git a/arch/x86/Makefile_64 b/arch/x86/Makefile_64
index 57e714a..660288d 100644
--- a/arch/x86/Makefile_64
+++ b/arch/x86/Makefile_64
@@ -101,8 +101,6 @@ KBUILD_IMAGE                  := $(BOOTIMAGE)
 
 bzImage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(BOOTIMAGE)
-	$(Q)mkdir -p $(objtree)/arch/x86_64/boot
-	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/x86_64/boot/bzImage
 
 bzlilo: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) zlilo
-- 
1.5.3.4.1157.g0e74-dirty

