Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbZGUVR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbZGUVR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085AbZGUVR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:17:28 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:54744 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931AbZGUVP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:15:58 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
       <linux-arch@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 08/10] drop unneeded include of autoconf.h
Date: Tue, 21 Jul 2009 23:19:39 +0200
Message-Id: <1248211181-6757-8-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <20090721211040.GA7688@merkur.ravnborg.org>
References: <20090721211040.GA7688@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kbuild.h forces include of autoconf.h on the
commandline using -include - so we do not need to
include the file explicit.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/cris/arch-v32/kernel/head.S                |    1 -
 arch/cris/kernel/asm-offsets.c                  |    1 -
 arch/cris/kernel/vmlinux.lds.S                  |    1 -
 arch/ia64/kvm/asm-offsets.c                     |    1 -
 drivers/accessibility/braille/braille_console.c |    1 -
 drivers/hid/hid-lg.h                            |    2 --
 drivers/platform/x86/compal-laptop.c            |    1 -
 include/linux/mmdebug.h                         |    2 --
 8 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/head.S b/arch/cris/arch-v32/kernel/head.S
index 3db478e..76266f8 100644
--- a/arch/cris/arch-v32/kernel/head.S
+++ b/arch/cris/arch-v32/kernel/head.S
@@ -10,7 +10,6 @@
  * The macros found in mmu_defs_asm.h uses the ## concatenation operator, so
  * -traditional must not be used when assembling this file.
  */
-#include <linux/autoconf.h>
 #include <arch/memmap.h>
 #include <hwregs/reg_rdwr.h>
 #include <hwregs/intr_vect.h>
diff --git a/arch/cris/kernel/asm-offsets.c b/arch/cris/kernel/asm-offsets.c
index ddd6fbb..dd7b8e9 100644
--- a/arch/cris/kernel/asm-offsets.c
+++ b/arch/cris/kernel/asm-offsets.c
@@ -1,6 +1,5 @@
 #include <linux/sched.h>
 #include <asm/thread_info.h>
-#include <linux/autoconf.h>
 
 /*
  * Generate definitions needed by assembly language modules.
diff --git a/arch/cris/kernel/vmlinux.lds.S b/arch/cris/kernel/vmlinux.lds.S
index 0d2adfc..8a80d78 100644
--- a/arch/cris/kernel/vmlinux.lds.S
+++ b/arch/cris/kernel/vmlinux.lds.S
@@ -8,7 +8,6 @@
  * the kernel has booted.
  */
 
-#include <linux/autoconf.h>
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/page.h>
 
diff --git a/arch/ia64/kvm/asm-offsets.c b/arch/ia64/kvm/asm-offsets.c
index 0c3564a..9324c87 100644
--- a/arch/ia64/kvm/asm-offsets.c
+++ b/arch/ia64/kvm/asm-offsets.c
@@ -22,7 +22,6 @@
  *
  */
 
-#include <linux/autoconf.h>
 #include <linux/kvm_host.h>
 #include <linux/kbuild.h>
 
diff --git a/drivers/accessibility/braille/braille_console.c b/drivers/accessibility/braille/braille_console.c
index d672cfe..cb423f5 100644
--- a/drivers/accessibility/braille/braille_console.c
+++ b/drivers/accessibility/braille/braille_console.c
@@ -21,7 +21,6 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/autoconf.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
diff --git a/drivers/hid/hid-lg.h b/drivers/hid/hid-lg.h
index 27ae750..bf31592 100644
--- a/drivers/hid/hid-lg.h
+++ b/drivers/hid/hid-lg.h
@@ -1,8 +1,6 @@
 #ifndef __HID_LG_H
 #define __HID_LG_H
 
-#include <linux/autoconf.h>
-
 #ifdef CONFIG_LOGITECH_FF
 int lgff_init(struct hid_device *hdev);
 #else
diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index 11003bb..1a387e7 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -51,7 +51,6 @@
 #include <linux/dmi.h>
 #include <linux/backlight.h>
 #include <linux/platform_device.h>
-#include <linux/autoconf.h>
 
 #define COMPAL_DRIVER_VERSION "0.2.6"
 
diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
index 8a55098..ee24ef8 100644
--- a/include/linux/mmdebug.h
+++ b/include/linux/mmdebug.h
@@ -1,8 +1,6 @@
 #ifndef LINUX_MM_DEBUG_H
 #define LINUX_MM_DEBUG_H 1
 
-#include <linux/autoconf.h>
-
 #ifdef CONFIG_DEBUG_VM
 #define VM_BUG_ON(cond) BUG_ON(cond)
 #else
-- 
1.6.2.5

