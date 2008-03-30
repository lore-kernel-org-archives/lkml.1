Return-Path: <linux-kernel-owner+w=401wt.eu-S1759502AbYC3XPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbYC3XPy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 19:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757338AbYC3XNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 19:13:23 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53926 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757278AbYC3XNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 19:13:23 -0400
Date: Mon, 31 Mar 2008 02:13:10 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dougthompson@xmission.com
Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] edac_pci.c: cleanups
Message-ID: <20080330231310.GJ28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make the needlessly global edac_pci_generic_check() static
- #if 0 the unused edac_pci_find()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/edac/edac_pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

37bdf6bee01d96d41f25c8d4001fd6817d3bb91b diff --git a/drivers/edac/edac_pci.c b/drivers/edac/edac_pci.c
index 32be435..4efa7f2 100644
--- a/drivers/edac/edac_pci.c
+++ b/drivers/edac/edac_pci.c
@@ -189,6 +189,7 @@ static void del_edac_pci_from_global_list(struct edac_pci_ctl_info *pci)
 	wait_for_completion(&pci->complete);
 }
 
+#if 0
 /*
  * edac_pci_find()
  * 	Search for an edac_pci_ctl_info structure whose index is 'idx'
@@ -219,6 +220,7 @@ struct edac_pci_ctl_info *edac_pci_find(int idx)
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(edac_pci_find);
+#endif  /*  0  */
 
 /*
  * edac_pci_workq_function()
@@ -422,7 +424,7 @@ EXPORT_SYMBOL_GPL(edac_pci_del_device);
  *
  *	a Generic parity check API
  */
-void edac_pci_generic_check(struct edac_pci_ctl_info *pci)
+static void edac_pci_generic_check(struct edac_pci_ctl_info *pci)
 {
 	debugf4("%s()\n", __func__);
 	edac_pci_do_parity_check();

