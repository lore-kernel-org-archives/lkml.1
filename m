Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026Ab0AEREq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab0AEREq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 12:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061Ab0AEREh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 12:04:37 -0500
Received: from [206.15.93.42] ([206.15.93.42]:9423 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932099Ab0AERD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 12:03:29 -0500
X-Greylist: delayed 1075 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2010 12:03:20 EST
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/net/vxge/vxge-main.c: use %pM to show MAC address
Date: Tue, 5 Jan 2010 09:59:23 -0700
Cc: netdev@vger.kernel.org, davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001050959.23591.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

Repost due to merge issues.

diff --git a/drivers/net/vxge/vxge-main.c b/drivers/net/vxge/vxge-main.c
index 0fdfd58..df13873 100644
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
