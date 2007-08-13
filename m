Return-Path: <linux-kernel-owner+w=401wt.eu-S971927AbXHMQdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971927AbXHMQdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S947592AbXHMPgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:36:44 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:47688 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S947530AbXHMPgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:36:42 -0400
Date: Mon, 13 Aug 2007 10:36:28 -0500
From: Corey Minyard <minyard@acm.org>
Subject: [Patch] IPMI: fix warning in ipmi_si_intf.c
To: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Mijo Safradin <safradin@de.ibm.com>, Christian Krafft <krafft@de.ibm.com>
Reply-to: minyard@acm.org
Message-id: <20070813153628.GA18154@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mijo Safradin <safradin@de.ibm.com>

trivial change: fix warning

Signed-off-by: Mijo Safradin <safradin@de.ibm.com>
Acked-by: Christian Krafft <krafft@de.ibm.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>

---
Index: linux-2.6.22/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.22.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6.22/drivers/char/ipmi/ipmi_si_intf.c
@@ -2300,7 +2300,7 @@ static int __devinit ipmi_of_probe(struc
 	info->irq		= irq_of_parse_and_map(dev->node, 0);
 	info->dev		= &dev->dev;
 
-	dev_dbg(&dev->dev, "addr 0x%lx regsize %ld spacing %ld irq %x\n",
+	dev_dbg(&dev->dev, "addr 0x%lx regsize %d spacing %d irq %x\n",
 		info->io.addr_data, info->io.regsize, info->io.regspacing,
 		info->irq);
 
