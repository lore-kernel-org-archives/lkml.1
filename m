Return-Path: <linux-kernel-owner+w=401wt.eu-S933678AbZHHHxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933678AbZHHHxo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 03:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbZHHHxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 03:53:43 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:42549 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451AbZHHHxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 03:53:42 -0400
Date: Sat, 8 Aug 2009 09:53:41 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivres/net: Change constant name
Message-ID: <Pine.LNX.4.64.0908080953090.25176@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In this series of tests the constants have the form XRXMAC_STATUS, except
in this one case.  The values of XRXMAC_STAT_MSK_RXOCTET_CNT_EXP and
XRXMAC_STATUS_RXOCTET_CNT_EXP are furthermore the same.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/niu.c                   |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/niu.c b/drivers/net/niu.c
index d2146d4..3ada7ea 100644
--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -4015,7 +4015,7 @@ static void niu_xmac_interrupt(struct niu *np)
 		mp->rx_hist_cnt6 += RXMAC_HIST_CNT6_COUNT;
 	if (val & XRXMAC_STATUS_RXHIST7_CNT_EXP)
 		mp->rx_hist_cnt7 += RXMAC_HIST_CNT7_COUNT;
-	if (val & XRXMAC_STAT_MSK_RXOCTET_CNT_EXP)
+	if (val & XRXMAC_STATUS_RXOCTET_CNT_EXP)
 		mp->rx_octets += RXMAC_BT_CNT_COUNT;
 	if (val & XRXMAC_STATUS_CVIOLERR_CNT_EXP)
 		mp->rx_code_violations += RXMAC_CD_VIO_CNT_COUNT;
