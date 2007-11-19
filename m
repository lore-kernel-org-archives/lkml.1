Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200AbXKSPAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbXKSPAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbXKSPAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:00:11 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35934 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753334AbXKSPAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:00:09 -0500
Date: Mon, 19 Nov 2007 14:57:54 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] tty_audit: Fix checkpatch complaint
Message-ID: <20071119145754.46006a10@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/char/tty_audit.c linux-2.6.24-rc2-mm1/drivers/char/tty_audit.c
--- linux.vanilla-2.6.24-rc2-mm1/drivers/char/tty_audit.c	2007-11-16 17:20:41.000000000 +0000
+++ linux-2.6.24-rc2-mm1/drivers/char/tty_audit.c	2007-11-16 18:20:50.000000000 +0000
@@ -27,7 +27,7 @@
 {
 	struct tty_audit_buf *buf;
 
-	buf = kmalloc(sizeof (*buf), GFP_KERNEL);
+	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		goto err;
 	if (PAGE_SIZE != N_TTY_BUF_SIZE)
