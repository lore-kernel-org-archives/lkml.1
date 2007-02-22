Return-Path: <linux-kernel-owner+w=401wt.eu-S1161172AbXBVMAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161172AbXBVMAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 07:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945982AbXBVMAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 07:00:16 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:30547 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161146AbXBVL7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 06:59:37 -0500
From: divy@chelsio.com
Subject: [PATCH 3/7] cxgb3 - FW version update
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Thu, 22 Feb 2007 03:59:30 -0800
Message-ID: <20070222115930.10019.63966.stgit@localhost.localdomain>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Update FW version to 3.2

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/t3_hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/cxgb3/t3_hw.c b/drivers/net/cxgb3/t3_hw.c
index 365a7f5..ec06ad6 100644
--- a/drivers/net/cxgb3/t3_hw.c
+++ b/drivers/net/cxgb3/t3_hw.c
@@ -884,7 +884,7 @@ int t3_check_fw_version(struct adapter *
 	major = G_FW_VERSION_MAJOR(vers);
 	minor = G_FW_VERSION_MINOR(vers);
 
-	if (type == FW_VERSION_T3 && major == 3 && minor == 1)
+	if (type == FW_VERSION_T3 && major == 3 && minor == 2)
 		return 0;
 
 	CH_ERR(adapter, "found wrong FW version(%u.%u), "
