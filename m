Return-Path: <linux-kernel-owner+w=401wt.eu-S1757031AbZCNVl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbZCNVl7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 17:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758046AbZCNVj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 17:39:56 -0400
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:57987 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758089AbZCNVjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 17:39:55 -0400
From: =?utf-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org,
       =?utf-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
Subject: [PATCH 08/09] Checkpatch.pl: Fixup table.c
Date: Sat, 14 Mar 2009 22:39:35 +0100
Message-Id: <1237066776-14697-9-git-send-email-erik.andren@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1237066776-14697-8-git-send-email-erik.andren@gmail.com>
References: <1>
 <1237066776-14697-1-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-2-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-3-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-4-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-5-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-6-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-7-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-8-git-send-email-erik.andren@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erik Andrén <erik.andren@gmail.com>
---
 drivers/staging/agnx/table.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/agnx/table.c b/drivers/staging/agnx/table.c
index c600484..b52fef9 100644
--- a/drivers/staging/agnx/table.c
+++ b/drivers/staging/agnx/table.c
@@ -80,7 +80,7 @@ void routing_table_init(struct agnx_priv *priv)
 
 	disable_receiver(priv);
 
-	for ( type = 0; type < 0x3; type++ ) {
+	for (type = 0; type < 0x3; type++) {
 		for (subtype = 0; subtype < 0x10; subtype++) {
 			/* 1. Set Routing table to R/W and to Return status on Read */
 			reg = (type << ROUTAB_TYPE_SHIFT) |
@@ -89,7 +89,7 @@ void routing_table_init(struct agnx_priv *priv)
 			if (type == ROUTAB_TYPE_DATA) {
 				/* NULL goes to RFP */
 				if (subtype == ROUTAB_SUBTYPE_NULL)
-//					reg |= ROUTAB_ROUTE_RFP;
+/*					reg |= ROUTAB_ROUTE_RFP; */
 					reg |= ROUTAB_ROUTE_CPU;
 				/* QOS NULL goes to CPU */
 				else if (subtype == ROUTAB_SUBTYPE_QOSNULL)
@@ -104,7 +104,7 @@ void routing_table_init(struct agnx_priv *priv)
 					 (subtype == ROUTAB_SUBTYPE_QOSDATAPOLL) ||
 					 (subtype == ROUTAB_SUBTYPE_QOSDATAACKPOLL))
 					reg |= ROUTAB_ROUTE_ENCRY;
-//					reg |= ROUTAB_ROUTE_CPU;
+/*					reg |= ROUTAB_ROUTE_CPU; */
 				/*Drop NULL and QOS NULL ack, poll and poll ack*/
 				else if ((subtype == ROUTAB_SUBTYPE_NULLACK) ||
 					 (subtype == ROUTAB_SUBTYPE_QOSNULLACK) ||
@@ -112,11 +112,11 @@ void routing_table_init(struct agnx_priv *priv)
 					 (subtype == ROUTAB_SUBTYPE_QOSNULLPOLL) ||
 					 (subtype == ROUTAB_SUBTYPE_NULLPOLLACK) ||
 					 (subtype == ROUTAB_SUBTYPE_QOSNULLPOLLACK))
-//					reg |= ROUTAB_ROUTE_DROP;
+/*					reg |= ROUTAB_ROUTE_DROP; */
 					reg |= ROUTAB_ROUTE_CPU;
-			}
-			else
+			} else {
 				reg |= (ROUTAB_ROUTE_CPU);
+			}
 			iowrite32(reg, ctl + AGNX_RXM_ROUTAB);
 			/* Check to verify that the status bit cleared */
 			routing_table_delay();
-- 
1.6.0.4

