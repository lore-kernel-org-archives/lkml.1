Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbYKZUjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbYKZUjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 15:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYKZUja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 15:39:30 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:31657 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbYKZUj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 15:39:28 -0500
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH 4/4 2.6.29] cxgb3 - Update FW loading patch
To: jeff@garzik.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Wed, 26 Nov 2008 12:39:18 -0800
Message-ID: <20081126203915.4896.63231.stgit@speedy5>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Update FW loading path to accomodate in-kernel images location

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/cxgb3_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
index 96c94a4..46c114e 100644
--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -853,8 +853,8 @@ static int bind_qsets(struct adapter *adap)
 	return err;
 }
 
-#define FW_FNAME "t3fw-%d.%d.%d.bin"
-#define TPSRAM_NAME "t3%c_protocol_sram-%d.%d.%d.bin"
+#define FW_FNAME "cxgb3/t3fw-%d.%d.%d.bin"
+#define TPSRAM_NAME "cxgb3/t3%c_psram-%d.%d.%d.bin"
 
 static int upgrade_fw(struct adapter *adap)
 {

