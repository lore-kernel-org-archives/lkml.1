Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbYKOTow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbYKOTow (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 14:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYKOTop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 14:44:45 -0500
Received: from mail.gmx.net ([213.165.64.20]:42849 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751963AbYKOToo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 14:44:44 -0500
X-Authenticated: #36809985
X-Provags-ID: V01U2FsdGVkX19x53kYEVZxGwZvFVOpoikgrgJMvWvekm0TM/xj9s
	HWBj+5fwFP73Zs
Subject: [PATCH] Staging: et131x: remove unused variable in et1310_tx.c
From: Johann Felix Soden <johfel@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 15 Nov 2008 20:44:39 +0100
Message-Id: <1226778279.20477.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johann Felix Soden <johfel@users.sourceforge.net>

The 'pPacket' variable is assigned, but never used. Remove it.

Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
---
 drivers/staging/et131x/et1310_tx.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/et131x/et1310_tx.c b/drivers/staging/et131x/et1310_tx.c
index a95c260..30eaac4 100644
--- a/drivers/staging/et131x/et1310_tx.c
+++ b/drivers/staging/et131x/et1310_tx.c
@@ -1345,7 +1345,6 @@ void et131x_free_busy_send_packets(struct et131x_adapter *pAdapter)
 {
 	PMP_TCB pMpTcb;
 	struct list_head *pEntry;
-	struct sk_buff *pPacket = NULL;
 	unsigned long lockflags;
 	uint32_t FreeCounter = 0;
 
@@ -1358,8 +1357,6 @@ void et131x_free_busy_send_packets(struct et131x_adapter *pAdapter)
 		spin_unlock_irqrestore(&pAdapter->SendWaitLock, lockflags);
 
 		pEntry = pAdapter->TxRing.SendWaitQueue.next;
-
-		pPacket = NULL;
 	}
 
 	pAdapter->TxRing.nWaitSend = 0;
-- 
1.5.6.5


