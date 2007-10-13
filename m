Return-Path: <linux-kernel-owner+w=401wt.eu-S1757726AbXJMM2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726AbXJMM2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 08:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbXJMM2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 08:28:09 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:57622 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbXJMM2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 08:28:07 -0400
Date: Sat, 13 Oct 2007 14:28:00 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: checkpatch: ERROR: Does not appear to be a unified-diff format patch
Message-ID: <Pine.LNX.4.64.0710131424470.12088@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <Pine.LNX.4.64.0710131425421.15951@anakin>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

scripts/checkpatch.pl doesn't seem to like this patch:

$ scripts/checkpatch.pl m68k-export-asm-cachectl-h.diff 
ERROR: Does not appear to be a unified-diff format patch

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
$ cat m68k-export-asm-cachectl-h.diff 
Subject: m68k: Export cachectl.h

From: Matthew Wilcox <matthew@wil.cx>

libffi in GCC 4.2 needs cachectl.h to do its cache flushing.  But we
don't currently export it.  I believe this patch should do the trick.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 include/asm-m68k/Kbuild |    1 +
 1 file changed, 1 insertion(+)

--- a/include/asm-m68k/Kbuild
+++ b/include/asm-m68k/Kbuild
@@ -1 +1,2 @@
 include include/asm-generic/Kbuild.asm
+header-y += cachectl.h
$ 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
