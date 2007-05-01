Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbXEAPwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbXEAPwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbXEAPwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:52:47 -0400
Received: from asia.telenet-ops.be ([195.130.137.74]:57058 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbXEAPwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:52:46 -0400
Date: Tue, 1 May 2007 17:52:44 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k: export csum_partial_copy_from_user
Message-ID: <Pine.LNX.4.64.0705011751540.27246@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

net/rxrpc/af-rxrpc.ko needs csum_partial_copy_from_user

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/lib/checksum.c |    3 +++
 1 file changed, 3 insertions(+)

--- linux-m68k-2.6.21.orig/arch/m68k/lib/checksum.c
+++ linux-m68k-2.6.21/arch/m68k/lib/checksum.c
@@ -320,6 +320,9 @@ csum_partial_copy_from_user(const void _
 	return(sum);
 }
 
+EXPORT_SYMBOL(csum_partial_copy_from_user);
+
+
 /*
  * copy from kernel space while checksumming, otherwise like csum_partial
  */

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
