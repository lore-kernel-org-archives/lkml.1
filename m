Return-Path: <linux-kernel-owner+w=401wt.eu-S1423625AbXEAUti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423625AbXEAUti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423653AbXEAUlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:41:55 -0400
Received: from asia.telenet-ops.be ([195.130.137.74]:36913 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423634AbXEAUe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:34:58 -0400
Message-Id: <20070501203334.549493764@mail.of.borg>
References: <20070501203234.252205858@mail.of.borg>
User-Agent: quilt/0.45-1
Date: Tue, 01 May 2007 22:32:52 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Finn Thain <fthain@telegraphics.com.au>
Subject: [patch 18/33] m68k: Mac interrupt priorities
Content-Disposition: inline; filename=mac68k-patch_d-via-alt-mapping.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

Add some more machines that support A/UX interrupt priorities. There are
probably others as well, but I've only tested these ones so far.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/mac/via.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-m68k-2.6.21.orig/arch/m68k/mac/via.c
+++ linux-m68k-2.6.21/arch/m68k/mac/via.c
@@ -193,8 +193,14 @@ void __init via_init(void)
 	/* that the IIfx emulates this alternate mapping using the OSS. */
 
 	switch(macintosh_config->ident) {
+		case MAC_MODEL_P475:
+		case MAC_MODEL_P475F:
+		case MAC_MODEL_P575:
+		case MAC_MODEL_Q605:
+		case MAC_MODEL_Q605_ACC:
 		case MAC_MODEL_C610:
 		case MAC_MODEL_Q610:
+		case MAC_MODEL_Q630:
 		case MAC_MODEL_C650:
 		case MAC_MODEL_Q650:
 		case MAC_MODEL_Q700:

--
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

