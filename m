Return-Path: <linux-kernel-owner+w=401wt.eu-S1752737AbYL3NXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbYL3NXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 08:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYL3NW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 08:22:57 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:60924 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbYL3NW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 08:22:56 -0500
X-Greylist: delayed 970 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Dec 2008 08:22:56 EST
Subject: [PATCH][TRIVIAL] Add a space (and a comma) to a printk
From: Paul Bolle <pebolle@tiscali.nl>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 30 Dec 2008 14:06:43 +0100
Message-Id: <1230642403.13647.31.camel@test.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.3.1 (2.25.3.1-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d87a6d9 ("drivers/serial/: remove CVS keywords") removed one
space too many in the printk in serial8250_init(). Put it back in (and
add a comma for clarity).
    
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 303272a..31b3c08 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -3018,7 +3018,7 @@ static int __init serial8250_init(void)
 	if (nr_uarts > UART_NR)
 		nr_uarts = UART_NR;
 
-	printk(KERN_INFO "Serial: 8250/16550 driver"
+	printk(KERN_INFO "Serial: 8250/16550 driver, "
 		"%d ports, IRQ sharing %sabled\n", nr_uarts,
 		share_irqs ? "en" : "dis");
 


