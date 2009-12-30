Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbZL3SeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbZL3SeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 13:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZL3SeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 13:34:19 -0500
Received: from exprod6ob109.obsmtp.com ([64.18.1.22]:39858 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751575AbZL3SeT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 13:34:19 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/net/vxge/vxge-main.c: use %pM to show MAC address
Date: Wed, 30 Dec 2009 13:34:18 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F640@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/net/vxge/vxge-main.c: use %pM to show MAC address
Thread-Index: AcqJfrIgrAAOgYYTRwKuBo2sndYmAg==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 30 Dec 2009 18:34:17.0380 (UTC) FILETIME=[B1B51640:01CA897E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

diff --git a/drivers/net/vxge/vxge-main.c b/drivers/net/vxge/vxge-main.c
index f1c4b2a..5f0e7ea 100644
--- a/drivers/net/vxge/vxge-main.c
+++ b/drivers/net/vxge/vxge-main.c
@@ -4297,10 +4297,8 @@ vxge_probe(struct pci_dev *pdev, const struct pci_device_id *pre)
 	vxge_debug_init(VXGE_TRACE, "%s: Neterion %s Server Adapter",
 		vdev->ndev->name, ll_config.device_hw_info.product_desc);
 
-	vxge_debug_init(VXGE_TRACE,
-		"%s: MAC ADDR: %02X:%02X:%02X:%02X:%02X:%02X",
-		vdev->ndev->name, macaddr[0], macaddr[1], macaddr[2],
-		macaddr[3], macaddr[4], macaddr[5]);
+	vxge_debug_init(VXGE_TRACE, "%s: MAC ADDR: %pM",
+		vdev->ndev->name, macaddr);
 
 	vxge_debug_init(VXGE_TRACE, "%s: Link Width x%d",
 		vdev->ndev->name, vxge_hw_device_link_width_get(hldev)); 
