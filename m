Return-Path: <linux-kernel-owner+w=401wt.eu-S933772AbXHVWa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933772AbXHVWa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759843AbXHVWat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:30:49 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59698 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761389AbXHVWas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:30:48 -0400
Date: Wed, 22 Aug 2007 23:38:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tty.h: Remove dead define
Message-ID: <20070822233848.54f2193d@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No longer used. TTY_FLIPBUF_SIZE will also go soon but needs a couple of
other cleanups first

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc3-mm1/include/linux/tty.h linux-2.6.23rc3-mm1/include/linux/tty.h
--- linux.vanilla-2.6.23rc3-mm1/include/linux/tty.h	2007-08-13 13:28:02.000000000 +0100
+++ linux-2.6.23rc3-mm1/include/linux/tty.h	2007-08-22 17:51:01.000000000 +0100
@@ -82,11 +75,6 @@
 	int memory_used;		/* Buffer space used excluding free queue */
 };
 /*
- * The pty uses char_buf and flag_buf as a contiguous buffer
- */
-#define PTY_BUF_SIZE	4*TTY_FLIPBUF_SIZE
-
-/*
  * When a break, frame error, or parity error happens, these codes are
  * stuffed into the flags buffer.
  */
