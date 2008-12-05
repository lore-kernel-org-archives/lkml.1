Return-Path: <linux-kernel-owner+w=401wt.eu-S1751986AbYLEFFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbYLEFFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 00:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbYLEFFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 00:05:35 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47691 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbYLEFFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 00:05:34 -0500
Message-ID: <4938B693.80002@jp.fujitsu.com>
Date: Fri, 05 Dec 2008 14:05:23 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: linux-pci@vger.kernel.org, tom.l.nguyen@intel.com, yanmin.zhang@intel.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] aerdrv: fix a typo in error message
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"TLP" is an acronym for "Transaction Layer Packet."

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 drivers/pci/pcie/aer/aerdrv_errprint.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
index 3933d4f..0fc29ae 100644
--- a/drivers/pci/pcie/aer/aerdrv_errprint.c
+++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
@@ -233,7 +233,7 @@ void aer_print_error(struct pci_dev *dev, struct aer_err_info *info)
 
 		if (info->flags & AER_TLP_HEADER_VALID_FLAG) {
 			unsigned char *tlp = (unsigned char *) &info->tlp;
-			printk("%sTLB Header:\n", loglevel);
+			printk("%sTLP Header:\n", loglevel);
 			printk("%s%02x%02x%02x%02x %02x%02x%02x%02x"
 				" %02x%02x%02x%02x %02x%02x%02x%02x\n",
 				loglevel,
-- 
1.6.0


