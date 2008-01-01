Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbYAACMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbYAACMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 21:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbYAACGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 21:06:00 -0500
Received: from fmailhost03.isp.att.net ([207.115.11.53]:43882 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbYAACFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 21:05:41 -0500
X-Originating-IP: [68.222.90.230]
From: jacliburn@bellsouth.net
To: jeff@garzik.org
Cc: csnook@redhat.com, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net, Jay Cliburn <jacliburn@bellsouth.net>
Subject: [PATCH 18/26] atl1: make function static
Date: Mon, 31 Dec 2007 19:59:56 -0600
Message-Id: <1199152804-3889-19-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
References: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cliburn <jacliburn@bellsouth.net>

Make atl1_reset() a static function.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---
 drivers/net/atlx/atl1.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index 6432956..7697e80 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -2351,12 +2351,13 @@ static void atl1_phy_config(unsigned long data)
 	clear_bit(0, &adapter->cfg_phy);
 }
 
-int atl1_reset(struct atl1_adapter *adapter)
+static int atl1_reset(struct atl1_adapter *adapter)
 {
-	int ret;
-	ret = atl1_reset_hw(&adapter->hw);
-	if (ret)
-		return ret;
+	int retval;
+
+	retval = atl1_reset_hw(&adapter->hw);
+	if (retval)
+		return retval;
 	return atl1_init_hw(&adapter->hw);
 }
 
-- 
1.5.3.3

