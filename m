Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbYLEKWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbYLEKWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 05:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbYLEKUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 05:20:55 -0500
Received: from vps1.tull.net ([66.180.172.116]:47098 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751916AbYLEKUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 05:20:52 -0500
Mail-From: nobody Fri Dec  5 14:07:59 2008
From: Nick Andrew <nick@nick-andrew.net>
Subject: [PATCH] Fix incorrect use of loose in serial167.c
To: Alan Cox <alan@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Jiri Slaby <jirislaby@gmail.com>, Nick Andrew <nick@nick-andrew.net>
Cc: <linux-kernel@vger.kernel.org>, Nick Andrew <nick@nick-andrew.net>
Date: Fri, 05 Dec 2008 14:07:59 +1100
Message-ID: <20081205030759.31930.38119.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect use of loose in serial167.c

It should be 'lose', not 'loose'.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/char/serial167.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/char/serial167.c b/drivers/char/serial167.c
index 3b23270..a8f15e6 100644
--- a/drivers/char/serial167.c
+++ b/drivers/char/serial167.c
@@ -418,7 +418,7 @@ static irqreturn_t cd2401_rxerr_interrupt(int irq, void *dev_id)
 							     TTY_OVERRUN);
 					/*
 					   If the flip buffer itself is
-					   overflowing, we still loose
+					   overflowing, we still lose
 					   the next incoming character.
 					 */
 					if (tty_buffer_request_room(tty, 1) !=


