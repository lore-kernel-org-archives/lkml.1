Return-Path: <linux-kernel-owner+w=401wt.eu-S934209AbXHVVzC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934209AbXHVVzC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:55:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758557AbXHVVyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:54:51 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54187 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761275AbXHVVyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:54:50 -0400
Date: Wed, 22 Aug 2007 23:02:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mxser: Remove commented crap
Message-ID: <20070822230257.4008820a@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is years dead code and it keeps turning up in confusing ways when
grepping for stuff

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc3-mm1/drivers/char/mxser.c linux-2.6.23rc3-mm1/drivers/char/mxser.c
--- linux.vanilla-2.6.23rc3-mm1/drivers/char/mxser.c	2007-08-13 13:27:52.000000000 +0100
+++ linux-2.6.23rc3-mm1/drivers/char/mxser.c	2007-08-22 17:47:05.000000000 +0100
@@ -1938,14 +1938,6 @@
 				inb(info->base + UART_MSR);
 				continue;
 			}
-			/* above add by Victor Yu. 09-13-2002 */
-			/*
-			   if (info->tty->flip.count < TTY_FLIPBUF_SIZE / 4) {
-			   info->IER |= MOXA_MUST_RECV_ISR;
-			   outb(info->IER, info->base + UART_IER);
-			   }
-			 */
-
 
 			/* mask by Victor Yu. 09-13-2002
 			   if ( !info->tty ||
@@ -2599,19 +2591,8 @@
 		info->IER |= UART_IER_MSI;
 		if ((info->type == PORT_16550A) || (info->IsMoxaMustChipFlag)) {
 			info->MCR |= UART_MCR_AFE;
-			/* status = mxser_get_msr(info->base, 0, info->port); */
-/*
-	save_flags(flags);
-	cli();
-	status = inb(baseaddr + UART_MSR);
-	restore_flags(flags);
-*/
-			/* mxser_check_modem_status(info, status); */
 		} else {
-			/* status = mxser_get_msr(info->base, 0, info->port); */
-			/* MX_LOCK(&info->slock); */
 			status = inb(info->base + UART_MSR);
-			/* MX_UNLOCK(&info->slock); */
 			if (info->tty->hw_stopped) {
 				if (status & UART_MSR_CTS) {
 					info->tty->hw_stopped = 0;
