Return-Path: <linux-kernel-owner+w=401wt.eu-S1760404AbYBMVcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760404AbYBMVcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762963AbYBMVaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:00 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:50758 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbYBMV36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:29:58 -0500
Date: Wed, 13 Feb 2008 23:29:42 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: unexport io_delay_type
Message-ID: <20080213212942.GI3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused EXPORT_SYMBOL_GPL(io_delay_type).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

BTW:
I really think boot option + kconfig option + sysctl is overkill for 
the rare case where this stuff matters at all, and the boot option alone 
woud be enough.

5e5912ea3d9626284f74afb78ebe7fa820b4e63b 
diff --git a/arch/x86/kernel/io_delay.c b/arch/x86/kernel/io_delay.c
index bd49321..c706a30 100644
--- a/arch/x86/kernel/io_delay.c
+++ b/arch/x86/kernel/io_delay.c
@@ -13,7 +13,6 @@
 #include <asm/io.h>
 
 int io_delay_type __read_mostly = CONFIG_DEFAULT_IO_DELAY_TYPE;
-EXPORT_SYMBOL_GPL(io_delay_type);
 
 static int __initdata io_delay_override;
 
