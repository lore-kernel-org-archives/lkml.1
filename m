Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933819Ab0CMJBQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 04:01:16 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:54093 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933065Ab0CMJBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 04:01:15 -0500
Date: Sat, 13 Mar 2010 10:01:09 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Matt Carlson <mcarlson@broadcom.com>, Michael Chan <mchan@broadcom.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/net/tg3.c: change the field used with the
 TG3_FLAG_10_100_ONLY constant
Message-ID: <Pine.LNX.4.64.1003131000420.30245@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The constant TG3_FLAG_10_100_ONLY should be used with the tg3_flags field,
not the tg3_flags2 field, as done elsewhere in the same file.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/tg3.c                   |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index 0fa7688..fa8fb1a 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -9776,7 +9776,7 @@ static int tg3_set_settings(struct net_device *dev, struct ethtool_cmd *cmd)
 			   ADVERTISED_Pause |
 			   ADVERTISED_Asym_Pause;
 
-		if (!(tp->tg3_flags2 & TG3_FLAG_10_100_ONLY))
+		if (!(tp->tg3_flags & TG3_FLAG_10_100_ONLY))
 			mask |= ADVERTISED_1000baseT_Half |
 				ADVERTISED_1000baseT_Full;
 
