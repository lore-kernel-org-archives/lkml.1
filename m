Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbZBLDfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbZBLDfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 22:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756629AbZBLDfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 22:35:23 -0500
Received: from smtp104.biz.mail.mud.yahoo.com ([68.142.200.252]:42856 "HELO
	smtp104.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751434AbZBLDfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 22:35:22 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Feb 2009 22:35:22 EST
X-Yahoo-Newman-Property: ymail-3
From: HighPoint Linux Team <linux@highpoint-tech.com>
Organization: HighPoint Technologies, Inc.
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH][SCSI] hptiop: Add new PCI device ID
Date: Thu, 12 Feb 2009 11:28:31 +0800
User-Agent: KMail/1.5.3
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902121128.31303.linux@highpoint-tech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new PCI device ID.

Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
---

 hptiop.c |    1 +
 1 file changed, 1 insertion(+)

diff -purN linux-2.6.28-rc2-mm1/drivers/scsi/hptiop.c new/drivers/scsi/hptiop.c
--- linux-2.6.28-rc2-mm1/drivers/scsi/hptiop.c	2008-12-25 07:26:37.000000000 +0800
+++ new/drivers/scsi/hptiop.c	2009-02-12 11:14:56.000000000 +0800
@@ -1251,6 +1251,7 @@ static struct pci_device_id hptiop_id_ta
 	{ PCI_VDEVICE(TTI, 0x3530), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3560), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4322), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4321), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4210), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4211), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4310), (kernel_ulong_t)&hptiop_itl_ops },

