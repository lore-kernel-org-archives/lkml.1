Return-Path: <linux-kernel-owner+w=401wt.eu-S935203AbXLQTnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935203AbXLQTnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760675AbXLQTbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:55 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3000 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761197AbXLQTbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:47 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       Maxim Krasnyansky <maxk@qualcomm.com>,
       bluez-devel@lists.sourceforge.net
Subject: [PATCH] drivers/bluetooth/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:30 -0800
Message-Id: <1197919875-5288-31-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/bluetooth/btuart_cs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/bluetooth/btuart_cs.c b/drivers/bluetooth/btuart_cs.c
index 08f48d5..dade162 100644
--- a/drivers/bluetooth/btuart_cs.c
+++ b/drivers/bluetooth/btuart_cs.c
@@ -383,7 +383,7 @@ static void btuart_change_speed(btuart_info_t *info, unsigned int speed)
 	outb(lcr, iobase + UART_LCR);	/* Set 8N1  */
 	outb(fcr, iobase + UART_FCR);	/* Enable FIFO's */
 
-	/* Turn on interrups */
+	/* Turn on interrupts */
 	outb(UART_IER_RLSI | UART_IER_RDI | UART_IER_THRI, iobase + UART_IER);
 
 	spin_unlock_irqrestore(&(info->lock), flags);
-- 
1.5.3.7.949.g2221a6

