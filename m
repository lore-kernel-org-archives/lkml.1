Return-Path: <linux-kernel-owner+w=401wt.eu-S1758615AbYAPWcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbYAPWcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbYAPW1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:27:09 -0500
Received: from mail.suse.de ([195.135.220.2]:56758 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756798AbYAPW1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:27:07 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161127.268350000@suse.de>
In-Reply-To: <200801161127.268350000@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/7] Use shorter addresses in i386 segfault printks
Message-Id: <20080116222706.8074A14EE3@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:27:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/fault_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/mm/fault_32.c
===================================================================
--- linux.orig/arch/x86/mm/fault_32.c
+++ linux/arch/x86/mm/fault_32.c
@@ -516,7 +516,7 @@ bad_area_nosemaphore:
 		    printk_ratelimit()) {
 			printk(
 #ifdef CONFIG_X86_32
-			"%s%s[%d]: segfault at %08lx ip %08lx sp %08lx error %lx\n",
+			"%s%s[%d]: segfault at %lx ip %08lx sp %08lx error %lx\n",
 #else
 			"%s%s[%d]: segfault at %lx ip %lx sp %lx error %lx\n",
 #endif
