Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbYFNSpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbYFNSpS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 14:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbYFNSpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 14:45:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:18547 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352AbYFNSo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 14:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=aa5/Q4CqmvaheALSo+nWtHCxxjDnc6saHszueACwcBAPyXcLYnAOmF6pGecqSwsaml
         QzJD/eN331mU30OAYDS7PaXLELAYkbhNzKAvRWYnaFw6jEygSvENC0bvMf97B1cUbkB/
         mM48qj/oaK2y5taZ5tUffn9OeOD9Pzhxfyo4w=
Date: Sat, 14 Jun 2008 20:44:52 +0200
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, tglx <tglx@linutronix.de>,
       hpa <hpa@zytor.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: coding style fixes to arch/x86/math-emu/reg_constant
Message-ID: <20080614204452.25378bd0@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:
total: 6 errors, 1 warnings, 117 lines checked

After:
total: 0 errors, 1 warnings, 117 lines checked

paolo@paolo-desktop:~/linux.trees.git$ md5sum /tmp/reg_constant.o.*
780388a3056d58fb759efaf190d5d3d1  /tmp/reg_constant.o.after
780388a3056d58fb759efaf190d5d3d1  /tmp/reg_constant.o.before

paolo@paolo-desktop:~/linux.trees.git$ size /tmp/reg_constant.o.*
   text    data     bss     dec     hex filename
    457       0       0     457     1c9 /tmp/reg_constant.o.after
    457       0       0     457     1c9 /tmp/reg_constant.o.before


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/math-emu/reg_constant.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/math-emu/reg_constant.c b/arch/x86/math-emu/reg_constant.c
index 04869e6..0054835 100644
--- a/arch/x86/math-emu/reg_constant.c
+++ b/arch/x86/math-emu/reg_constant.c
@@ -16,8 +16,8 @@
 #include "reg_constant.h"
 #include "control_w.h"
 
-#define MAKE_REG(s,e,l,h) { l, h, \
-                            ((EXTENDED_Ebias+(e)) | ((SIGN_##s != 0)*0x8000)) }
+#define MAKE_REG(s, e, l, h) { l, h, \
+		((EXTENDED_Ebias+(e)) | ((SIGN_##s != 0)*0x8000)) }
 
 FPU_REG const CONST_1 = MAKE_REG(POS, 0, 0x00000000, 0x80000000);
 #if 0
@@ -40,7 +40,7 @@ FPU_REG const CONST_PI2extra = MAKE_REG(NEG, -66,
 FPU_REG const CONST_Z = MAKE_REG(POS, EXP_UNDER, 0x0, 0x0);
 
 /* Only the sign and significand (and tag) are used in internal NaNs */
-/* The 80486 never generates one of these 
+/* The 80486 never generates one of these
 FPU_REG const CONST_SNAN = MAKE_REG(POS, EXP_OVER, 0x00000001, 0x80000000);
  */
 /* This is the real indefinite QNaN */
@@ -49,7 +49,7 @@ FPU_REG const CONST_QNaN = MAKE_REG(NEG, EXP_OVER, 0x00000000, 0xC0000000);
 /* Only the sign (and tag) is used in internal infinities */
 FPU_REG const CONST_INF = MAKE_REG(POS, EXP_OVER, 0x00000000, 0x80000000);
 
-static void fld_const(FPU_REG const *c, int adj, u_char tag)
+static void fld_const(FPU_REG const * c, int adj, u_char tag)
 {
 	FPU_REG *st_new_ptr;
 
-- 
1.5.6.rc1.21.g03300

