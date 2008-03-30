Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbYC3XQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbYC3XQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 19:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYC3XNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 19:13:32 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54811 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757577AbYC3XNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 19:13:31 -0400
Date: Mon, 31 Mar 2008 02:13:19 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dougthompson@xmission.com
Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] edac_pci_sysfs.c: make functions static
Message-ID: <20080330231319.GM28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- edac_pci_get_log_pe()
- edac_pci_get_log_npe()
- edac_pci_get_panic_on_pe()
- edac_pci_unregister_sysfs_instance_kobj()
- edac_pci_main_kobj_setup()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/edac/edac_pci_sysfs.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

1d1878a07fed3f6850fcc2245dab82dc1e254f87 diff --git a/drivers/edac/edac_pci_sysfs.c b/drivers/edac/edac_pci_sysfs.c
index 71c3195..e6fae3d 100644
--- a/drivers/edac/edac_pci_sysfs.c
+++ b/drivers/edac/edac_pci_sysfs.c
@@ -37,17 +37,17 @@ int edac_pci_get_check_errors(void)
 	return check_pci_errors;
 }
 
-int edac_pci_get_log_pe(void)
+static int edac_pci_get_log_pe(void)
 {
 	return edac_pci_log_pe;
 }
 
-int edac_pci_get_log_npe(void)
+static int edac_pci_get_log_npe(void)
 {
 	return edac_pci_log_npe;
 }
 
-int edac_pci_get_panic_on_pe(void)
+static int edac_pci_get_panic_on_pe(void)
 {
 	return edac_pci_panic_on_pe;
 }
@@ -197,7 +197,7 @@ error_out:
  *
  *	unregister the kobj for the EDAC PCI instance
  */
-void edac_pci_unregister_sysfs_instance_kobj(struct edac_pci_ctl_info *pci)
+static void edac_pci_unregister_sysfs_instance_kobj(struct edac_pci_ctl_info *pci)
 {
 	debugf0("%s()\n", __func__);
 
@@ -337,7 +337,7 @@ static struct kobj_type ktype_edac_pci_main_kobj = {
  *	setup the sysfs for EDAC PCI attributes
  *	assumes edac_class has already been initialized
  */
-int edac_pci_main_kobj_setup(void)
+static int edac_pci_main_kobj_setup(void)
 {
 	int err;
 	struct sysdev_class *edac_class;

