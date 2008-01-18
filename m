Return-Path: <linux-kernel-owner+w=401wt.eu-S1761382AbYAROcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761382AbYAROcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 09:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbYAROb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 09:31:59 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:37978 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240AbYAROb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 09:31:59 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/7] Char: mxser, 0 to NULL in pointer
Date: Fri, 18 Jan 2008 15:31:11 +0100
Message-Id: <1200666676-1234-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1200666676-1234-1-git-send-email-jirislaby@gmail.com>
References: <1200666676-1234-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't test a pointer against 0. Use NULL instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/mxser_new.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/mxser_new.c b/drivers/char/mxser_new.c
index 0b25457..d2dcc54 100644
--- a/drivers/char/mxser_new.c
+++ b/drivers/char/mxser_new.c
@@ -2153,7 +2153,7 @@ static void mxser_transmit_chars(struct mxser_port *port)
 		return;
 	}
 
-	if (port->xmit_buf == 0)
+	if (port->xmit_buf == NULL)
 		return;
 
 	if ((port->xmit_cnt <= 0) || port->tty->stopped ||
-- 
1.5.3.7

