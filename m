Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbZISVn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbZISVn7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbZISVn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:43:58 -0400
Received: from kroah.org ([198.145.64.141]:40548 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbZISVn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:43:56 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 64/79] TTY: fix typos
Date: Sat, 19 Sep 2009 14:37:09 -0700
Message-Id: <1253396244-7885-64-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1282) fixes some obvious typos in the TTY core.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_port.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index c767e30..a4bbb28 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -100,7 +100,7 @@ EXPORT_SYMBOL(tty_port_tty_set);
 static void tty_port_shutdown(struct tty_port *port)
 {
 	if (port->ops->shutdown &&
-		test_and_clear_bit(ASYNC_INITIALIZED, &port->flags))
+		test_and_clear_bit(ASYNCB_INITIALIZED, &port->flags))
 			port->ops->shutdown(port);
 
 }
@@ -311,7 +311,7 @@ int tty_port_close_start(struct tty_port *port, struct tty_struct *tty, struct f
 			port->ops->drop(port);
 		return 0;
 	}
-	set_bit(ASYNC_CLOSING, &port->flags);
+	set_bit(ASYNCB_CLOSING, &port->flags);
 	tty->closing = 1;
 	spin_unlock_irqrestore(&port->lock, flags);
 	/* Don't block on a stalled port, just pull the chain */
-- 
1.6.4.2

