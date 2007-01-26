Return-Path: <linux-kernel-owner+w=401wt.eu-S1161116AbXAZSHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161116AbXAZSHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161121AbXAZSHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:07:22 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:38017 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161116AbXAZSHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:07:21 -0500
X-Originating-Ip: 74.109.98.130
Date: Fri, 26 Jan 2007 13:06:39 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH] Remove final vestiges of CONFIG_UNWIND_INFO.
Message-ID: <Pine.LNX.4.64.0701261301590.27767@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Remove the sole remaining reference to the apparently dead config
variable CONFIG_UNWIND_INFO.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  there doesn't seem to be much point in leaving this in if nothing's
using it.

diff --git a/include/asm-i386/dwarf2.h b/include/asm-i386/dwarf2.h
index 6d66398..4985afe 100644
--- a/include/asm-i386/dwarf2.h
+++ b/include/asm-i386/dwarf2.h
@@ -12,30 +12,6 @@
    away for older version.
  */

-#ifdef CONFIG_UNWIND_INFO
-
-#define CFI_STARTPROC .cfi_startproc
-#define CFI_ENDPROC .cfi_endproc
-#define CFI_DEF_CFA .cfi_def_cfa
-#define CFI_DEF_CFA_REGISTER .cfi_def_cfa_register
-#define CFI_DEF_CFA_OFFSET .cfi_def_cfa_offset
-#define CFI_ADJUST_CFA_OFFSET .cfi_adjust_cfa_offset
-#define CFI_OFFSET .cfi_offset
-#define CFI_REL_OFFSET .cfi_rel_offset
-#define CFI_REGISTER .cfi_register
-#define CFI_RESTORE .cfi_restore
-#define CFI_REMEMBER_STATE .cfi_remember_state
-#define CFI_RESTORE_STATE .cfi_restore_state
-#define CFI_UNDEFINED .cfi_undefined
-
-#ifdef CONFIG_AS_CFI_SIGNAL_FRAME
-#define CFI_SIGNAL_FRAME .cfi_signal_frame
-#else
-#define CFI_SIGNAL_FRAME
-#endif
-
-#else
-
 /* Due to the structure of pre-exisiting code, don't use assembler line
    comment character # to ignore the arguments. Instead, use a dummy macro. */
 .macro ignore a=0, b=0, c=0, d=0
@@ -57,5 +33,3 @@
 #define CFI_SIGNAL_FRAME ignore

 #endif
-
-#endif

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
