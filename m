Return-Path: <linux-kernel-owner+w=401wt.eu-S1760604AbXKNQgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604AbXKNQgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 11:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbXKNQgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 11:36:08 -0500
Received: from nic2.axis.se ([193.13.178.10]:49852 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755AbXKNQgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 11:36:07 -0500
Date: Wed, 14 Nov 2007 17:35:22 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com
Subject: [PATCH] CRISv10 Ethernet declare mac fix
Message-ID: <20071114163522.GN6347@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Declare mac using DECLARE_MAC_BUF for use when calling print_mac().

This fixes compile error where mac was undeclared.
Also, remove unused variable i.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 eth_v10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/cris/eth_v10.c b/drivers/net/cris/eth_v10.c
index 5dc984a..917b7b4 100644
--- a/drivers/net/cris/eth_v10.c
+++ b/drivers/net/cris/eth_v10.c
@@ -630,7 +630,7 @@ e100_set_mac_address(struct net_device *dev, void *p)
 {
 	struct net_local *np = netdev_priv(dev);
 	struct sockaddr *addr = p;
-	int i;
+	DECLARE_MAC_BUF(mac);
 
 	spin_lock(&np->lock); /* preemption protection */
 

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
