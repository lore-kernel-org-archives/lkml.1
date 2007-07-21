Return-Path: <linux-kernel-owner+w=401wt.eu-S936242AbXGUPJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936242AbXGUPJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939386AbXGUPDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:03:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:39272 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939373AbXGUPDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:03:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=g22SD2+d8sD7n5cTudHNMu1kswPBFs0YABBOCvzb9cJ1A/SREqjx+e1P3r8tYS3CW/GJUZtJ+B8tvwfEGQgQVkX4FBeaTCbUtwEywdxmKKy9jRYf0UZ9krPwTy6Rke1ZZ7JNCxkpSwV02VH5rG/uYpSB59z9t5VP6MnpS8hlbjs=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][13/37] Clean up duplicate includes in drivers/scsi/
Date: Sat, 21 Jul 2007 17:02:53 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       James Smart <james.smart@emulex.com>,
       Christoph Hellwig <hch@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211702.53876.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	drivers/scsi/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/drivers/scsi/NCR_D700.c b/drivers/scsi/NCR_D700.c
index 3a80897..e0f1991 100644
--- a/drivers/scsi/NCR_D700.c
+++ b/drivers/scsi/NCR_D700.c
@@ -97,7 +97,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mca.h>
-#include <linux/interrupt.h>
 #include <asm/io.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 673cfe1..039892c 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -43,7 +43,6 @@
 #include "lpfc_crtn.h"
 #include "lpfc_vport.h"
 #include "lpfc_version.h"
-#include "lpfc_vport.h"
 #include "lpfc_debugfs.h"
 
 #ifdef CONFIG_LPFC_DEBUG_FS
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 07bd0dc..3a51266 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -43,7 +43,6 @@
 #include "lpfc_crtn.h"
 #include "lpfc_vport.h"
 #include "lpfc_version.h"
-#include "lpfc_vport.h"
 
 static int lpfc_parse_vpd(struct lpfc_hba *, uint8_t *, int);
 static void lpfc_get_hba_model_desc(struct lpfc_hba *, uint8_t *, uint8_t *);
