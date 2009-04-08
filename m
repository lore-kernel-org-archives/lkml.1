Return-Path: <linux-kernel-owner+w=401wt.eu-S1764979AbZDHLsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764979AbZDHLsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932274AbZDHL2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:28:33 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37856 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932129AbZDHL1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:27:47 -0400
X-Sasl-enc: GAFZdVSU+dGn13CZBXwiC1m5+vKTZ3P/fjjyO2t078jh 1239190065
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 43/56] s390: Remove void casts
Date: Wed,  8 Apr 2009 12:22:15 +0100
Message-Id: <1239189748-11703-44-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-43-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-32-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-33-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-34-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-35-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-36-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-37-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-38-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-39-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-40-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-41-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-42-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-43-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 arch/s390/math-emu/math.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/s390/math-emu/math.c b/arch/s390/math-emu/math.c
index 3ee78cc..c1d43c9 100644
--- a/arch/s390/math-emu/math.c
+++ b/arch/s390/math-emu/math.c
@@ -1917,7 +1917,7 @@ int math_emu_ed(__u8 *opcode, struct pt_regs * regs) {
 
                 emu_store_regd((opcode[1] >> 4) & 15);
                 opc = *((__u32 *) opcode);
-                dxb = (__u64 *) calc_addr(regs, opc >> 16, opc >> 12, opc);
+                dxb = calc_addr(regs, opc >> 16, opc >> 12, opc);
                 mathemu_copy_from_user(&temp, dxb, 8);
                 /* call the emulation function */
                 _fex = ((int (*)(struct pt_regs *, int, double *))
@@ -1932,7 +1932,7 @@ int math_emu_ed(__u8 *opcode, struct pt_regs * regs) {
 
                 emu_store_rege((opcode[1] >> 4) & 15);
                 opc = *((__u32 *) opcode);
-                dxb = (__u32 *) calc_addr(regs, opc >> 16, opc >> 12, opc);
+                dxb = calc_addr(regs, opc >> 16, opc >> 12, opc);
                 mathemu_get_user(temp, dxb);
                 /* call the emulation function */
                 _fex = ((int (*)(struct pt_regs *, int, float *))
@@ -1948,7 +1948,7 @@ int math_emu_ed(__u8 *opcode, struct pt_regs * regs) {
                 emu_store_regd((opcode[1] >> 4) & 15);
                 emu_store_regd((opcode[4] >> 4) & 15);
                 opc = *((__u32 *) opcode);
-                dxb = (__u64 *) calc_addr(regs, opc >> 16, opc >> 12, opc);
+                dxb = calc_addr(regs, opc >> 16, opc >> 12, opc);
                 mathemu_copy_from_user(&temp, dxb, 8);
                 /* call the emulation function */
                 _fex = ((int (*)(struct pt_regs *, int, double *, int))
@@ -1964,7 +1964,7 @@ int math_emu_ed(__u8 *opcode, struct pt_regs * regs) {
                 emu_store_rege((opcode[1] >> 4) & 15);
                 emu_store_rege((opcode[4] >> 4) & 15);
                 opc = *((__u32 *) opcode);
-                dxb = (__u32 *) calc_addr(regs, opc >> 16, opc >> 12, opc);
+                dxb = calc_addr(regs, opc >> 16, opc >> 12, opc);
                 mathemu_get_user(temp, dxb);
                 /* call the emulation function */
                 _fex = ((int (*)(struct pt_regs *, int, float *, int))
@@ -1982,7 +1982,7 @@ int math_emu_ed(__u8 *opcode, struct pt_regs * regs) {
 			return SIGILL;
                 emu_store_regd((opcode[1] >> 4) & 15);
                 opc = *((__u32 *) opcode);
-                dxb = (__u64 *) calc_addr(regs, opc >> 16, opc >> 12, opc);
+                dxb = calc_addr(regs, opc >> 16, opc >> 12, opc);
                 mathemu_copy_from_user(&temp, dxb, 8);
                 /* call the emulation function */
                 _fex = ((int (*)(struct pt_regs *, int, double *))
@@ -1999,7 +1999,7 @@ int math_emu_ed(__u8 *opcode, struct pt_regs * regs) {
                 __u32 opc;
                 emu_store_rege((opcode[1] >> 4) & 15);
                 opc = *((__u32 *) opcode);
-                dxb = (__u32 *) calc_addr(regs, opc >> 16, opc >> 12, opc);
+                dxb = calc_addr(regs, opc >> 16, opc >> 12, opc);
                 mathemu_get_user(temp, dxb);
                 /* call the emulation function */
                 _fex = ((int (*)(struct pt_regs *, int, float *))
@@ -2017,7 +2017,7 @@ int math_emu_ed(__u8 *opcode, struct pt_regs * regs) {
 			return SIGILL;
                 emu_store_rege((opcode[1] >> 4) & 15);
                 opc = *((__u32 *) opcode);
-                dxb = (__u32 *) calc_addr(regs, opc >> 16, opc >> 12, opc);
+                dxb = calc_addr(regs, opc >> 16, opc >> 12, opc);
                 mathemu_get_user(temp, dxb);
                 /* call the emulation function */
                 _fex = ((int (*)(struct pt_regs *, int, float *))
@@ -2148,7 +2148,7 @@ int math_emu_ld(__u8 *opcode, struct pt_regs * regs) {
         __u32 opc = *((__u32 *) opcode);
         __u64 *dxb;
 
-        dxb = (__u64 *) calc_addr(regs, opc >> 16, opc >> 12, opc);
+        dxb = calc_addr(regs, opc >> 16, opc >> 12, opc);
         mathemu_copy_from_user(&fp_regs->fprs[(opc >> 20) & 0xf].d, dxb, 8);
 	return 0;
 }
@@ -2161,7 +2161,7 @@ int math_emu_le(__u8 *opcode, struct pt_regs * regs) {
         __u32 opc = *((__u32 *) opcode);
         __u32 *mem, *dxb;
 
-        dxb = (__u32 *) calc_addr(regs, opc >> 16, opc >> 12, opc);
+        dxb = calc_addr(regs, opc >> 16, opc >> 12, opc);
         mem = (__u32 *) (&fp_regs->fprs[(opc >> 20) & 0xf].f);
         mathemu_get_user(mem[0], dxb);
 	return 0;
@@ -2175,7 +2175,7 @@ int math_emu_std(__u8 *opcode, struct pt_regs * regs) {
         __u32 opc = *((__u32 *) opcode);
         __u64 *dxb;
 
-        dxb = (__u64 *) calc_addr(regs, opc >> 16, opc >> 12, opc);
+        dxb = calc_addr(regs, opc >> 16, opc >> 12, opc);
         mathemu_copy_to_user(dxb, &fp_regs->fprs[(opc >> 20) & 0xf].d, 8);
 	return 0;
 }
@@ -2188,7 +2188,7 @@ int math_emu_ste(__u8 *opcode, struct pt_regs * regs) {
         __u32 opc = *((__u32 *) opcode);
         __u32 *mem, *dxb;
 
-        dxb = (__u32 *) calc_addr(regs, opc >> 16, opc >> 12, opc);
+        dxb = calc_addr(regs, opc >> 16, opc >> 12, opc);
         mem = (__u32 *) (&fp_regs->fprs[(opc >> 20) & 0xf].f);
         mathemu_put_user(mem[0], dxb);
 	return 0;
@@ -2201,7 +2201,7 @@ int math_emu_lfpc(__u8 *opcode, struct pt_regs *regs) {
         __u32 opc = *((__u32 *) opcode);
         __u32 *dxb, temp;
 
-        dxb= (__u32 *) calc_addr(regs, 0, opc>>12, opc);
+        dxb= calc_addr(regs, 0, opc>>12, opc);
         mathemu_get_user(temp, dxb);
         if ((temp & ~FPC_VALID_MASK) != 0)
 		return SIGILL;
@@ -2216,7 +2216,7 @@ int math_emu_stfpc(__u8 *opcode, struct pt_regs *regs) {
         __u32 opc = *((__u32 *) opcode);
         __u32 *dxb;
 
-        dxb= (__u32 *) calc_addr(regs, 0, opc>>12, opc);
+        dxb= calc_addr(regs, 0, opc>>12, opc);
         mathemu_put_user(current->thread.fp_regs.fpc, dxb);
         return 0;
 }
-- 
1.5.4.3

