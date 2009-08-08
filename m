Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbZHHNWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbZHHNWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 09:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbZHHNWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 09:22:36 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47624 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbZHHNWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 09:22:35 -0400
Date: Sat, 8 Aug 2009 15:22:26 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Bob Copeland <me@bobcopeland.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Nick Kossifidis <mickflemm@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/net/wireless/ath/ath5k: Change constant name
Message-ID: <Pine.LNX.4.64.0908081521210.27715@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Elsewhere, the tqi_type field is compared to constants having a name
beginning with AR5K_TX_QUEUE, rather than AR5K_TX_QUEUE_ID.  I have thus
converted AR5K_TX_QUEUE_ID_CAB to AR5K_TX_QUEUE_CAB.  This does, however,
change the value, so perhaps something else was wanted.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/wireless/ath/ath5k/qcu.c           |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 6d5aaf0..eeebb9a 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -362,7 +362,7 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 		}
 
 		if (tq->tqi_ready_time &&
-		(tq->tqi_type != AR5K_TX_QUEUE_ID_CAB))
+		(tq->tqi_type != AR5K_TX_QUEUE_CAB))
 			ath5k_hw_reg_write(ah, AR5K_REG_SM(tq->tqi_ready_time,
 				AR5K_QCU_RDYTIMECFG_INTVAL) |
 				AR5K_QCU_RDYTIMECFG_ENABLE,
