Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbZAMF33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbZAMF33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 00:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbZAMF3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 00:29:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45903 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbZAMF3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 00:29:19 -0500
Subject: [PATCH -tip] include of <linux/types.h> is preferred over
	<asm/types.h>
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, sam@ravnborg.org, harvey.harrison@gmail.com,
       gorcunov@gmail.com, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 10:56:53 +0530
Message-Id: <1231824413.3212.3.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix 15 make headers_check warnings:

include of <linux/types.h> is preferred over <asm/types.h>

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 include/linux/agpgart.h      |    1 -
 include/linux/atm_idt77105.h |    2 +-
 include/linux/capi.h         |    2 +-
 include/linux/connector.h    |    2 +-
 include/linux/cyclades.h     |    2 --
 include/linux/fb.h           |    2 +-
 include/linux/if_pppol2tp.h  |    2 +-
 include/linux/if_pppox.h     |    2 +-
 include/linux/input.h        |    2 +-
 include/linux/joystick.h     |    2 +-
 include/linux/kvm.h          |    2 +-
 include/linux/loop.h         |    2 +-
 include/linux/matroxfb.h     |    2 +-
 include/linux/phantom.h      |    2 +-
 include/linux/radeonfb.h     |    2 +-
 15 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/include/linux/agpgart.h b/include/linux/agpgart.h
index c8fdb6e..110c600 100644
--- a/include/linux/agpgart.h
+++ b/include/linux/agpgart.h
@@ -52,7 +52,6 @@
 
 #ifndef __KERNEL__
 #include <linux/types.h>
-#include <asm/types.h>
 
 struct agp_version {
 	__u16 major;
diff --git a/include/linux/atm_idt77105.h b/include/linux/atm_idt77105.h
index 05621cf..8b72400 100644
--- a/include/linux/atm_idt77105.h
+++ b/include/linux/atm_idt77105.h
@@ -7,7 +7,7 @@
 #ifndef LINUX_ATM_IDT77105_H
 #define LINUX_ATM_IDT77105_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/atmioc.h>
 #include <linux/atmdev.h>
 
diff --git a/include/linux/capi.h b/include/linux/capi.h
index fdebaaa..65100d6 100644
--- a/include/linux/capi.h
+++ b/include/linux/capi.h
@@ -12,7 +12,7 @@
 #ifndef __LINUX_CAPI_H__
 #define __LINUX_CAPI_H__
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/ioctl.h>
 #ifndef __KERNEL__
 #include <linux/kernelcapi.h>
diff --git a/include/linux/connector.h b/include/linux/connector.h
index 5c7f946..34f2789 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -22,7 +22,7 @@
 #ifndef __CONNECTOR_H
 #define __CONNECTOR_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 
 #define CN_IDX_CONNECTOR		0xffffffff
 #define CN_VAL_CONNECTOR		0xffffffff
diff --git a/include/linux/cyclades.h b/include/linux/cyclades.h
index 2d3d1e0..d06fbf2 100644
--- a/include/linux/cyclades.h
+++ b/include/linux/cyclades.h
@@ -150,8 +150,6 @@ struct CYZ_BOOT_CTRL {
  *	architectures and compilers.
  */
 
-#include <asm/types.h>
-
 typedef __u64  ucdouble;		/* 64 bits, unsigned */
 typedef __u32  uclong;			/* 32 bits, unsigned */
 typedef __u16  ucshort;		/* 16 bits, unsigned */
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 1ee63df..818fe21 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_FB_H
 #define _LINUX_FB_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/i2c.h>
 
 struct dentry;
diff --git a/include/linux/if_pppol2tp.h b/include/linux/if_pppol2tp.h
index a7d6a22..c7a6688 100644
--- a/include/linux/if_pppol2tp.h
+++ b/include/linux/if_pppol2tp.h
@@ -15,7 +15,7 @@
 #ifndef __LINUX_IF_PPPOL2TP_H
 #define __LINUX_IF_PPPOL2TP_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 
 #ifdef __KERNEL__
 #include <linux/in.h>
diff --git a/include/linux/if_pppox.h b/include/linux/if_pppox.h
index 6fb7f17..30c88b2 100644
--- a/include/linux/if_pppox.h
+++ b/include/linux/if_pppox.h
@@ -17,7 +17,7 @@
 #define __LINUX_IF_PPPOX_H
 
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <asm/byteorder.h>
 
 #ifdef  __KERNEL__
diff --git a/include/linux/input.h b/include/linux/input.h
index 9a6355f..1249a0c 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -16,7 +16,7 @@
 #include <sys/time.h>
 #include <sys/ioctl.h>
 #include <sys/types.h>
-#include <asm/types.h>
+#include <linux/types.h>
 #endif
 
 /*
diff --git a/include/linux/joystick.h b/include/linux/joystick.h
index b5e0512..9e20c29 100644
--- a/include/linux/joystick.h
+++ b/include/linux/joystick.h
@@ -27,7 +27,7 @@
  * Vojtech Pavlik, Ucitelska 1576, Prague 8, 182 00 Czech Republic
  */
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/input.h>
 
 /*
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 35525ac..5715f19 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -7,7 +7,7 @@
  * Note: you must update KVM_API_VERSION if you change this interface.
  */
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/ioctl.h>
 #include <asm/kvm.h>
diff --git a/include/linux/loop.h b/include/linux/loop.h
index 46169a7..6ffd6db 100644
--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -80,7 +80,7 @@ enum {
 };
 
 #include <asm/posix_types.h>	/* for __kernel_old_dev_t */
-#include <asm/types.h>		/* for __u64 */
+#include <linux/types.h>	/* for __u64 */
 
 /* Backwards compatibility version */
 struct loop_info {
diff --git a/include/linux/matroxfb.h b/include/linux/matroxfb.h
index ae5b094..404f678 100644
--- a/include/linux/matroxfb.h
+++ b/include/linux/matroxfb.h
@@ -2,7 +2,7 @@
 #define __LINUX_MATROXFB_H__
 
 #include <asm/ioctl.h>
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/videodev2.h>
 
 struct matroxioc_output_mode {
diff --git a/include/linux/phantom.h b/include/linux/phantom.h
index 02268c5..94dd664 100644
--- a/include/linux/phantom.h
+++ b/include/linux/phantom.h
@@ -10,7 +10,7 @@
 #ifndef __PHANTOM_H
 #define __PHANTOM_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 
 /* PHN_(G/S)ET_REG param */
 struct phm_reg {
diff --git a/include/linux/radeonfb.h b/include/linux/radeonfb.h
index 5bd8975..8c4bbde 100644
--- a/include/linux/radeonfb.h
+++ b/include/linux/radeonfb.h
@@ -2,7 +2,7 @@
 #define __LINUX_RADEONFB_H__
 
 #include <asm/ioctl.h>
-#include <asm/types.h>
+#include <linux/types.h>
 
 #define ATY_RADEON_LCD_ON	0x00000001
 #define ATY_RADEON_CRT_ON	0x00000002
-- 
1.5.6.6



