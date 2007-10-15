Return-Path: <linux-kernel-owner+w=401wt.eu-S933883AbXJOUP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbXJOUP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762437AbXJOUPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:15:00 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37937 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759389AbXJOUO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:14:59 -0400
Date: Mon, 15 Oct 2007 21:18:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tty: Kill TTY_FLIPBUF_SIZE
Message-ID: <20071015211830.72b857cd@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This legacy define from the old buffer code is now only used in a single
power pc driver than doesn't compile anyway.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --exclude-from /usr/src/exclude --new-file --recursive linux.vanilla-2.6.23-mm1/include/linux/tty.h linux-2.6.23-mm1/include/linux/tty.h
--- linux.vanilla-2.6.23-mm1/include/linux/tty.h	2007-10-15 15:03:38.000000000 +0100
+++ linux-2.6.23-mm1/include/linux/tty.h	2007-10-15 15:28:46.000000000 +0100
@@ -52,13 +52,6 @@
  */
 #define __DISABLED_CHAR '\0'
 
-/*
- * This is the flip buffer used for the tty driver.  The buffer is
- * located in the tty structure, and is used as a high speed interface
- * between the tty driver and the tty line discipline.
- */
-#define TTY_FLIPBUF_SIZE 512
-
 struct tty_buffer {
 	struct tty_buffer *next;
 	char *char_buf_ptr;
