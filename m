Return-Path: <linux-kernel-owner+w=401wt.eu-S1759218AbXEIVNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218AbXEIVNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 17:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757309AbXEIVNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 17:13:32 -0400
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:41394 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005AbXEIVNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 17:13:31 -0400
Date: Wed, 9 May 2007 23:13:24 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: Philippe De Muyter <phdm@macqel.be>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] Let SYSV68_PARTITION default to yes on VME only
In-Reply-To: <Pine.LNX.4.64.0705082217340.12497@anakin>
Message-ID: <Pine.LNX.4.64.0705092311430.13222@anakin>
References: <20070413135501.GA27439@ingate.macqel.be> <Pine.LNX.4.64.0705082217340.12497@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don't enable SYSV68 partition table support on all m68k boxes by default,
only on Motorola VME boards.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Philippe De Muyter <phdm@macqel.be>
---
 fs/partitions/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-m68k-2.6.21.orig/fs/partitions/Kconfig
+++ linux-m68k-2.6.21/fs/partitions/Kconfig
@@ -239,7 +239,7 @@ config EFI_PARTITION
 
 config SYSV68_PARTITION
 	bool "SYSV68 partition table support" if PARTITION_ADVANCED
-	default y if M68K
+	default y if VME
 	help
 	  Say Y here if you would like to be able to read the hard disk
 	  partition table format used by Motorola Delta machines (using

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
