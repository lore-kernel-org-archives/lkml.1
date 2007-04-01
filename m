Return-Path: <linux-kernel-owner+w=401wt.eu-S932238AbXDAIkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbXDAIkF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 04:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932244AbXDAIkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 04:40:04 -0400
Received: from il.qumranet.com ([82.166.9.18]:43294 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238AbXDAIkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 04:40:03 -0400
From: Avi Kivity <avi@qumranet.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH] x86_64: fix arithmetic in comment
Date: Sun,  1 Apr 2007 11:40:00 +0300
Message-Id: <11754168002892-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The xmm space on x86_64 is 256 bytes.

Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/include/asm-x86_64/processor.h b/include/asm-x86_64/processor.h
index 76552d7..90eb24e 100644
--- a/include/asm-x86_64/processor.h
+++ b/include/asm-x86_64/processor.h
@@ -201,7 +201,7 @@ struct i387_fxsave_struct {
 	u32	mxcsr;
 	u32	mxcsr_mask;
 	u32	st_space[32];	/* 8*16 bytes for each FP-reg = 128 bytes */
-	u32	xmm_space[64];	/* 16*16 bytes for each XMM-reg = 128 bytes */
+	u32	xmm_space[64];	/* 16*16 bytes for each XMM-reg = 256 bytes */
 	u32	padding[24];
 } __attribute__ ((aligned (16)));
 
