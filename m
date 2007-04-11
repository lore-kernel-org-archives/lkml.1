Return-Path: <linux-kernel-owner+w=401wt.eu-S1753433AbXDKR40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753433AbXDKR40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 13:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbXDKR40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 13:56:26 -0400
Received: from terminus.zytor.com ([192.83.249.54]:51253 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753433AbXDKR4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 13:56:25 -0400
Date: Wed, 11 Apr 2007 10:56:20 -0700
Message-Id: <200704111756.l3BHuKYZ017169@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Clean up after over-efficient machine formatting
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The recent patch cleanup up, among other things, msr.h, used a script
to canonicalize the formatting.  Unfortunately it also formatted the
EFER bit numbers as 32-bit expanded hex, which is ridiculous.  Clean up.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff -urN --exclude 'o.*' --exclude '*~' stock/linux-2.6.21-rc6-mm1-cc1/include/asm-i386/msr-index.h linux-2.6.21-rc6-mm1/include/asm-i386/msr-index.h
--- stock/linux-2.6.21-rc6-mm1-cc1/include/asm-i386/msr-index.h	2007-04-11 10:51:06.000000000 -0700
+++ linux-2.6.21-rc6-mm1/include/asm-i386/msr-index.h	2007-04-10 10:57:06.000000000 -0700
@@ -12,10 +12,10 @@
 #define MSR_KERNEL_GS_BASE	0xc0000102 /* SwapGS GS shadow */
 
 /* EFER bits: */
-#define _EFER_SCE		0x00000000 /* SYSCALL/SYSRET */
-#define _EFER_LME		0x00000008 /* Long mode enable */
-#define _EFER_LMA		0x0000000a /* Long mode active (read-only) */
-#define _EFER_NX		0x0000000b /* No execute enable */
+#define _EFER_SCE		 0 /* SYSCALL/SYSRET */
+#define _EFER_LME		 8 /* Long mode enable */
+#define _EFER_LMA		10 /* Long mode active (read-only) */
+#define _EFER_NX		11 /* No execute enable */
 
 #define EFER_SCE		(1<<_EFER_SCE)
 #define EFER_LME		(1<<_EFER_LME)
