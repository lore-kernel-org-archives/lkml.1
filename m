Return-Path: <linux-kernel-owner+w=401wt.eu-S1758063AbXLKW0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbXLKW0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756163AbXLKWXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:23:31 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38538 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756033AbXLKWXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:23:30 -0500
Date: Tue, 11 Dec 2007 23:23:31 +0100
From: Adrian Bunk <bunk@kernel.org>
To: megaraidlinux@lsi.com, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] scsi/megaraid.c: __devexit annotation
Message-ID: <20071211222331.GW14204@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

megaraid_remove_one() can become __devexit.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
b7d71f38d1c1aa66311e862b58f36aa34c888f98 
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 66c6520..765c24d 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4889,7 +4889,7 @@ __megaraid_shutdown(adapter_t *adapter)
 		mdelay(1000);
 }
 
-static void
+static void __devexit
 megaraid_remove_one(struct pci_dev *pdev)
 {
 	struct Scsi_Host *host = pci_get_drvdata(pdev);

