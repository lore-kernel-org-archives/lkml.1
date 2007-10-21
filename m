Return-Path: <linux-kernel-owner+w=401wt.eu-S1751798AbXJURzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbXJURzR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 13:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbXJURzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 13:55:05 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:36687 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbXJURzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 13:55:04 -0400
Date: Sun, 21 Oct 2007 19:55:00 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cc-cross-prefix spelling (was: Re: [GI:wqT PULL] kbuild
 updates - second round)
In-Reply-To: <20071019204415.GA623@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0710211953550.6155@anakin>
References: <20071019204415.GA623@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007, Sam Ravnborg wrote:
> The cc-cross-prefix is new and developed on request from Geert Uytterhoeven.

Spelling fixes for cc-cross-prefix documentation

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 Documentation/kbuild/makefiles.txt |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -519,17 +519,17 @@ more details, with real examples.
 	to the user why it stops.
 
     cc-cross-prefix
-	cc-cross-prefix is used to check if there exist a $(CC) in path with
+	cc-cross-prefix is used to check if there exists a $(CC) in path with
 	one of the listed prefixes. The first prefix where there exist a
 	prefix$(CC) in the PATH is returned - and if no prefix$(CC) is found
 	then nothing is returned.
 	Additional prefixes are separated by a single space in the
 	call of cc-cross-prefix.
-	This functionality is usefull for architecture Makefile that try
-	to set CROSS_COMPILE to well know values but may have several
+	This functionality is useful for architecture Makefiles that try
+	to set CROSS_COMPILE to well-known values but may have several
 	values to select between.
-	It is recommended only to try to set CROSS_COMPILE is it is a cross
-	build (host arch is different from target arch). And is CROSS_COMPILE
+	It is recommended only to try to set CROSS_COMPILE if it is a cross
+	build (host arch is different from target arch). And if CROSS_COMPILE
 	is already set then leave it with the old value.
 
 	Example:

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
