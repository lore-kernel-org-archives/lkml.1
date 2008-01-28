Return-Path: <linux-kernel-owner+w=401wt.eu-S1764013AbYA1XIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764013AbYA1XIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763605AbYA1XHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:07:45 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:30734 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763296AbYA1XHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:07:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=YoUYoZd+kIWlvLlVlJRmY448OTBcWozYgIVtCyVa6Ar3YwIaNv4/1tJk3To3QlhWgQKSWPxId8ij9IT1gFi1UCI0R6Wg1RucZB8oGa6RwvDTzcpf/XAZIfCwnDjLSN50OsBTbCk/TQDiSAE+4BWyaqaKyPv9XoZZV1bTmol5H3U=
Date: Tue, 29 Jan 2008 00:07:37 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] X86: Clean up comments
Message-ID: <20080129000737.03057806@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up comments

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/math-emu/errors.c |  144 ++++++++++++++++++++++----------------------
 1 files changed, 72 insertions(+), 72 deletions(-)

diff --git a/arch/x86/math-emu/errors.c b/arch/x86/math-emu/errors.c
index ece95cd..7f96db4 100644
--- a/arch/x86/math-emu/errors.c
+++ b/arch/x86/math-emu/errors.c
@@ -182,78 +182,78 @@ static struct {
  error was detected.
 
  Internal error types:
-       0x14   in fpu_etc.c
-       0x1nn  in a *.c file:
-              0x101  in reg_add_sub.c
-              0x102  in reg_mul.c
-              0x104  in poly_atan.c
-              0x105  in reg_mul.c
-              0x107  in fpu_trig.c
-	      0x108  in reg_compare.c
-	      0x109  in reg_compare.c
-	      0x110  in reg_add_sub.c
-	      0x111  in fpe_entry.c
-	      0x112  in fpu_trig.c
-	      0x113  in errors.c
-	      0x115  in fpu_trig.c
-	      0x116  in fpu_trig.c
-	      0x117  in fpu_trig.c
-	      0x118  in fpu_trig.c
-	      0x119  in fpu_trig.c
-	      0x120  in poly_atan.c
-	      0x121  in reg_compare.c
-	      0x122  in reg_compare.c
-	      0x123  in reg_compare.c
-	      0x125  in fpu_trig.c
-	      0x126  in fpu_entry.c
-	      0x127  in poly_2xm1.c
-	      0x128  in fpu_entry.c
-	      0x129  in fpu_entry.c
-	      0x130  in get_address.c
-	      0x131  in get_address.c
-	      0x132  in get_address.c
-	      0x133  in get_address.c
-	      0x140  in load_store.c
-	      0x141  in load_store.c
-              0x150  in poly_sin.c
-              0x151  in poly_sin.c
-	      0x160  in reg_ld_str.c
-	      0x161  in reg_ld_str.c
-	      0x162  in reg_ld_str.c
-	      0x163  in reg_ld_str.c
-	      0x164  in reg_ld_str.c
-	      0x170  in fpu_tags.c
-	      0x171  in fpu_tags.c
-	      0x172  in fpu_tags.c
-	      0x180  in reg_convert.c
-       0x2nn  in an *.S file:
-              0x201  in reg_u_add.S
-              0x202  in reg_u_div.S
-              0x203  in reg_u_div.S
-              0x204  in reg_u_div.S
-              0x205  in reg_u_mul.S
-              0x206  in reg_u_sub.S
-              0x207  in wm_sqrt.S
-	      0x208  in reg_div.S
-              0x209  in reg_u_sub.S
-              0x210  in reg_u_sub.S
-              0x211  in reg_u_sub.S
-              0x212  in reg_u_sub.S
-	      0x213  in wm_sqrt.S
-	      0x214  in wm_sqrt.S
-	      0x215  in wm_sqrt.S
-	      0x220  in reg_norm.S
-	      0x221  in reg_norm.S
-	      0x230  in reg_round.S
-	      0x231  in reg_round.S
-	      0x232  in reg_round.S
-	      0x233  in reg_round.S
-	      0x234  in reg_round.S
-	      0x235  in reg_round.S
-	      0x236  in reg_round.S
-	      0x240  in div_Xsig.S
-	      0x241  in div_Xsig.S
-	      0x242  in div_Xsig.S
+	0x14   in fpu_etc.c
+	0x1nn  in a *.c file:
+	0x101  in reg_add_sub.c
+	0x102  in reg_mul.c
+	0x104  in poly_atan.c
+	0x105  in reg_mul.c
+	0x107  in fpu_trig.c
+	0x108  in reg_compare.c
+	0x109  in reg_compare.c
+	0x110  in reg_add_sub.c
+	0x111  in fpe_entry.c
+	0x112  in fpu_trig.c
+	0x113  in errors.c
+	0x115  in fpu_trig.c
+	0x116  in fpu_trig.c
+	0x117  in fpu_trig.c
+	0x118  in fpu_trig.c
+	0x119  in fpu_trig.c
+	0x120  in poly_atan.c
+	0x121  in reg_compare.c
+	0x122  in reg_compare.c
+	0x123  in reg_compare.c
+	0x125  in fpu_trig.c
+	0x126  in fpu_entry.c
+	0x127  in poly_2xm1.c
+	0x128  in fpu_entry.c
+	0x129  in fpu_entry.c
+	0x130  in get_address.c
+	0x131  in get_address.c
+	0x132  in get_address.c
+	0x133  in get_address.c
+	0x140  in load_store.c
+	0x141  in load_store.c
+	0x150  in poly_sin.c
+	0x151  in poly_sin.c
+	0x160  in reg_ld_str.c
+	0x161  in reg_ld_str.c
+	0x162  in reg_ld_str.c
+	0x163  in reg_ld_str.c
+	0x164  in reg_ld_str.c
+	0x170  in fpu_tags.c
+	0x171  in fpu_tags.c
+	0x172  in fpu_tags.c
+	0x180  in reg_convert.c
+	0x2nn  in an *.S file:
+	0x201  in reg_u_add.S
+	0x202  in reg_u_div.S
+	0x203  in reg_u_div.S
+	0x204  in reg_u_div.S
+	0x205  in reg_u_mul.S
+	0x206  in reg_u_sub.S
+	0x207  in wm_sqrt.S
+	0x208  in reg_div.S
+	0x209  in reg_u_sub.S
+	0x210  in reg_u_sub.S
+	0x211  in reg_u_sub.S
+	0x212  in reg_u_sub.S
+	0x213  in wm_sqrt.S
+	0x214  in wm_sqrt.S
+	0x215  in wm_sqrt.S
+	0x220  in reg_norm.S
+	0x221  in reg_norm.S
+	0x230  in reg_round.S
+	0x231  in reg_round.S
+	0x232  in reg_round.S
+	0x233  in reg_round.S
+	0x234  in reg_round.S
+	0x235  in reg_round.S
+	0x236  in reg_round.S
+	0x240  in div_Xsig.S
+	0x241  in div_Xsig.S
+	0x242  in div_Xsig.S
  */
 
 asmlinkage void FPU_exception(int n)
-- 
1.5.4.rc3

