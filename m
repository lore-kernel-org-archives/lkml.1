Return-Path: <linux-kernel-owner+w=401wt.eu-S1161029AbXD1TVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161029AbXD1TVx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161071AbXD1TUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:20:42 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37521 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031190AbXD1TUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:20:23 -0400
Date: Sat, 28 Apr 2007 21:20:34 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       James Smart <James.Smart@emulex.com>,
       James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [-mm patch] scsi/lpfc/lpfc_init.c: remove unused variable
Message-ID: <20070428192034.GW3468@stusta.de>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a no longer used variable:

<--  snip  -->

...
  CC      drivers/scsi/lpfc/lpfc_init.o
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc7-mm2/drivers/scsi/lpfc/lpfc_init.c: In function ‘lpfc_pci_probe_one’:
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc7-mm2/drivers/scsi/lpfc/lpfc_init.c:1419: warning: unused variable ‘retval’
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc7-mm2/drivers/scsi/lpfc/lpfc_init.c.old	2007-04-28 15:20:42.000000000 +0200
+++ linux-2.6.21-rc7-mm2/drivers/scsi/lpfc/lpfc_init.c	2007-04-28 15:20:57.000000000 +0200
@@ -1416,7 +1416,7 @@
 	struct lpfc_sli  *psli;
 	struct lpfc_iocbq *iocbq_entry = NULL, *iocbq_next = NULL;
 	unsigned long bar0map_len, bar2map_len;
-	int error = -ENODEV, retval;
+	int error = -ENODEV;
 	int i;
 	uint16_t iotag;
 

