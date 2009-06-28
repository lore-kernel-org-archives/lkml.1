Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbZF1Qfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbZF1Qfi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756866AbZF1Q1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:50 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1127 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714AbZF1Q1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:45 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       ron.mercer@qlogic.com, Ron Mercer <linux-driver@qlogic.com>,
       netdev@vger.kernel.org
Subject: [PATCH 30/62] drivers/net/qlge/qlge_main.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:35 -0700
Message-Id: <86a775a4ef18051cbf116f969e07d8cb36e56b10.1246173681.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/qlge/qlge_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/qlge/qlge_main.c b/drivers/net/qlge/qlge_main.c
index 90d1f76..bc41287 100644
--- a/drivers/net/qlge/qlge_main.c
+++ b/drivers/net/qlge/qlge_main.c
@@ -2607,7 +2607,7 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 	    FLAGS_LI;		/* Load irq delay values */
 	if (rx_ring->lbq_len) {
 		cqicb->flags |= FLAGS_LL;	/* Load lbq values */
-		tmp = (u64)rx_ring->lbq_base_dma;;
+		tmp = (u64)rx_ring->lbq_base_dma;
 		base_indirect_ptr = (__le64 *) rx_ring->lbq_base_indirect;
 		page_entries = 0;
 		do {
@@ -2631,7 +2631,7 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 	}
 	if (rx_ring->sbq_len) {
 		cqicb->flags |= FLAGS_LS;	/* Load sbq values */
-		tmp = (u64)rx_ring->sbq_base_dma;;
+		tmp = (u64)rx_ring->sbq_base_dma;
 		base_indirect_ptr = (__le64 *) rx_ring->sbq_base_indirect;
 		page_entries = 0;
 		do {
-- 
1.6.3.1.10.g659a0.dirty

