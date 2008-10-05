Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbYJEQHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbYJEQHe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbYJEQFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:05:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54848 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754269AbYJEQFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:05:38 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 08/76] Blackfin Serial Driver: trim trailing whitespace -- no
	functional changes
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:05:38 +0100
Message-ID: <20081005160534.1997.57030.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/serial/bfin_5xx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 04eeef0..976de91 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -1,7 +1,7 @@
 /*
  * Blackfin On-Chip Serial Driver
  *
- * Copyright 2006-2007 Analog Devices Inc.
+ * Copyright 2006-2008 Analog Devices Inc.
  *
  * Enter bugs at http://blackfin.uclinux.org/
  *
@@ -126,13 +126,13 @@ static int kgdb_entry_state;
 void kgdb_put_debug_char(int chr)
 {
 	struct bfin_serial_port *uart;
-	
+
 	if (CONFIG_KGDB_UART_PORT < 0
 		|| CONFIG_KGDB_UART_PORT >= BFIN_UART_NR_PORTS)
 		uart = &bfin_serial_ports[0];
 	else
 		uart = &bfin_serial_ports[CONFIG_KGDB_UART_PORT];
-	
+
 	while (!(UART_GET_LSR(uart) & THRE)) {
 		SSYNC();
 	}
@@ -152,7 +152,7 @@ int kgdb_get_debug_char(void)
 		uart = &bfin_serial_ports[0];
 	else
 		uart = &bfin_serial_ports[CONFIG_KGDB_UART_PORT];
-	
+
 	while(!(UART_GET_LSR(uart) & DR)) {
 		SSYNC();
 	}

