Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbZIUFCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbZIUFCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 01:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbZIUFCC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 01:02:02 -0400
Received: from mail.atheros.com ([12.36.123.2]:20829 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbZIUFCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 01:02:00 -0400
From: <jie.yang@atheros.com>
To: <davem@davemloft.net>
CC: <akpm@linux-foundation.org>, <jirislaby@gmail.com>, <jcliburn@gmail.com>,
       <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       Jie Yang <jie.yang@atheros.com>
Subject: [Patch net-next]atl1c:remove compiling warning
Date: Mon, 21 Sep 2009 13:01:58 +0800
Message-ID: <12535093181069-git-send-email-jie.yang@atheros.com>
X-Mailer: git-send-email 1.5.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set wol_ctrl_data to value 0, to remove compiling warning.

Signed-off-by: Jie Yang <jie.yang@atheros.com>
---
diff --git a/drivers/net/atl1c/atl1c_main.c b/drivers/net/atl1c/atl1c_main.c
index be2c6cf..1372e9a 100644
--- a/drivers/net/atl1c/atl1c_main.c
+++ b/drivers/net/atl1c/atl1c_main.c
@@ -2296,7 +2296,7 @@ static int atl1c_suspend(struct pci_dev *pdev, pm_message_t state)
 	u32 ctrl;
 	u32 mac_ctrl_data;
 	u32 master_ctrl_data;
-	u32 wol_ctrl_data;
+	u32 wol_ctrl_data = 0;
 	u16 mii_bmsr_data;
 	u16 save_autoneg_advertised;
 	u16 mii_intr_status_data;
