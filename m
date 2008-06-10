Return-Path: <linux-kernel-owner+w=401wt.eu-S1760295AbYFJW3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295AbYFJW3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757612AbYFJW3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:29:19 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:35654 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757421AbYFJW3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:29:19 -0400
Date: Wed, 11 Jun 2008 01:28:19 +0300
From: Adrian Bunk <bunk@kernel.org>
To: takata@linux-m32r.org
Cc: linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] m32r: export empty_zero_page
Message-ID: <20080610222819.GJ11685@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error:

<--  snip  -->

...
  Building modules, stage 2.
  MODPOST 1083 modules
ERROR: "empty_zero_page" [fs/ext4/ext4dev.ko] undefined!
...
make[2]: *** [__modpost] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/m32r/kernel/m32r_ksyms.c |    2 ++
 1 file changed, 2 insertions(+)

ae7a1cecb2071e861cbcd6ee362ed93dd43793d5 diff --git a/arch/m32r/kernel/m32r_ksyms.c b/arch/m32r/kernel/m32r_ksyms.c
index e6709fe..94b1893 100644
--- a/arch/m32r/kernel/m32r_ksyms.c
+++ b/arch/m32r/kernel/m32r_ksyms.c
@@ -14,6 +14,7 @@
 #include <asm/delay.h>
 #include <asm/irq.h>
 #include <asm/tlbflush.h>
+#include <asm/pgtable.h>
 
 /* platform dependent support */
 EXPORT_SYMBOL(boot_cpu_data);
@@ -68,6 +69,7 @@ EXPORT_SYMBOL(memset);
 EXPORT_SYMBOL(copy_page);
 EXPORT_SYMBOL(clear_page);
 EXPORT_SYMBOL(strlen);
+EXPORT_SYMBOL(empty_zero_page);
 
 EXPORT_SYMBOL(_inb);
 EXPORT_SYMBOL(_inw);

