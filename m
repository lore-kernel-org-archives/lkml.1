Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbZHTTXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbZHTTXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 15:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbZHTTXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 15:23:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41727 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751389AbZHTTXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 15:23:47 -0400
Date: Thu, 20 Aug 2009 15:23:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] TTY: fix typos
Message-ID: <Pine.LNX.4.44L0.0908201523010.2670-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1282) fixes some obvious typos in the TTY core.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>

---

Index: usb-2.6/drivers/char/tty_port.c
===================================================================
--- usb-2.6.orig/drivers/char/tty_port.c
+++ usb-2.6/drivers/char/tty_port.c
@@ -100,7 +100,7 @@ EXPORT_SYMBOL(tty_port_tty_set);
 static void tty_port_shutdown(struct tty_port *port)
 {
 	if (port->ops->shutdown &&
-		test_and_clear_bit(ASYNC_INITIALIZED, &port->flags))
+		test_and_clear_bit(ASYNCB_INITIALIZED, &port->flags))
 			port->ops->shutdown(port);
 	
 }
@@ -311,7 +311,7 @@ int tty_port_close_start(struct tty_port
 			port->ops->drop(port);
 		return 0;
 	}
-	set_bit(ASYNC_CLOSING, &port->flags);
+	set_bit(ASYNCB_CLOSING, &port->flags);
 	tty->closing = 1;
 	spin_unlock_irqrestore(&port->lock, flags);
 	/* Don't block on a stalled port, just pull the chain */

