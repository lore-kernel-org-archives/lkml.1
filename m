Return-Path: <linux-kernel-owner+w=401wt.eu-S1761493AbXK1Orq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761493AbXK1Orq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 09:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbXK1Ori
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 09:47:38 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46340 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbXK1Orh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 09:47:37 -0500
Date: Wed, 28 Nov 2007 15:47:28 +0100
From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue@bull.net>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, <ebiederm@xmission.com>,
       Michael Chan <mchan@broadcom.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>
Subject: [PATCH -mm] remove HT1000 from the quirk_msi_ht_cap quirk
Message-ID: <20071128154728.109664a2@bull.net>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 28/11/2007 15:54:57,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 28/11/2007 15:54:58,
	Serialize complete at 28/11/2007 15:54:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Andrew, due to mailer problems, I'm not sure you received my previous mail
titled: "[PATCH] V2 -  quirk: Enable MSI Mapping on HT1000" if you did,
then forget it and use this one instead. Or if you already merged V2 then
drop this one.

Sorry for the inconvenience.

  Sebastien.


From: Sebastien Dugue <sebastien.dugue@bull.net>

  Now that the HyperTransport MSI mapping capability is enabled for Broadcom's
HT1000 bridge, the quirk_msi_ht_cap quirk is no longer necessary.

Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michael Chan <mchan@broadcom.com>


---
 drivers/pci/quirks.c |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-2.6.24-rc3-mm2/drivers/pci/quirks.c
===================================================================
--- linux-2.6.24-rc3-mm2.orig/drivers/pci/quirks.c
+++ linux-2.6.24-rc3-mm2/drivers/pci/quirks.c
@@ -1711,10 +1711,6 @@ static void __devinit quirk_msi_ht_cap(s
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT2000_PCIE,
 			quirk_msi_ht_cap);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS,
-			PCI_DEVICE_ID_SERVERWORKS_HT1000_PXB,
-			quirk_msi_ht_cap);
-
 
 /*
  *  Force enable MSI mapping capability on HT bridges
