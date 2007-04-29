Return-Path: <linux-kernel-owner+w=401wt.eu-S1161609AbXD2Xrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161609AbXD2Xrh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161602AbXD2XrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:47:25 -0400
Received: from ns1.suse.de ([195.135.220.2]:41930 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161579AbXD2XqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:46:18 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430146.588463000@suse.de>
In-Reply-To: <20070430146.588463000@suse.de>
To: Avi Kivity <avi@qumranet.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [8/26] x86_64: fix arithmetic in comment
Message-Id: <20070429234617.3B981151D2@wotan.suse.de>
Date: Mon, 30 Apr 2007 01:46:17 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Avi Kivity <avi@qumranet.com>
The xmm space on x86_64 is 256 bytes.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86_64/processor.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/include/asm-x86_64/processor.h
===================================================================
--- linux.orig/include/asm-x86_64/processor.h
+++ linux/include/asm-x86_64/processor.h
@@ -181,7 +181,7 @@ struct i387_fxsave_struct {
 	u32	mxcsr;
 	u32	mxcsr_mask;
 	u32	st_space[32];	/* 8*16 bytes for each FP-reg = 128 bytes */
-	u32	xmm_space[64];	/* 16*16 bytes for each XMM-reg = 128 bytes */
+	u32	xmm_space[64];	/* 16*16 bytes for each XMM-reg = 256 bytes */
 	u32	padding[24];
 } __attribute__ ((aligned (16)));
 
