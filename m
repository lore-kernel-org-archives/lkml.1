Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400Ab0CMXmd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 18:42:33 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:48900 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab0CMXmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 18:42:31 -0500
From: Neil Grogan <neil@grogan.ie>
To: gregkh@suse.de, bzolnier@gmail.com
Cc: neil@grogan.ie, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: rt2860: Fix coding style errors in pci_main_dev.c This is a patch to the pci_main_dev.c file that fixes all coding style error Signed-off-by: Neil Grogan <neil@grogan.ie>
Date: Sat, 13 Mar 2010 23:42:12 +0000
Message-Id: <1268523732-29613-1-git-send-email-neil@grogan.ie>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/rt2860/pci_main_dev.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rt2860/pci_main_dev.c b/drivers/staging/rt2860/pci_main_dev.c
index 6af4304..4c20a7d 100644
--- a/drivers/staging/rt2860/pci_main_dev.c
+++ b/drivers/staging/rt2860/pci_main_dev.c
@@ -107,12 +107,12 @@ MODULE_VERSION(STA_DRIVER_VERSION);
 /* */
 static struct pci_driver rt2860_driver = {
 name:	"rt2860",
-id_table:rt2860_pci_tbl,
-probe:	rt2860_probe,
-remove:__devexit_p(rt2860_remove_one),
+id_table : rt2860_pci_tbl,
+probe : rt2860_probe,
+remove : __devexit_p(rt2860_remove_one),
 #ifdef CONFIG_PM
-suspend:rt2860_suspend,
-resume:rt2860_resume,
+suspend : rt2860_suspend,
+resume : rt2860_resume,
 #endif
 };
 
@@ -280,7 +280,9 @@ static int __devinit rt2860_probe(IN struct pci_dev *pci_dev,
 
 /*PCIDevInit============================================== */
 	/* wake up and enable device */
-	if ((rv = pci_enable_device(pci_dev)) != 0) {
+	rv = pci_enable_device(pci_dev);
+
+	if (rv != 0) {
 		DBGPRINT(RT_DEBUG_ERROR,
 			 ("Enable PCI device failed, errno=%d!\n", rv));
 		return rv;
@@ -288,7 +290,9 @@ static int __devinit rt2860_probe(IN struct pci_dev *pci_dev,
 
 	print_name = (char *)pci_name(pci_dev);
 
-	if ((rv = pci_request_regions(pci_dev, print_name)) != 0) {
+	rv = pci_request_regions(pci_dev, print_name);
+
+	if (rv != 0) {
 		DBGPRINT(RT_DEBUG_ERROR,
 			 ("Request PCI resource failed, errno=%d!\n", rv));
 		goto err_out;
@@ -1106,8 +1110,7 @@ void RTMPrt3xSetPCIePowerLinkCtrl(struct rt_rtmp_adapter *pAd)
 		HostConfiguration = 0;
 		if (pAd->StaCfg.PSControl.field.rt30xxForceASPMTest == 1) {
 			DBGPRINT(RT_DEBUG_TRACE, ("Enter,PSM : Force ASPM \n"));
-
-			/* Skip non-exist deice right away */
+			/* Skip non-exist device right away */
 			if ((pAd->HostLnkCtrlOffset != 0)) {
 				PCI_REG_READ_WORD(pObj->parent_pci_dev,
 						  pAd->HostLnkCtrlOffset,
-- 
1.6.3.3

