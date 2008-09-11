Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbYIKNfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbYIKNfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 09:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbYIKNew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 09:34:52 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37142 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYIKNev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 09:34:51 -0400
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, themann@de.ibm.com,
       tklein@de.ibm.com, raisch@de.ibm.com, jeff@garzik.org,
       jean-pierre.dion@bull.net, gilles.carry@ext.bull.net,
       tinytim@us.ibm.com, sebastien.dugue@bull.net
Subject: [PATCH 1/2] ehea: fix phyp debugging typo
Date: Thu, 11 Sep 2008 15:34:39 +0200
Message-Id: <1221140080-9853-2-git-send-email-sebastien.dugue@bull.net>
X-Mailer: git-send-email 1.5.5.rc2.1.gc953.dirty
In-Reply-To: <1221140080-9853-1-git-send-email-sebastien.dugue@bull.net>
References: <1221140080-9853-1-git-send-email-sebastien.dugue@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Fix typo in ehea_h_query_ehea() which prevents building when DEBUG is on.

Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
---
 drivers/net/ehea/ehea_phyp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ehea/ehea_phyp.c b/drivers/net/ehea/ehea_phyp.c
index 156eb63..2a33a61 100644
--- a/drivers/net/ehea/ehea_phyp.c
+++ b/drivers/net/ehea/ehea_phyp.c
@@ -535,7 +535,7 @@ u64 ehea_h_query_ehea(const u64 adapter_handle, void *cb_addr)
 				       cb_logaddr,		/* R5 */
 				       0, 0, 0, 0, 0);		/* R6-R10 */
 #ifdef DEBUG
-	ehea_dmp(cb_addr, sizeof(struct hcp_query_ehea), "hcp_query_ehea");
+	ehea_dump(cb_addr, sizeof(struct hcp_query_ehea), "hcp_query_ehea");
 #endif
 	return hret;
 }
-- 
1.6.0.1.308.gede4c

