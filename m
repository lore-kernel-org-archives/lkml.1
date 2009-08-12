Return-Path: <linux-kernel-owner+w=401wt.eu-S1751646AbZHLML0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbZHLML0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 08:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZHLML0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 08:11:26 -0400
Received: from ozlabs.org ([203.10.76.45]:50048 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbZHLMLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 08:11:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Remove redundant start_kernel prototypes.
Date: Wed, 12 Aug 2009 21:41:21 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908122141.22072.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, this is probably best in your tree.

No need for redeclaration.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/frv/include/asm/gdb-stub.h     |    1 -
 arch/mn10300/include/asm/gdb-stub.h |    1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/frv/include/asm/gdb-stub.h b/arch/frv/include/asm/gdb-stub.h
--- a/arch/frv/include/asm/gdb-stub.h
+++ b/arch/frv/include/asm/gdb-stub.h
@@ -90,7 +90,6 @@ extern void gdbstub_do_rx(void);
 extern asmlinkage void __debug_stub_init_break(void);
 extern asmlinkage void __break_hijack_kernel_event(void);
 extern asmlinkage void __break_hijack_kernel_event_breaks_here(void);
-extern asmlinkage void start_kernel(void);
 
 extern asmlinkage void gdbstub_rx_handler(void);
 extern asmlinkage void gdbstub_rx_irq(void);
diff --git a/arch/mn10300/include/asm/gdb-stub.h b/arch/mn10300/include/asm/gdb-stub.h
--- a/arch/mn10300/include/asm/gdb-stub.h
+++ b/arch/mn10300/include/asm/gdb-stub.h
@@ -109,7 +109,6 @@ extern asmlinkage int  gdbstub_intercept
 extern asmlinkage void gdbstub_exception(struct pt_regs *, enum exception_code);
 extern asmlinkage void __gdbstub_bug_trap(void);
 extern asmlinkage void __gdbstub_pause(void);
-extern asmlinkage void start_kernel(void);
 
 #ifndef CONFIG_MN10300_CACHE_DISABLED
 extern asmlinkage void gdbstub_purge_cache(void);
