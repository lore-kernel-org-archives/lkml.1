Return-Path: <linux-kernel-owner+w=401wt.eu-S934178AbXHAPE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934178AbXHAPE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932664AbXHAPEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:04:14 -0400
Received: from www.osadl.org ([213.239.205.134]:53198 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932372AbXHAPEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:04:12 -0400
Subject: [PATCH] remove get_perm_addr from ucc_geth_ethtool.c
From: Jan Altenberg <jan.altenberg@linutronix.de>
To: leoli@freescale.com
Cc: netdev@vger.kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 17:04:10 +0200
Message-Id: <1185980650.3854.63.camel@bender.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove get_perm_addr from ucc_geth_ethtool.c

This is needed because commit 313674afa8fdced2fe79f50f38e1c387b63d8790
inlines the generic function to the caller.

Signed-off-by: Jan Altenberg <jan.altenberg@linutronix.de>

---
 drivers/net/ucc_geth_ethtool.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6/drivers/net/ucc_geth_ethtool.c
===================================================================
--- linux-2.6.orig/drivers/net/ucc_geth_ethtool.c
+++ linux-2.6/drivers/net/ucc_geth_ethtool.c
@@ -379,7 +379,6 @@ static const struct ethtool_ops uec_etht
 	.get_stats_count        = uec_get_stats_count,
 	.get_strings            = uec_get_strings,
 	.get_ethtool_stats      = uec_get_ethtool_stats,
-	.get_perm_addr          = ethtool_op_get_perm_addr,
 };
 
 void uec_set_ethtool_ops(struct net_device *netdev)


