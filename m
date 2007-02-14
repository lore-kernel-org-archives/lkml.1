Return-Path: <linux-kernel-owner+w=401wt.eu-S932211AbXBNBCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbXBNBCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 20:02:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932208AbXBNBCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 20:02:06 -0500
Received: from mail0.lsil.com ([147.145.40.20]:40951 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209AbXBNBCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 20:02:04 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] scsi/megaraid.c: pci_module_init to pci_register_driver
Date: Tue, 13 Feb 2007 18:01:56 -0700
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229920F78@NAMAIL2.ad.lsil.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] scsi/megaraid.c: pci_module_init to pci_register_driver
Thread-Index: AcdP0aek7Iixt7xIRyW53yd5a2PRWQAAgHLw
From: "Patro, Sumant" <Sumant.Patro@lsi.com>
To: "Richard Knutsson" <ricknu-0@student.ltu.se>,
       "Kolli, Neela" <Neela.Kolli@lsi.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
X-OriginalArrivalTime: 14 Feb 2007 01:01:57.0991 (UTC) FILETIME=[B9F56770:01C74FD3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ACK.

--Sumant
 

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Richard Knutsson
Sent: Tuesday, February 13, 2007 4:41 PM
To: Kolli, Neela
Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Richard
Knutsson
Subject: [PATCH] scsi/megaraid.c: pci_module_init to pci_register_driver

Convert pci_module_init() to pci_register_driver().

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested with "allyes", "allmod" & "allno" on i386


diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c index
808a1b8..0aa3304 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -5072,7 +5072,7 @@ static int __init megaraid_init(void)
 				"megaraid: failed to create megaraid
root\n");
 	}
 #endif
-	error = pci_module_init(&megaraid_pci_driver);
+	error = pci_register_driver(&megaraid_pci_driver);
 	if (error) {
 #ifdef CONFIG_PROC_FS
 		remove_proc_entry("megaraid", &proc_root);
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
