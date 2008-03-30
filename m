Return-Path: <linux-kernel-owner+w=401wt.eu-S1759348AbYC3XPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348AbYC3XPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 19:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757029AbYC3XNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 19:13:15 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54797 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756975AbYC3XNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 19:13:14 -0400
Date: Mon, 31 Mar 2008 02:13:01 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dougthompson@xmission.com
Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] #if 0 edac_check_mc_devices()
Message-ID: <20080330231301.GI28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch #if 0's the no longer used edac_check_mc_devices().

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/edac/edac_mc.c     |    2 ++
 drivers/edac/edac_module.h |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

94824102fa8f6f35cbc3d81ff6c2824ed162b9ab diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 063a1bf..5a2f905 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -887,6 +887,7 @@ void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
 }
 EXPORT_SYMBOL(edac_mc_handle_fbd_ce);
 
+#if 0
 /*
  * Iterate over all MC instances and check for ECC, et al, errors
  */
@@ -907,3 +908,4 @@ void edac_check_mc_devices(void)
 
 	mutex_unlock(&mem_ctls_mutex);
 }
+#endif  /*  0  */
diff --git a/drivers/edac/edac_module.h b/drivers/edac/edac_module.h
index cbc419c..233d479 100644
--- a/drivers/edac/edac_module.h
+++ b/drivers/edac/edac_module.h
@@ -27,7 +27,6 @@ extern int edac_mc_register_sysfs_main_kobj(struct mem_ctl_info *mci);
 extern void edac_mc_unregister_sysfs_main_kobj(struct mem_ctl_info *mci);
 extern int edac_create_sysfs_mci_device(struct mem_ctl_info *mci);
 extern void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci);
-extern void edac_check_mc_devices(void);
 extern int edac_get_log_ue(void);
 extern int edac_get_log_ce(void);
 extern int edac_get_panic_on_ue(void);

