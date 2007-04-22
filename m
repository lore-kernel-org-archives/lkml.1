Return-Path: <linux-kernel-owner+w=401wt.eu-S1750700AbXDVVcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750700AbXDVVcJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 17:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbXDVVcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 17:32:08 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:56945 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750700AbXDVVcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 17:32:08 -0400
Message-id: <198562180014133173@wsc.cz>
Subject: [PATCH 1/1] Char: icom, mark __init as __devinit
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 22 Apr 2007 23:32:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

icom, mark __init as __devinit

Two functions are called from __devinit context, but they are marked as
__init. Fix this.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 257f51b72348e8879e8ef397f82e1408233843c1
tree 79a82d6c884adc7b941773929c92d269a9b91679
parent 6f42cfdf174bdd2c05edf7d192713042bf25339c
author Jiri Slaby <jirislaby@gmail.com> Sun, 22 Apr 2007 23:29:21 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sun, 22 Apr 2007 23:29:21 +0200

 drivers/serial/icom.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/icom.c b/drivers/serial/icom.c
index e4f8873..0a3268b 100644
--- a/drivers/serial/icom.c
+++ b/drivers/serial/icom.c
@@ -163,7 +163,7 @@ static void free_port_memory(struct icom_port *icom_port)
 	}
 }
 
-static int __init get_port_memory(struct icom_port *icom_port)
+static int __devinit get_port_memory(struct icom_port *icom_port)
 {
 	int index;
 	unsigned long stgAddr;
@@ -1379,7 +1379,7 @@ static void icom_port_active(struct icom_port *icom_port, struct icom_adapter *i
 			    0x8024 + 2 - 2 * (icom_port->port - 2);
 	}
 }
-static int __init icom_load_ports(struct icom_adapter *icom_adapter)
+static int __devinit icom_load_ports(struct icom_adapter *icom_adapter)
 {
 	struct icom_port *icom_port;
 	int port_num;
