Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923Ab0AaUC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab0AaUC0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 15:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113Ab0AaUCY
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 15:02:24 -0500
Received: from mail.perches.com ([173.55.12.10]:1645 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008Ab0AaUCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 15:02:21 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 04/10] drivers/serial/bfin_5xx.c: Fix continuation line formats
Date: Sun, 31 Jan 2010 12:02:06 -0800
Message-Id: <a69b564f8107a9cf56446e4bf190422fe90eada4.1264967499.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264967493.git.joe@perches.com>
References: <cover.1264967493.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

String constants that are continued on subsequent lines with \
are not good.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/serial/bfin_5xx.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 50abb7e..bea4587 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -729,8 +729,7 @@ static int bfin_serial_startup(struct uart_port *port)
 			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
 			IRQF_DISABLED, "BFIN_UART_CTS", uart)) {
 			uart->cts_pin = -1;
-			pr_info("Unable to attach BlackFin UART CTS interrupt.\
-				 So, disable it.\n");
+			pr_info("Unable to attach BlackFin UART CTS interrupt.  So, disable it.\n");
 		}
 	}
 	if (uart->rts_pin >= 0) {
@@ -742,8 +741,7 @@ static int bfin_serial_startup(struct uart_port *port)
 	if (request_irq(uart->status_irq,
 		bfin_serial_mctrl_cts_int,
 		IRQF_DISABLED, "BFIN_UART_MODEM_STATUS", uart)) {
-		pr_info("Unable to attach BlackFin UART Modem \
-			Status interrupt.\n");
+		pr_info("Unable to attach BlackFin UART Modem Status interrupt.\n");
 	}
 
 	if (uart->cts_pin >= 0) {
-- 
1.6.6.rc0.57.gad7a

