Return-Path: <linux-kernel-owner+w=401wt.eu-S1750935AbXCXNGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750935AbXCXNGh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 09:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbXCXNGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 09:06:37 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33356 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750935AbXCXNGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 09:06:35 -0400
Date: Sat, 24 Mar 2007 14:06:39 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] lguest: #if 0 check_bug_kill()
Message-ID: <20070324130639.GG752@stusta.de>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 08:56:23PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.21-rc3-mm1:
>...
> +lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch
>...
>  x86/x86_64 updates
>...


check_bug_kill() is no longer used.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 arch/i386/lguest/interrupts_and_traps.c |    2 ++
 arch/i386/lguest/lg.h                   |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.21-rc4-mm1/arch/i386/lguest/lg.h.old	2007-03-23 23:17:05.000000000 +0100
+++ linux-2.6.21-rc4-mm1/arch/i386/lguest/lg.h	2007-03-23 23:17:10.000000000 +0100
@@ -195,7 +195,6 @@
 /* interrupts_and_traps.c: */
 void maybe_do_interrupt(struct lguest *lg);
 int deliver_trap(struct lguest *lg, unsigned int num);
-void check_bug_kill(struct lguest *lg);
 void load_guest_idt_entry(struct lguest *lg, unsigned int i, u32 low, u32 hi);
 void pin_stack_pages(struct lguest *lg);
 void pin_trap_pages(struct lguest *lg);
--- linux-2.6.21-rc4-mm1/arch/i386/lguest/interrupts_and_traps.c.old	2007-03-23 23:17:18.000000000 +0100
+++ linux-2.6.21-rc4-mm1/arch/i386/lguest/interrupts_and_traps.c	2007-03-23 23:17:38.000000000 +0100
@@ -118,6 +118,7 @@
 	return 1;
 }
 
+#if 0
 void check_bug_kill(struct lguest *lg)
 {
 #ifdef CONFIG_BUG
@@ -144,6 +145,7 @@
 	}
 #endif	/* CONFIG_BUG */
 }
+#endif  /*  0  */
 
 static int direct_trap(const struct lguest *lg,
 		       const struct desc_struct *trap,

