Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbYIKMek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbYIKMek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 08:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755396AbYIKMeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 08:34:18 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:58159 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056AbYIKMeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 08:34:12 -0400
Date: Thu, 11 Sep 2008 14:34:09 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: chas@cmf.nrl.navy.mil, vigneshbabu@gmail.com, richard.genoud@gmail.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/5] net/atm/lec.c: Drop code after return
Message-ID: <Pine.LNX.4.64.0809111433510.9593@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The break after the return serves no purpose.

Signed-off-by: Julia Lawall <julia@diku.dk>
---

 net/atm/lec.c                 |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/atm/lec.c b/net/atm/lec.c
index 5799fb5..8f701cd 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -1931,7 +1931,6 @@ static struct atm_vcc *lec_arp_resolve(struct lec_priv *priv,
 		switch (priv->lane_version) {
 		case 1:
 			return priv->mcast_vcc;
-			break;
 		case 2:	/* LANE2 wants arp for multicast addresses */
 			if (!compare_ether_addr(mac_to_find, bus_mac))
 				return priv->mcast_vcc;
