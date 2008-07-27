Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbYG0GFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbYG0GFm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbYG0GFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:05:31 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:32725 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbYG0GF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:05:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=gD8yn79FeH4++zdodrPV3yLTLFujNuZLBeZq55jhg+mRqj0pRfDJw8JbsJatF4JruW
         oCY1rme3H65qWXZLrCKuJCvYhmc7PYusDPXblhA0O8l6cXkAsNkTK2HpxhbiviDmxegP
         nar1mv6sguYAu1KE1rBFUcaaNENXGpm/64HLo=
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 3/8] Blackfin Serial Driver: trim trailing whitespace -- no functional changes
Date: Sun, 27 Jul 2008 14:04:02 +0800
Message-Id: <1217138647-18227-4-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1217138647-18227-1-git-send-email-cooloney@kernel.org>
References: <1217138647-18227-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 5e43530..444ebe5 100644
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
-- 
1.5.6

