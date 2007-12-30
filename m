Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbXL3N7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbXL3N7b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 08:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755235AbXL3N7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 08:59:08 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:47426 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbXL3N7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 08:59:05 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/5] Char: mxser, 0 to NULL in pointer
Date: Sun, 30 Dec 2007 14:58:55 +0100
Message-Id: <1199023138-27917-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1199023138-27917-1-git-send-email-jirislaby@gmail.com>
References: <1199023138-27917-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't test a pointer against 0. Use NULL instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/mxser.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index fe7944c..a66ae57 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -2153,7 +2153,7 @@ static void mxser_transmit_chars(struct mxser_port *port)
 		return;
 	}
 
-	if (port->xmit_buf == 0)
+	if (port->xmit_buf == NULL)
 		return;
 
 	if ((port->xmit_cnt <= 0) || port->tty->stopped ||
-- 
1.5.3.6

