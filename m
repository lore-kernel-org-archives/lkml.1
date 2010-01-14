Return-Path: <linux-kernel-owner+w=401wt.eu-S932297Ab0ANW3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab0ANW3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932299Ab0ANW3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:29:00 -0500
Received: from kroah.org ([198.145.64.141]:60706 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247Ab0ANW26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:58 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Samuel Ortiz <sameo@linux.intel.com>,
       Holger Schurig <holgerschurig@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 45/52] libertas: Remove carrier signaling from the scan code
Date: Thu, 14 Jan 2010 14:27:24 -0800
Message-Id: <1263508051-7868-45-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-44-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263508051-7868-16-git-send-email-gregkh@suse.de>
 <1263508051-7868-17-git-send-email-gregkh@suse.de>
 <1263508051-7868-18-git-send-email-gregkh@suse.de>
 <1263508051-7868-19-git-send-email-gregkh@suse.de>
 <1263508051-7868-20-git-send-email-gregkh@suse.de>
 <1263508051-7868-21-git-send-email-gregkh@suse.de>
 <1263508051-7868-22-git-send-email-gregkh@suse.de>
 <1263508051-7868-23-git-send-email-gregkh@suse.de>
 <1263508051-7868-24-git-send-email-gregkh@suse.de>
 <1263508051-7868-25-git-send-email-gregkh@suse.de>
 <1263508051-7868-26-git-send-email-gregkh@suse.de>
 <1263508051-7868-27-git-send-email-gregkh@suse.de>
 <1263508051-7868-28-git-send-email-gregkh@suse.de>
 <1263508051-7868-29-git-send-email-gregkh@suse.de>
 <1263508051-7868-30-git-send-email-gregkh@suse.de>
 <1263508051-7868-31-git-send-email-gregkh@suse.de>
 <1263508051-7868-32-git-send-email-gregkh@suse.de>
 <1263508051-7868-33-git-send-email-gregkh@suse.de>
 <1263508051-7868-34-git-send-email-gregkh@suse.de>
 <1263508051-7868-35-git-send-email-gregkh@suse.de>
 <1263508051-7868-36-git-send-email-gregkh@suse.de>
 <1263508051-7868-37-git-send-email-gregkh@suse.de>
 <1263508051-7868-38-git-send-email-gregkh@suse.de>
 <1263508051-7868-39-git-send-email-gregkh@suse.de>
 <1263508051-7868-40-git-send-email-gregkh@suse.de>
 <1263508051-7868-41-git-send-email-gregkh@suse.de>
 <1263508051-7868-42-git-send-email-gregkh@suse.de>
 <1263508051-7868-43-git-send-email-gregkh@suse.de>
 <1263508051-7868-44-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

commit 659c8e5243caf14564155ad8421404f044dd8031 upstream.

There is no reason to signal a carrier off when doing a 802.11 scan.

Cc: Holger Schurig <holgerschurig@gmail.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Acked-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/libertas/scan.c |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 6c95af3..06d66a1 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -399,11 +399,8 @@ int lbs_scan_networks(struct lbs_private *priv, int full_scan)
 	chan_count = lbs_scan_create_channel_list(priv, chan_list);
 
 	netif_stop_queue(priv->dev);
-	netif_carrier_off(priv->dev);
-	if (priv->mesh_dev) {
+	if (priv->mesh_dev)
 		netif_stop_queue(priv->mesh_dev);
-		netif_carrier_off(priv->mesh_dev);
-	}
 
 	/* Prepare to continue an interrupted scan */
 	lbs_deb_scan("chan_count %d, scan_channel %d\n",
@@ -467,16 +464,13 @@ out2:
 	priv->scan_channel = 0;
 
 out:
-	if (priv->connect_status == LBS_CONNECTED) {
-		netif_carrier_on(priv->dev);
-		if (!priv->tx_pending_len)
-			netif_wake_queue(priv->dev);
-	}
-	if (priv->mesh_dev && (priv->mesh_connect_status == LBS_CONNECTED)) {
-		netif_carrier_on(priv->mesh_dev);
-		if (!priv->tx_pending_len)
-			netif_wake_queue(priv->mesh_dev);
-	}
+	if (priv->connect_status == LBS_CONNECTED && !priv->tx_pending_len)
+		netif_wake_queue(priv->dev);
+
+	if (priv->mesh_dev && (priv->mesh_connect_status == LBS_CONNECTED) &&
+	    !priv->tx_pending_len)
+		netif_wake_queue(priv->mesh_dev);
+
 	kfree(chan_list);
 
 	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
-- 
1.6.6

