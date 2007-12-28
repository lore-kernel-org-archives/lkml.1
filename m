Return-Path: <linux-kernel-owner+w=401wt.eu-S1752726AbXL1UVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbXL1UVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:21:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbXL1UVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:21:00 -0500
Received: from mail0.lsil.com ([147.145.40.20]:63998 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbXL1UU7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:20:59 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [2.6 patch] scsi/megaraid.c: __devexit annotation
Date: Fri, 28 Dec 2007 13:20:32 -0700
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229E022DA@NAMAIL2.ad.lsil.com>
In-Reply-To: <20071211222331.GW14204@stusta.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6 patch] scsi/megaraid.c: __devexit annotation
Thread-Index: Acg8RHoRxZS/MPWLQAukdzROdyTYVQNSmjeQ
From: "Patro, Sumant" <Sumant.Patro@lsi.com>
To: "Adrian Bunk" <bunk@kernel.org>,
       "DL-MegaRAID Linux" <megaraidlinux@lsi.com>,
       <James.Bottomley@HansenPartnership.com>
Cc: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 Dec 2007 20:20:32.0635 (UTC) FILETIME=[18DD0CB0:01C8498F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ack.

Regards,

Sumant 

-----Original Message-----
From: Adrian Bunk [mailto:bunk@kernel.org] 
Sent: Tuesday, December 11, 2007 2:24 PM
To: DL-MegaRAID Linux; James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [2.6 patch] scsi/megaraid.c: __devexit annotation

megaraid_remove_one() can become __devexit.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
b7d71f38d1c1aa66311e862b58f36aa34c888f98
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c index
66c6520..765c24d 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4889,7 +4889,7 @@ __megaraid_shutdown(adapter_t *adapter)
 		mdelay(1000);
 }
 
-static void
+static void __devexit
 megaraid_remove_one(struct pci_dev *pdev)  {
 	struct Scsi_Host *host = pci_get_drvdata(pdev);

