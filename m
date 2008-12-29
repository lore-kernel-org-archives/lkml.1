Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbYL2USf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbYL2USf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbYL2USS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:18:18 -0500
Received: from nm06omta12.auone-net.jp ([219.125.112.29]:4480 "HELO
	nmomta.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752698AbYL2USR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:18:17 -0500
X-Greylist: delayed 887 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Dec 2008 15:18:16 EST
Date: Tue, 30 Dec 2008 05:03:12 +0900
From: Kusanagi Kouichi <slash@ma.neweb.ne.jp>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tun: Fix SIOCSIFHWADDR error.
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Message-ID: <200812292003127246950006MAD1@nm06mta.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set proper operations.

Signed-off-by: Kusanagi Kouichi <slash@ma.neweb.ne.jp>
---
 drivers/net/tun.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 666c1d9..69f9a0e 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -343,7 +343,7 @@ static void tun_net_init(struct net_device *dev)
 		break;
 
 	case TUN_TAP_DEV:
-		dev->netdev_ops = &tun_netdev_ops;
+		dev->netdev_ops = &tap_netdev_ops;
 		/* Ethernet TAP Device */
 		ether_setup(dev);
 
-- 
1.5.6.5

