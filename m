Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807Ab0AEREv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab0AEREv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 12:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755188Ab0AEREk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 12:04:40 -0500
Received: from [206.15.93.42] ([206.15.93.42]:9423 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932094Ab0AERD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 12:03:27 -0500
X-Greylist: delayed 1075 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2010 12:03:20 EST
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/net/qlge/qlge_main.c: use %pM to show MAC address
Date: Tue, 5 Jan 2010 09:58:12 -0700
Cc: netdev@vger.kernel.org, davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001050958.12329.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

Repost due to merge issues.

diff --git a/drivers/net/qlge/qlge_main.c b/drivers/net/qlge/qlge_main.c
index 707b391..628642a 100644
--- a/drivers/net/qlge/qlge_main.c
+++ b/drivers/net/qlge/qlge_main.c
@@ -452,9 +452,7 @@ static int ql_set_mac_addr(struct ql_adapter *qdev, int set)
 	if (set) {
 		addr = &qdev->ndev->dev_addr[0];
 		QPRINTK(qdev, IFUP, DEBUG,
-			"Set Mac addr %02x:%02x:%02x:%02x:%02x:%02x\n",
-			addr[0], addr[1], addr[2], addr[3],
-			addr[4], addr[5]);
+			"Set Mac addr %pM\n", addr);
 	} else {
 		memset(zero_mac_addr, 0, ETH_ALEN);
 		addr = &zero_mac_addr[0];
