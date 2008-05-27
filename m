Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbYE0Bw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbYE0Bw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 21:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbYE0Bwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 21:52:47 -0400
Received: from fugue.toroid.org ([85.10.196.113]:59059 "EHLO fugue.toroid.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbYE0Bwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 21:52:46 -0400
Date: Tue, 27 May 2008 07:22:43 +0530
From: Abhijit Menon-Sen <ams@toroid.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Krogh <jesper@krogh.cc>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.26-rc4
Message-ID: <20080527015243.GA19756@toroid.org>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <483B2A9B.4050007@krogh.cc> <alpine.LFD.1.10.0805261428140.2958@woody.linux-foundation.org> <483B60DB.7020402@gmx.net> <483B6287.2000202@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483B6287.2000202@gmx.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 2008-05-27 03:23:19 +0200, c-d.hailfinger.devel.2006@gmx.net wrote:
>
> The change is
> Signed-off-by: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
> in case someone makes a patch from it.

Here you go.

-- ams

diff --git a/drivers/mtd/maps/ck804xrom.c b/drivers/mtd/maps/ck804xrom.c
index 59d8fb4..effaf7c 100644
--- a/drivers/mtd/maps/ck804xrom.c
+++ b/drivers/mtd/maps/ck804xrom.c
@@ -331,15 +331,15 @@ static void __devexit ck804xrom_remove_one (struct pci_dev *pdev)
 }
 
 static struct pci_device_id ck804xrom_pci_tbl[] = {
-	{ PCI_VENDOR_ID_NVIDIA, 0x0051, PCI_ANY_ID, PCI_ANY_ID, DEV_CK804 },
-	{ PCI_VENDOR_ID_NVIDIA, 0x0360, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
-	{ PCI_VENDOR_ID_NVIDIA, 0x0361, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
-	{ PCI_VENDOR_ID_NVIDIA, 0x0362, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
-	{ PCI_VENDOR_ID_NVIDIA, 0x0363, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
-	{ PCI_VENDOR_ID_NVIDIA, 0x0364, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
-	{ PCI_VENDOR_ID_NVIDIA, 0x0365, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
-	{ PCI_VENDOR_ID_NVIDIA, 0x0366, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
-	{ PCI_VENDOR_ID_NVIDIA, 0x0367, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0051), .driver_data = DEV_CK804 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0360), .driver_data = DEV_MCP55 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0361), .driver_data = DEV_MCP55 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0362), .driver_data = DEV_MCP55 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0363), .driver_data = DEV_MCP55 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0364), .driver_data = DEV_MCP55 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0365), .driver_data = DEV_MCP55 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0366), .driver_data = DEV_MCP55 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0367), .driver_data = DEV_MCP55 },
 	{ 0, }
 };
 
