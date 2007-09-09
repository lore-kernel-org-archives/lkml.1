Return-Path: <linux-kernel-owner+w=401wt.eu-S1757120AbXIIJec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120AbXIIJec (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 05:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756163AbXIIJeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 05:34:15 -0400
Received: from astra.telenet-ops.be ([195.130.132.58]:53662 "EHLO
	astra.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbXIIJeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 05:34:14 -0400
Date: Sun, 9 Sep 2007 11:34:11 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] checksyscalls.sh: ignore restart_syscall
Message-ID: <Pine.LNX.4.64.0709091131550.6588@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

checksyscalls.sh: ignore restart_syscall, which is not needed on m68k and
blackfin.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 scripts/checksyscalls.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/checksyscalls.sh
+++ b/scripts/checksyscalls.sh
@@ -30,6 +30,7 @@ cat << EOF
 #endif
 
 /* i386-specific or historical system calls */
+#define __IGNORE_restart_syscall
 #define __IGNORE_break
 #define __IGNORE_stty
 #define __IGNORE_gtty

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
