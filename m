Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbYG0GGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbYG0GGc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbYG0GGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:06:16 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:32725 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450AbYG0GGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:06:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=pSb16S+8TVRkHUjq1ZgcBd3geF9VRjQx82qtwAdHqPLI/IVvRu/2/FGkkFaTnYjXh+
         VifRyL+N5MgmCeLJlI1N0xA62mhYo8n2MgPRwLg9dtKNOKDzpU3jfPaUlshNUTE1BP6u
         srdCcZ8UCYNWPhL5foURz/zfrwrtsLyEuJiT8=
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 5/8] Blackfin Serial Driver: Remove useless stop
Date: Sun, 27 Jul 2008 14:04:04 +0800
Message-Id: <1217138647-18227-6-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1217138647-18227-1-git-send-email-cooloney@kernel.org>
References: <1217138647-18227-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index f069309..31fc8e1 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -320,9 +320,6 @@ static void bfin_serial_tx_chars(struct bfin_serial_port *uart)
 
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(&uart->port);
-
-	if (uart_circ_empty(xmit))
-		bfin_serial_stop_tx(&uart->port);
 }
 
 static irqreturn_t bfin_serial_rx_int(int irq, void *dev_id)
-- 
1.5.6

