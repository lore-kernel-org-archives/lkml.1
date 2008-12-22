Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbYLVTYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbYLVTYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 14:24:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbYLVTSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 14:18:32 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:50184 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736AbYLVTS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 14:18:29 -0500
Subject: [PATCH 23/27] drivers/net/wireless: fix sparse warnings: make symbols
	static
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Dec 2008 20:18:23 +0100
Message-ID: <20081222191823.11807.62915.stgit@vmbox.hanneseder.net>
In-Reply-To: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
References: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:

  drivers/net/wireless/airo.c:3610:6: warning: symbol 'mpi_receive_802_11' was not declared. Should it be static?
  drivers/net/wireless/atmel.c:3183:6: warning: symbol 'atmel_join_bss' was not declared. Should it be static?
  drivers/net/wireless/ray_cs.c:831:5: warning: symbol 'ray_dev_init' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/wireless/airo.c   |    2 +-
 drivers/net/wireless/atmel.c  |    2 +-
 drivers/net/wireless/ray_cs.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 67d504e..fc4322c 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -3607,7 +3607,7 @@ badrx:
 	}
 }
 
-void mpi_receive_802_11 (struct airo_info *ai)
+static void mpi_receive_802_11(struct airo_info *ai)
 {
 	RxFid rxd;
 	struct sk_buff *skb = NULL;
diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index 3962b55..350157f 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -3180,7 +3180,7 @@ static void associate(struct atmel_private *priv, u16 frame_len, u16 subtype)
 	}
 }
 
-void atmel_join_bss(struct atmel_private *priv, int bss_index)
+static void atmel_join_bss(struct atmel_private *priv, int bss_index)
 {
 	struct bss_info *bss =  &priv->BSSinfo[bss_index];
 
diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 81b71f0..99ec7d6 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -828,7 +828,7 @@ static int ray_resume(struct pcmcia_device *link)
 }
 
 /*===========================================================================*/
-int ray_dev_init(struct net_device *dev)
+static int ray_dev_init(struct net_device *dev)
 {
 #ifdef RAY_IMMEDIATE_INIT
     int i;

