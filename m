Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbZBPEqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbZBPEqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 23:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbZBPEqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 23:46:19 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:17587 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047AbZBPEqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 23:46:18 -0500
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH 2.6.30] cxgb3: Add support for PCI ID 0x35.
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Sun, 15 Feb 2009 20:46:15 -0800
Message-ID: <20090216044615.24884.9331.stgit@speedy5>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Add support for adapters with a PCI id equal to 0x35.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/cxgb3_main.c |    1 +
 drivers/net/cxgb3/t3_hw.c      |    7 +++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
index f2c7cc3..6473084 100644
--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -90,6 +90,7 @@ static const struct pci_device_id cxgb3_pci_tbl[] = {
 	CH_DEVICE(0x30, 2),	/* T3B10 */
 	CH_DEVICE(0x31, 3),	/* T3B20 */
 	CH_DEVICE(0x32, 1),	/* T3B02 */
+	CH_DEVICE(0x35, 6),	/* T3C20-derived T3C10 */
 	{0,}
 };
 
diff --git a/drivers/net/cxgb3/t3_hw.c b/drivers/net/cxgb3/t3_hw.c
index 2d14330..ac2a974 100644
--- a/drivers/net/cxgb3/t3_hw.c
+++ b/drivers/net/cxgb3/t3_hw.c
@@ -512,6 +512,13 @@ static const struct adapter_info t3_adap_info[] = {
 	 F_GPIO5_OUT_VAL | F_GPIO6_OUT_VAL | F_GPIO10_OUT_VAL,
 	 { S_GPIO9, S_GPIO3 }, SUPPORTED_10000baseT_Full | SUPPORTED_AUI,
 	 &mi1_mdio_ext_ops, "Chelsio T320"},
+	{},
+	{},
+	{1, 0,
+	 F_GPIO1_OEN | F_GPIO2_OEN | F_GPIO4_OEN | F_GPIO6_OEN | F_GPIO7_OEN |
+	 F_GPIO10_OEN | F_GPIO1_OUT_VAL | F_GPIO6_OUT_VAL | F_GPIO10_OUT_VAL,
+	 { S_GPIO9 }, SUPPORTED_10000baseT_Full | SUPPORTED_AUI,
+	 &mi1_mdio_ext_ops, "Chelsio T310" },
 };
 
 /*

