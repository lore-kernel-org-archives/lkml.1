Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbYJEQIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbYJEQIU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756162AbYJEQFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:05:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54852 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754290AbYJEQFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:05:55 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 10/76] Blackfin Serial Driver: Remove useless stop
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:05:55 +0100
Message-ID: <20081005160552.1997.92637.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/serial/bfin_5xx.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 382fb8d..8d2d757 100644
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

