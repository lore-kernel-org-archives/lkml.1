Return-Path: <linux-kernel-owner+w=401wt.eu-S1760740AbXJMQCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740AbXJMQCS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 12:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbXJMQCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 12:02:04 -0400
Received: from dike.telenet-ops.be ([195.130.132.36]:59330 "EHLO
	dike.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737AbXJMQCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 12:02:03 -0400
Message-Id: <20071013123412.923788313@mail.of.borg>
References: <20071013123123.085686856@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 14:31:26 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 3/8] m68k: ignore restart_syscall
Content-Disposition: inline; filename=m68k-ignore-restart_syscall.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

m68k: ignore restart_syscall, which is not needed on m68k.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/asm-m68k/unistd.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/asm-m68k/unistd.h
+++ b/include/asm-m68k/unistd.h
@@ -351,6 +351,9 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
 
+/* whitelist for checksyscalls */
+#define __IGNORE_restart_syscall
+
 /*
  * "Conditional" syscalls
  *

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

