Return-Path: <linux-kernel-owner+w=401wt.eu-S1759573AbYC3XQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573AbYC3XQW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 19:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756874AbYC3XNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 19:13:30 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53931 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757548AbYC3XN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 19:13:29 -0400
Date: Mon, 31 Mar 2008 02:13:16 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dougthompson@xmission.com
Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] #if 0 edac_device_find()
Message-ID: <20080330231316.GL28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch #if 0's the unused edac_device_find().

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/edac/edac_device.c |    2 ++
 1 file changed, 2 insertions(+)

25f2309d2f8850bb0f12bd73f651df1b2ee60aa4 diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index b9552bc..f45a8cd 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -375,6 +375,7 @@ static void del_edac_device_from_global_list(struct edac_device_ctl_info
 	wait_for_completion(&edac_device->removal_complete);
 }
 
+#if 0
 /**
  * edac_device_find
  *	Search for a edac_device_ctl_info structure whose index is 'idx'.
@@ -405,6 +406,7 @@ struct edac_device_ctl_info *edac_device_find(int idx)
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(edac_device_find);
+#endif  /*  0  */
 
 /*
  * edac_device_workq_function

