Return-Path: <linux-kernel-owner+w=401wt.eu-S933316AbXKPTWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933316AbXKPTWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 14:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762904AbXKPTVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 14:21:52 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:26337 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762022AbXKPTVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 14:21:50 -0500
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH 2/9] cxgb3 - Use wild card for PCI vendor ID match
To: jeff@garzik.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com, wenxiong@us.ibm.com
Date: Fri, 16 Nov 2007 11:21:44 -0800
Message-ID: <20071116192144.31042.69591.stgit@speedy5>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Vendor ID is not necessarily set to 1. 
Use Vendor Id wild card for PCI device matching

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/cxgb3_main.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
index bb0d1c8..d92da8f 100644
--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -76,20 +76,20 @@ enum {
 
 #define EEPROM_MAGIC 0x38E2F10C
 
-#define CH_DEVICE(devid, ssid, idx) \
-	{ PCI_VENDOR_ID_CHELSIO, devid, PCI_ANY_ID, ssid, 0, 0, idx }
+#define CH_DEVICE(devid, idx) \
+	{ PCI_VENDOR_ID_CHELSIO, devid, PCI_ANY_ID, PCI_ANY_ID, 0, 0, idx }
 
 static const struct pci_device_id cxgb3_pci_tbl[] = {
-	CH_DEVICE(0x20, 1, 0),	/* PE9000 */
-	CH_DEVICE(0x21, 1, 1),	/* T302E */
-	CH_DEVICE(0x22, 1, 2),	/* T310E */
-	CH_DEVICE(0x23, 1, 3),	/* T320X */
-	CH_DEVICE(0x24, 1, 1),	/* T302X */
-	CH_DEVICE(0x25, 1, 3),	/* T320E */
-	CH_DEVICE(0x26, 1, 2),	/* T310X */
-	CH_DEVICE(0x30, 1, 2),	/* T3B10 */
-	CH_DEVICE(0x31, 1, 3),	/* T3B20 */
-	CH_DEVICE(0x32, 1, 1),	/* T3B02 */
+	CH_DEVICE(0x20, 0),	/* PE9000 */
+	CH_DEVICE(0x21, 1),	/* T302E */
+	CH_DEVICE(0x22, 2),	/* T310E */
+	CH_DEVICE(0x23, 3),	/* T320X */
+	CH_DEVICE(0x24, 1),	/* T302X */
+	CH_DEVICE(0x25, 3),	/* T320E */
+	CH_DEVICE(0x26, 2),	/* T310X */
+	CH_DEVICE(0x30, 2),	/* T3B10 */
+	CH_DEVICE(0x31, 3),	/* T3B20 */
+	CH_DEVICE(0x32, 1),	/* T3B02 */
 	{0,}
 };
 
