Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYELLmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYELLmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 07:42:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750923AbYELLly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 07:41:54 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51984 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750776AbYELLlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 07:41:53 -0400
Date: Mon, 12 May 2008 12:31:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cris: Fix compile failure due to typo in serial driver
Message-ID: <20080512123137.02940a4d@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/serial/crisv10.c linux-2.6.25-mm1/drivers/serial/crisv10.c
--- linux.vanilla-2.6.25-mm1/drivers/serial/crisv10.c	2008-04-28 11:36:50.000000000 +0100
+++ linux-2.6.25-mm1/drivers/serial/crisv10.c	2008-05-07 14:37:19.000000000 +0100
@@ -3808,7 +3808,7 @@
 
 	shutdown(info);
 	rs_flush_buffer(tty);
-	tty_ldisc_flush_buffer(tty);
+	tty_ldisc_flush(tty);
 	tty->closing = 0;
 	info->event = 0;
 	info->tty = 0;
