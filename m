Return-Path: <linux-kernel-owner+w=401wt.eu-S965000AbXBLQwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965000AbXBLQwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964974AbXBLQwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:52:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965000AbXBLQvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:50 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: Ralf Baechle <ralf@linux-mips.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [24/29] x86_64: -mm merge plans for 2.6.21
Message-Id: <20070212165145.147CD13E1A@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:45 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Ralf Baechle <ralf@linux-mips.org>
On Sat, Feb 10, 2007 at 11:22:05AM +0100, Heiko Carstens wrote:

> Which remembers me that I think that MIPS is using the non-compat version
> of sys_epoll_pwait for compat syscalls. But maybe MIPS doesn't need a compat
> syscall for some reason. Dunno.

Which reminds me that x86_64 i386 compat doesn't wire up sys_epoll_pwait ;-)

  Ralf

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/ia32/ia32entry.S |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/x86_64/ia32/ia32entry.S
===================================================================
--- linux.orig/arch/x86_64/ia32/ia32entry.S
+++ linux/arch/x86_64/ia32/ia32entry.S
@@ -730,4 +730,5 @@ ia32_sys_call_table:
 	.quad compat_sys_vmsplice
 	.quad compat_sys_move_pages
 	.quad sys_getcpu
+	.quad sys_epoll_pwait
 ia32_syscall_end:		
