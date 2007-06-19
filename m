Return-Path: <linux-kernel-owner+w=401wt.eu-S1763096AbXFSSs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763096AbXFSSs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762758AbXFSSsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:48:52 -0400
Received: from palrel12.hp.com ([156.153.255.237]:58621 "EHLO palrel12.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761204AbXFSSsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:48:51 -0400
Date: Tue, 19 Jun 2007 13:48:50 -0500
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
To: jens.axboe@oracle.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 1/1] cciss: add new controller support for P700m
Message-ID: <20070619184850.GA16417@beardog.cca.cpqcorp.net>
Reply-To: mike.miller@hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PATCH 1/1

This patch adds support for the Smart Array P700m SAS controller. This new
controller will ship Fall 2008. Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>

--------------------------------------------------------------------------------
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 5acc6c4..0fcad43 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -87,6 +87,7 @@ static const struct pci_device_id cciss_
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3214},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3215},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3237},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x323D},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
@@ -119,6 +120,7 @@ static struct board_type products[] = {
 	{0x3214103C, "Smart Array E200i", &SA5_access, 120},
 	{0x3215103C, "Smart Array E200i", &SA5_access, 120},
 	{0x3237103C, "Smart Array E500", &SA5_access, 512},
+	{0x323D103C, "Smart Array P700m", &SA5_access, 512},
 	{0xFFFF103C, "Unknown Smart Array", &SA5_access, 120},
 };
 
