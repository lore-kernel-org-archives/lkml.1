Return-Path: <linux-kernel-owner+w=401wt.eu-S1161779AbXEAUwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161779AbXEAUwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1160993AbXEAUlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:41:35 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:40241 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423646AbXEAUfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:35:04 -0400
Message-Id: <20070501203338.610208765@mail.of.borg>
References: <20070501203234.252205858@mail.of.borg>
User-Agent: quilt/0.45-1
Date: Tue, 01 May 2007 22:33:06 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 32/33] m68k: export csum_partial_copy_from_user
Content-Disposition: inline; filename=af-rxrpc.ko-needs-csum_partial_copy_from_user.diff
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

--
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

