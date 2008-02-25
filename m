Return-Path: <linux-kernel-owner+w=401wt.eu-S1760090AbYBYAJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090AbYBYAJo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 19:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756848AbYBYAIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 19:08:22 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33639 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbYBYAIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 19:08:21 -0500
Date: Mon, 25 Feb 2008 02:07:25 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Tejun Heo <htejun@gmail.com>, Mark Lord <mlord@pobox.com>,
       Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make atapi_dmadir static
Message-ID: <20080225000725.GE2088@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atapi_dmadir can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/ata/libata-core.c |    2 +-
 drivers/ata/libata.h      |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

ad621a905275c744307cdb9bb4bab47a187a477b diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index fbc2435..b57fad3 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -113,7 +113,7 @@ int atapi_enabled = 1;
 module_param(atapi_enabled, int, 0444);
 MODULE_PARM_DESC(atapi_enabled, "Enable discovery of ATAPI devices (0=off, 1=on)");
 
-int atapi_dmadir = 0;
+static int atapi_dmadir = 0;
 module_param(atapi_dmadir, int, 0444);
 MODULE_PARM_DESC(atapi_dmadir, "Enable ATAPI DMADIR bridge support (0=off, 1=on)");
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 6036ded..aa884f7 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -56,7 +56,6 @@ enum {
 extern unsigned int ata_print_id;
 extern struct workqueue_struct *ata_aux_wq;
 extern int atapi_enabled;
-extern int atapi_dmadir;
 extern int atapi_passthru16;
 extern int libata_fua;
 extern int libata_noacpi;

