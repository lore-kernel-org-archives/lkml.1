Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbZFAVdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbZFAVdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZFAVcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:32:55 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:33187 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbZFAVcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:32:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QTnfx6YuZDTQJsnZHvhIkYUenkHQ7QU24lnCQczyBnbCfdTdWBTap2IPTpKJwCI1Er
         irPj2XDlF7WW+Nz6t4xkuSUW3j1qi8GmT+H/CaToC5QWlavUoTEOv7nmF6Bl4iy4ey+E
         OhrgZ9AQ5LweDDyc+pGYPWB4t7vqmFGeCPUZw=
From: Alexander Potashev <aspotashev@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Alexander Potashev <aspotashev@gmail.com>
Subject: [PATCH] Use KERN_INFO instead of KERN_ERR for init message
Date: Tue,  2 Jun 2009 01:33:01 +0400
Message-Id: <1243891981-12118-1-git-send-email-aspotashev@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Potashev <aspotashev@gmail.com>
---
 drivers/dca/dca-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dca/dca-core.c b/drivers/dca/dca-core.c
index 25b743a..e7c0b9c 100644
--- a/drivers/dca/dca-core.c
+++ b/drivers/dca/dca-core.c
@@ -276,7 +276,7 @@ EXPORT_SYMBOL_GPL(dca_unregister_notify);
 
 static int __init dca_init(void)
 {
-	printk(KERN_ERR "dca service started, version %s\n", DCA_VERSION);
+	printk(KERN_INFO "dca service started, version %s\n", DCA_VERSION);
 	return dca_sysfs_init();
 }
 
-- 
1.6.2.3

