Return-Path: <linux-kernel-owner+w=401wt.eu-S1754289AbXKLFH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbXKLFH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 00:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbXKLFHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 00:07:47 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:32180 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbXKLFHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 00:07:47 -0500
Date: Sun, 11 Nov 2007 21:06:23 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: James.Bottomley@HansenPartnership.com, tglx@linutronix.de
Subject: [PATCH 2/3] voyager: fix voyager_cat_init section
Message-Id: <20071111210623.284b760a.randy.dunlap@oracle.com>
In-Reply-To: <20071111210204.cbcf413e.randy.dunlap@oracle.com>
References: <20071111210204.cbcf413e.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix Voyager section mismatches:  voyager_cat_init() should be __init.

WARNING: vmlinux.o(.text+0xee83): Section mismatch: reference to .init.data:eprom_buf (between 'voyager_cat_init' and 'aes_enc_blk')
WARNING: vmlinux.o(.text+0xeea6): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'aes_enc_blk')
WARNING: vmlinux.o(.text+0xeeac): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'aes_enc_blk')
WARNING: vmlinux.o(.text+0xeeb2): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'aes_enc_blk')
WARNING: vmlinux.o(.text+0xef4c): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'aes_enc_blk')
WARNING: vmlinux.o(.text+0xef56): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'aes_enc_blk')
WARNING: vmlinux.o(.text+0xf10f): Section mismatch: reference to .init.data:eprom_buf (between 'voyager_cat_init' and 'aes_enc_blk')
WARNING: vmlinux.o(.text+0xf13b): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'aes_enc_blk')
WARNING: vmlinux.o(.text+0xf14b): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'aes_enc_blk')
WARNING: vmlinux.o(.text+0xf159): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'aes_enc_blk')
WARNING: vmlinux.o(.text+0xf1b1): Section mismatch: reference to .init.data:eprom_buf (between 'voyager_cat_init' and 'aes_enc_blk')
WARNING: vmlinux.o(.text+0xf1bb): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'aes_enc_blk')
WARNING: vmlinux.o(.text+0xf1c1): Section mismatch: reference to .init.data:eprom_buf (between 'voyager_cat_init' and 'aes_enc_blk')
WARNING: vmlinux.o(.text+0xf1c7): Section mismatch: reference to .init.data:eprom_buf (between 'voyager_cat_init' and 'aes_enc_blk')
WARNING: vmlinux.o(.text+0xf1e6): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'aes_enc_blk')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/mach-voyager/voyager_cat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc2-git2.orig/arch/x86/mach-voyager/voyager_cat.c
+++ linux-2.6.24-rc2-git2/arch/x86/mach-voyager/voyager_cat.c
@@ -568,7 +568,7 @@ static voyager_module_t *voyager_initial
  * boot cpu *after* all memory initialisation has been done (so we can
  * use kmalloc) but before smp initialisation, so we can probe the SMP
  * configuration and pick up necessary information.  */
-void
+void __init
 voyager_cat_init(void)
 {
 	voyager_module_t **modpp = &voyager_initial_module;
