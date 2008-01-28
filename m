Return-Path: <linux-kernel-owner+w=401wt.eu-S1763567AbYA1XMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763567AbYA1XMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:12:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763867AbYA1XIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:08:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:30734 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763838AbYA1XIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:08:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=txkDoF/0wjviyyjHH4uSZcwZVRkjGwbWU4zoy4jMVLusKjNX3uZugztOyvY4S7iSSUGLs6tcuBdq00F4t2X6dw0UUfirjhQfdSEAfhTyL+JTrny/3nYuP7/gAQQRc0YXm6EeG2ZLlLBUqKFotAyskixrob+aLo7s8gyopJAAM/o=
Date: Tue, 29 Jan 2008 00:08:10 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7]  fix lines over 80 characters
Message-ID: <20080129000810.42d0d6f0@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix lines over 80 characters

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/math-emu/errors.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/math-emu/errors.c b/arch/x86/math-emu/errors.c
index 569a62e..e5a5b80 100644
--- a/arch/x86/math-emu/errors.c
+++ b/arch/x86/math-emu/errors.c
@@ -75,7 +75,8 @@ void FPU_printall(void)
 	  FPU_get_user(FPU_modrm, 1 + (u_char __user *) address);
 
 	  if (FPU_modrm >= 0300)
-	    printk(KERN_ERR " %02x (%02x+%d)\n", FPU_modrm, FPU_modrm & 0xf8, FPU_modrm & 7);
+	    printk(KERN_ERR " %02x (%02x+%d)\n", FPU_modrm, FPU_modrm & 0xf8,
+		FPU_modrm & 7);
 	  else
 	    printk(KERN_ERR " /%d, mod=%d rm=%d\n",
 		   (FPU_modrm >> 3) & 7, (FPU_modrm >> 6) & 3, FPU_modrm & 7);
@@ -309,7 +310,8 @@ asmlinkage void FPU_exception(int n)
 	printk(KERN_ERR "FPU emulator: Unknown Exception: 0x%04x!\n", n);
 
       if (n == EX_INTERNAL) {
-	  printk(KERN_ERR "FPU emulator: Internal error type 0x%04x\n", int_type);
+	  printk(KERN_ERR "FPU emulator: Internal error type 0x%04x\n",
+		int_type);
 	  FPU_printall();
 	}
 #ifdef PRINT_MESSAGES
-- 
1.5.4.rc3

