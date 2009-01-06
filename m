Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbZAFWYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbZAFWYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbZAFWNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:51 -0500
Received: from kroah.org ([198.145.64.141]:51265 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754250AbZAFWNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:50 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 32/60] serial: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:11:51 -0800
Message-Id: <1231279939-32728-32-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/serial_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index dc68b7e..42f4e66 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2030,7 +2030,7 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *port)
 		if (!tries)
 			printk(KERN_ERR "%s%s%s%d: Unable to drain "
 					"transmitter\n",
-			       port->dev ? port->dev->bus_id : "",
+			       port->dev ? dev_name(port->dev) : "",
 			       port->dev ? ": " : "",
 			       drv->dev_name,
 			       drv->tty_driver->name_base + port->line);
@@ -2156,7 +2156,7 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
 	}
 
 	printk(KERN_INFO "%s%s%s%d at %s (irq = %d) is a %s\n",
-	       port->dev ? port->dev->bus_id : "",
+	       port->dev ? dev_name(port->dev) : "",
 	       port->dev ? ": " : "",
 	       drv->dev_name,
 	       drv->tty_driver->name_base + port->line,
-- 
1.6.0.4

