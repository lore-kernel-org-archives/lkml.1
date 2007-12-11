Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbXLKWUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbXLKWUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXLKWUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:20:24 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:54605 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751917AbXLKWUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:20:21 -0500
Date: Tue, 11 Dec 2007 23:20:22 +0100
From: Adrian Bunk <bunk@kernel.org>
To: yi.zhu@intel.com, jketreno@linux.intel.com
Cc: linux-wireless@vger.kernel.org, ipw2100-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] wireless/ipw2200.c: add __dev{init,exit} annotations
Message-ID: <20071211222022.GC14204@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds __dev{init,exit} annotations.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/net/wireless/ipw2200.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

dc37213e10799b6613c322c775923f070c8d5d9b 
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index 54f44e5..da51f47 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -10751,7 +10751,7 @@ static void ipw_bg_link_down(struct work_struct *work)
 	mutex_unlock(&priv->mutex);
 }
 
-static int ipw_setup_deferred_work(struct ipw_priv *priv)
+static int __devinit ipw_setup_deferred_work(struct ipw_priv *priv)
 {
 	int ret = 0;
 
@@ -11600,7 +11600,8 @@ static void ipw_prom_free(struct ipw_priv *priv)
 #endif
 
 
-static int ipw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+static int __devinit ipw_pci_probe(struct pci_dev *pdev,
+				   const struct pci_device_id *ent)
 {
 	int err = 0;
 	struct net_device *net_dev;
@@ -11767,7 +11768,7 @@ static int ipw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return err;
 }
 
-static void ipw_pci_remove(struct pci_dev *pdev)
+static void __devexit ipw_pci_remove(struct pci_dev *pdev)
 {
 	struct ipw_priv *priv = pci_get_drvdata(pdev);
 	struct list_head *p, *q;

