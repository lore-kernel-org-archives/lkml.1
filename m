Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbXGGVLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbXGGVLN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 17:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbXGGVKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 17:10:50 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53828 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754510AbXGGVKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 17:10:49 -0400
Date: Sat, 7 Jul 2007 23:11:20 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Miles Bader <miles@gnu.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] arch/v850/kernel/process.c must #include
	<linux/module.h>
Message-ID: <20070707211120.GM3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error:

<--  snip  -->

...
  CC      arch/v850/kernel/process.o
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/v850/kernel/process.c:32: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/v850/kernel/process.c:32: warning: parameter names (without types) in function declaration
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/v850/kernel/process.c:32: warning: data definition has no type or storage class
...
make[2]: *** [arch/v850/kernel/process.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/arch/v850/kernel/process.c.old	2007-07-07 22:17:18.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/v850/kernel/process.c	2007-07-07 22:17:56.000000000 +0200
@@ -23,6 +23,7 @@
 #include <linux/user.h>
 #include <linux/a.out.h>
 #include <linux/reboot.h>
+#include <linux/module.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>

