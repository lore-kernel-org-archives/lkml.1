Return-Path: <linux-kernel-owner+w=401wt.eu-S1760172AbXFDSk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbXFDSk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758199AbXFDSkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:40:17 -0400
Received: from sicnat2.emn.fr ([193.54.76.193]:36089 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754342AbXFDSkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:40:15 -0400
From: Yoann Padioleau <padator@wanadoo.fr>
To: kernel-janitors@lists.osdl.org
Cc: matthew@wil.cx, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] old declaration ritchie style fix in arch/parisc/math-emu/
Date: Mon, 04 Jun 2007 20:38:08 +0200
Message-ID: <877iqjr2en.fsf@wanadoo.fr>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Use consistent function ANSI declaration style.

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr> 





 dfadd.c       |   10 +++++-----
 fmpyfadd.c    |   30 ++++++++++++++++++------------
 fpudispatch.c |   22 ++++++----------------
 3 files changed, 29 insertions(+), 33 deletions(-)


diff --git a/arch/parisc/math-emu/dfadd.c b/arch/parisc/math-emu/dfadd.c
index e147d7d..5a7d524 100644
--- a/arch/parisc/math-emu/dfadd.c
+++ b/arch/parisc/math-emu/dfadd.c
@@ -45,11 +45,11 @@ #include "dbl_float.h"
 /*
  * Double_add: add two double precision values.
  */
-dbl_fadd(
-    dbl_floating_point *leftptr,
-    dbl_floating_point *rightptr,
-    dbl_floating_point *dstptr,
-    unsigned int *status)
+int dbl_fadd(
+	dbl_floating_point *leftptr,
+	dbl_floating_point *rightptr,
+	dbl_floating_point *dstptr,
+	unsigned int *status)
 {
     register unsigned int signless_upper_left, signless_upper_right, save;
     register unsigned int leftp1, leftp2, rightp1, rightp2, extent;
diff --git a/arch/parisc/math-emu/fmpyfadd.c b/arch/parisc/math-emu/fmpyfadd.c
index 5dd7f93..c0a0f28 100644
--- a/arch/parisc/math-emu/fmpyfadd.c
+++ b/arch/parisc/math-emu/fmpyfadd.c
@@ -716,10 +716,12 @@ dbl_fmpyfadd(
  *  Double Floating-point Multiply Negate Fused Add
  */
 
-dbl_fmpynfadd(src1ptr,src2ptr,src3ptr,status,dstptr)
-
-dbl_floating_point *src1ptr, *src2ptr, *src3ptr, *dstptr;
-unsigned int *status;
+int dbl_fmpynfadd(
+	dbl_floating_point *src1ptr,
+	dbl_floating_point *src2ptr,
+	dbl_floating_point *src3ptr,
+	unsigned int *status,
+	dbl_floating_point *dstptr)
 {
 	unsigned int opnd1p1, opnd1p2, opnd2p1, opnd2p2, opnd3p1, opnd3p2;
 	register unsigned int tmpresp1, tmpresp2, tmpresp3, tmpresp4;
@@ -1374,10 +1376,12 @@ unsigned int *status;
  *  Single Floating-point Multiply Fused Add
  */
 
-sgl_fmpyfadd(src1ptr,src2ptr,src3ptr,status,dstptr)
-
-sgl_floating_point *src1ptr, *src2ptr, *src3ptr, *dstptr;
-unsigned int *status;
+int sgl_fmpyfadd(
+	sgl_floating_point *src1ptr,
+	sgl_floating_point *src2ptr,
+	sgl_floating_point *src3ptr,
+	unsigned int *status,
+	sgl_floating_point *dstptr)
 {
 	unsigned int opnd1, opnd2, opnd3;
 	register unsigned int tmpresp1, tmpresp2;
@@ -2015,10 +2019,12 @@ unsigned int *status;
  *  Single Floating-point Multiply Negate Fused Add
  */
 
-sgl_fmpynfadd(src1ptr,src2ptr,src3ptr,status,dstptr)
-
-sgl_floating_point *src1ptr, *src2ptr, *src3ptr, *dstptr;
-unsigned int *status;
+int sgl_fmpynfadd(
+	sgl_floating_point *src1ptr,
+	sgl_floating_point *src2ptr,
+	sgl_floating_point *src3ptr,
+	unsigned int *status,
+	sgl_floating_point *dstptr)
 {
 	unsigned int opnd1, opnd2, opnd3;
 	register unsigned int tmpresp1, tmpresp2;
diff --git a/arch/parisc/math-emu/fpudispatch.c b/arch/parisc/math-emu/fpudispatch.c
index 6e28f9f..f8fa3f9 100644
--- a/arch/parisc/math-emu/fpudispatch.c
+++ b/arch/parisc/math-emu/fpudispatch.c
@@ -701,9 +701,7 @@ decode_0c(u_int ir, u_int class, u_int s
 }
 
 static u_int
-decode_0e(ir,class,subop,fpregs)
-u_int ir,class,subop;
-u_int fpregs[];
+decode_0e(u_int ir, u_int class, u_int subop, u_int fpregs[])
 {
 	u_int r1,r2,t;		/* operand register offsets */
 	u_int fmt;		/* also sf for class 1 conversions */
@@ -1113,9 +1111,7 @@ u_int fpregs[];
  * routine to decode the 06 (FMPYADD and FMPYCFXT) instruction
  */
 static u_int
-decode_06(ir,fpregs)
-u_int ir;
-u_int fpregs[];
+decode_06(u_int ir,u_int fpregs[])
 {
 	u_int rm1, rm2, tm, ra, ta; /* operands */
 	u_int fmt;
@@ -1253,9 +1249,7 @@ u_int fpregs[];
  * routine to decode the 26 (FMPYSUB) instruction
  */
 static u_int
-decode_26(ir,fpregs)
-u_int ir;
-u_int fpregs[];
+decode_26(u_int ir,u_int fpregs[])
 {
 	u_int rm1, rm2, tm, ra, ta; /* operands */
 	u_int fmt;
@@ -1344,9 +1338,7 @@ u_int fpregs[];
  * routine to decode the 2E (FMPYFADD,FMPYNFADD) instructions
  */
 static u_int
-decode_2e(ir,fpregs)
-u_int ir;
-u_int fpregs[];
+decode_2e(u_int ir, u_int fpregs[])
 {
 	u_int rm1, rm2, ra, t; /* operands */
 	u_int fmt;
@@ -1410,10 +1402,8 @@ u_int fpregs[];
  *	of FCMP is being emulated.
  */
 static void
-update_status_cbit(status, new_status, fpu_type, y_field)
-u_int *status, new_status;
-u_int fpu_type;
-u_int y_field;
+update_status_cbit(u_int *status, u_int new_status, u_int fpu_type, 
+		   u_int y_field)
 {
 	/*
 	 * For PA89 FPU's which implement the Compare Queue and

