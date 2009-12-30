Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZL3UNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZL3UNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbZL3UNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:13:10 -0500
Received: from exprod6og106.obsmtp.com ([64.18.1.191]:42887 "HELO
	exprod6og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753289AbZL3UNJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:13:09 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/net/qlge/qlge_main.c: use %pM to show MAC address
Date: Wed, 30 Dec 2009 15:13:07 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F671@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/net/qlge/qlge_main.c: use %pM to show MAC address
Thread-Index: AcqJjIBF8+O2ZcG4TJycMJthaoka+A==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 30 Dec 2009 20:13:05.0247 (UTC) FILETIME=[7EFDCEF0:01CA898C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

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
