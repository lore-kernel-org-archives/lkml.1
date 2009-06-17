Return-Path: <linux-kernel-owner+w=401wt.eu-S933613AbZFQN6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933613AbZFQN6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765938AbZFQN6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:58:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:37250 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765184AbZFQN6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:58:04 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Subrata Modak <subrata@linux.vnet.ibm.com>
Subject: [PATCH] net/ucc_geth: Fix compile errors
Date: Wed, 17 Jun 2009 08:57:56 -0500
Message-Id: <1245247076-30426-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Subrata Modak <subrata@linux.vnet.ibm.com>

drivers/net/ucc_geth.c: In function 'ucc_geth_probe':
drivers/net/ucc_geth.c:3822: error: 'ph' undeclared (first use in this function)
drivers/net/ucc_geth.c:3822: error: (Each undeclared identifier is reported only once
drivers/net/ucc_geth.c:3822: error: for each function it appears in.)
drivers/net/ucc_geth.c:3832: error: 'mdio' undeclared (first use in this function)

Signed-off-by: Subrata Modak <subrata@linux.vnet.ibm.com>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/net/ucc_geth.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ucc_geth.c b/drivers/net/ucc_geth.c
index e2f2e91..31da996 100644
--- a/drivers/net/ucc_geth.c
+++ b/drivers/net/ucc_geth.c
@@ -3595,6 +3595,8 @@ static const struct net_device_ops ucc_geth_netdev_ops = {
 
 static int ucc_geth_probe(struct of_device* ofdev, const struct of_device_id *match)
 {
+	struct device_node *mdio;
+	const phandle *ph;
 	struct device *device = &ofdev->dev;
 	struct device_node *np = ofdev->node;
 	struct net_device *dev = NULL;
-- 
1.6.0.6

