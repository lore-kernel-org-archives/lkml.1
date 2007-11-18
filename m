Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbXKRKD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbXKRKD6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 05:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbXKRKDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 05:03:52 -0500
Received: from europa.telenet-ops.be ([195.130.137.75]:47515 "EHLO
	europa.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbXKRKDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 05:03:51 -0500
Date: Sun, 18 Nov 2007 11:03:47 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] checkpatch: Print filenames of patches
Message-ID: <Pine.LNX.4.64.0711181103070.1009@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch: Print filenames of patches instead of the very uninformative
`Your patch'.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
This patch is not `checkpatch' clean :-)
Although I shortened 2 lines, they're still longer than 80 characters...

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1408,10 +1408,10 @@ sub process {
 		}
 	}
 	if ($clean == 1 && $quiet == 0) {
-		print "Your patch has no obvious style problems and is ready for submission.\n"
+		print "$filename has no obvious style problems and is ready for submission.\n"
 	}
 	if ($clean == 0 && $quiet == 0) {
-		print "Your patch has style problems, please review.  If any of these errors\n";
+		print "$filename has style problems, please review.  If any of these errors\n";
 		print "are false positives report them to the maintainer, see\n";
 		print "CHECKPATCH in MAINTAINERS.\n";
 	}

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
