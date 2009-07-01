Return-Path: <linux-kernel-owner+w=401wt.eu-S932669AbZGABWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669AbZGABWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765510AbZGABEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 21:04:23 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:59229 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765516AbZGABES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 21:04:18 -0400
From: Andy Isaacson <adi@vmware.com>
To: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Cc: adi@hexapodia.org, Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       dds@google.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>, seiji.munetoh@gmail.com,
       Andy Isaacson <adi@vmware.com>
Subject: [PATCH 1/6] tpm_tis: various cleanups
Date: Tue, 30 Jun 2009 18:04:10 -0700
Message-Id: <1246410255-6839-2-git-send-email-adi@vmware.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1246410255-6839-1-git-send-email-adi@vmware.com>
References: <1246410255-6839-1-git-send-email-adi@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid tabs in printk output.
Use parentheses and ARRAY_SIZE() in macro definition.

Signed-off-by: Andy Isaacson <adi@vmware.com>
---
 drivers/char/tpm/tpm_tis.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 717af7a..1b84441 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -474,23 +474,23 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	dev_dbg(dev, "TPM interface capabilities (0x%x):\n",
 		intfcaps);
 	if (intfcaps & TPM_INTF_BURST_COUNT_STATIC)
-		dev_dbg(dev, "\tBurst Count Static\n");
+		dev_dbg(dev, "    Burst Count Static\n");
 	if (intfcaps & TPM_INTF_CMD_READY_INT)
-		dev_dbg(dev, "\tCommand Ready Int Support\n");
+		dev_dbg(dev, "    Command Ready Int Support\n");
 	if (intfcaps & TPM_INTF_INT_EDGE_FALLING)
-		dev_dbg(dev, "\tInterrupt Edge Falling\n");
+		dev_dbg(dev, "    Interrupt Edge Falling\n");
 	if (intfcaps & TPM_INTF_INT_EDGE_RISING)
-		dev_dbg(dev, "\tInterrupt Edge Rising\n");
+		dev_dbg(dev, "    Interrupt Edge Rising\n");
 	if (intfcaps & TPM_INTF_INT_LEVEL_LOW)
-		dev_dbg(dev, "\tInterrupt Level Low\n");
+		dev_dbg(dev, "    Interrupt Level Low\n");
 	if (intfcaps & TPM_INTF_INT_LEVEL_HIGH)
-		dev_dbg(dev, "\tInterrupt Level High\n");
+		dev_dbg(dev, "    Interrupt Level High\n");
 	if (intfcaps & TPM_INTF_LOCALITY_CHANGE_INT)
-		dev_dbg(dev, "\tLocality Change Int Support\n");
+		dev_dbg(dev, "    Locality Change Int Support\n");
 	if (intfcaps & TPM_INTF_STS_VALID_INT)
-		dev_dbg(dev, "\tSts Valid Int Support\n");
+		dev_dbg(dev, "    Sts Valid Int Support\n");
 	if (intfcaps & TPM_INTF_DATA_AVAIL_INT)
-		dev_dbg(dev, "\tData Avail Int Support\n");
+		dev_dbg(dev, "    Data Avail Int Support\n");
 
 	/* INTERRUPT Setup */
 	init_waitqueue_head(&chip->vendor.read_queue);
@@ -649,7 +649,7 @@ static struct pnp_driver tis_pnp_driver = {
 	.remove = tpm_tis_pnp_remove,
 };
 
-#define TIS_HID_USR_IDX sizeof(tpm_pnp_tbl)/sizeof(struct pnp_device_id) -2
+#define TIS_HID_USR_IDX (ARRAY_SIZE(tpm_pnp_tbl) - 2)
 module_param_string(hid, tpm_pnp_tbl[TIS_HID_USR_IDX].id,
 		    sizeof(tpm_pnp_tbl[TIS_HID_USR_IDX].id), 0444);
 MODULE_PARM_DESC(hid, "Set additional specific HID for this driver to probe");
-- 
1.6.3.1

