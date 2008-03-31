Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbYCaVCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbYCaVCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 17:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755543AbYCaVCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 17:02:15 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:46369 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020AbYCaVCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 17:02:14 -0400
Date: Tue, 1 Apr 2008 00:02:12 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] the scheduled i386/x86_64 bzImage symlinks removal
Message-ID: <20080331210212.GD23259@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the scheduled removal of the i386/x86_64 bzImage 
symlinks.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 Documentation/feature-removal-schedule.txt |   12 ------------
 arch/x86/Makefile                          |    2 --
 2 files changed, 14 deletions(-)

8f683fe014e1897c09cedb0b39078ba3f85a47f4 diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index bf0e3df..1092b2e 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -211,18 +211,6 @@ Who:    Stephen Hemminger <shemminger@linux-foundation.org>
 
 ---------------------------
 
-What:	i386/x86_64 bzImage symlinks
-When:	April 2008
-
-Why:	The i386/x86_64 merge provides a symlink to the old bzImage
-	location so not yet updated user space tools, e.g. package
-	scripts, do not break.
-Who:	Thomas Gleixner <tglx@linutronix.de>
-
----------------------------
-
----------------------------
-
 What:	i2c-i810, i2c-prosavage and i2c-savage4
 When:	May 2008
 Why:	These drivers are superseded by i810fb, intelfb and savagefb.
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index f1e739a..50d3e99 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -215,8 +215,6 @@ zImage zlilo zdisk: KBUILD_IMAGE := arch/x86/boot/zImage
 
 zImage bzImage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(KBUILD_IMAGE)
-	$(Q)mkdir -p $(objtree)/arch/$(UTS_MACHINE)/boot
-	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/$(UTS_MACHINE)/boot/bzImage
 
 compressed: zImage
 

