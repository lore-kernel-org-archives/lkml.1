Return-Path: <linux-kernel-owner+w=401wt.eu-S1759818AbXFZW2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759818AbXFZW2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 18:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757604AbXFZW21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 18:28:27 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:30601 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289AbXFZW20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 18:28:26 -0400
Date: Tue, 26 Jun 2007 15:30:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: samuel@sortiz.org, akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm] IRDA: fix printk format
Message-Id: <20070626153023.8ae8563d.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:
drivers/net/irda/irport.c:512: warning: format '%d' expects type 'int', but argument 5 has type 'long int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/irda/irport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2622-rc4mm2.orig/drivers/net/irda/irport.c
+++ linux-2622-rc4mm2/drivers/net/irda/irport.c
@@ -509,7 +509,7 @@ static void irport_timeout(struct net_de
 	IRDA_DEBUG(0, "%s(), iir=%02x, lsr=%02x, iobase=%#x\n", 
 		   __FUNCTION__, iir, lsr, iobase);
 
-	IRDA_DEBUG(0, "%s(), transmitting=%d, remain=%d, done=%d\n", 
+	IRDA_DEBUG(0, "%s(), transmitting=%d, remain=%d, done=%ld\n", 
 		   __FUNCTION__, self->transmitting, self->tx_buff.len,
 		   self->tx_buff.data - self->tx_buff.head);
 
