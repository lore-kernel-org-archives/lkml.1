Return-Path: <linux-kernel-owner+w=401wt.eu-S935596AbYBCDMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935596AbYBCDMh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 22:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbYBCDM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 22:12:27 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:20477 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbYBCDM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 22:12:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sFX4UlN4eaEbwE7Pb+YOwzvAadm0W0EdyjM/pX/cRinb7pQVKy7mCNce2efJUF9SdqfUCyjM3n5o7ktvwemIU2+3xbNOnnA/+KkH7KcLK9J5uKwWz8yIQAT0yOU5Bm1tEzAfo1sXKyT4phnZBPs3SVaDOLQ3kx2HUUzcs/Qr80Q=
From: Denis Cheng <crquan@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/block/: add __devinitdata to all pci_device_id table of block drivers
Date: Sun,  3 Feb 2008 11:12:27 +0800
Message-Id: <1202008347-5407-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/block/DAC960.c   |    2 +-
 drivers/block/cciss.c    |    2 +-
 drivers/block/cpqarray.c |    2 +-
 drivers/block/sx8.c      |    2 +-
 drivers/block/umem.c     |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index cd03473..3bdaabc 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -7102,7 +7102,7 @@ static struct DAC960_privdata DAC960_P_privdata = {
 	.MemoryWindowSize =	DAC960_PD_RegisterWindowSize,
 };
 
-static struct pci_device_id DAC960_id_table[] = {
+static struct pci_device_id DAC960_id_table[] __devinitdata = {
 	{
 		.vendor 	= PCI_VENDOR_ID_MYLEX,
 		.device		= PCI_DEVICE_ID_MYLEX_DAC960_GEM,
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 855ce8e..2e19ef4 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -67,7 +67,7 @@ MODULE_LICENSE("GPL");
 #include <linux/cciss_ioctl.h>
 
 /* define the PCI info for the cards we can control */
-static const struct pci_device_id cciss_pci_device_id[] = {
+static const struct pci_device_id cciss_pci_device_id[] __devinitdata = {
 	{PCI_VENDOR_ID_COMPAQ, PCI_DEVICE_ID_COMPAQ_CISS,  0x0E11, 0x4070},
 	{PCI_VENDOR_ID_COMPAQ, PCI_DEVICE_ID_COMPAQ_CISSB, 0x0E11, 0x4080},
 	{PCI_VENDOR_ID_COMPAQ, PCI_DEVICE_ID_COMPAQ_CISSB, 0x0E11, 0x4082},
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 6919918..15204b9 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -96,7 +96,7 @@ static struct board_type products[] = {
 };
 
 /* define the PCI info for the PCI cards this driver can control */
-static const struct pci_device_id cpqarray_pci_device_id[] =
+static const struct pci_device_id cpqarray_pci_device_id[] __devinitdata =
 {
 	{ PCI_VENDOR_ID_DEC, PCI_DEVICE_ID_COMPAQ_42XX,
 		0x0E11, 0x4058, 0, 0, 0},       /* SA431 */
diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index cd5674b..d3e18d7 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -409,7 +409,7 @@ static int carm_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 static void carm_remove_one (struct pci_dev *pdev);
 static int carm_bdev_getgeo(struct block_device *bdev, struct hd_geometry *geo);
 
-static struct pci_device_id carm_pci_tbl[] = {
+static struct pci_device_id carm_pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_ID_PROMISE, 0x8000, PCI_ANY_ID, PCI_ANY_ID, 0, 0, },
 	{ PCI_VENDOR_ID_PROMISE, 0x8002, PCI_ANY_ID, PCI_ANY_ID, 0, 0, },
 	{ }	/* terminate list */
diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index c24e1bd..98846f8 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -1053,7 +1053,7 @@ static void mm_pci_remove(struct pci_dev *dev)
 	pci_disable_device(dev);
 }
 
-static const struct pci_device_id mm_pci_ids[] = {
+static const struct pci_device_id mm_pci_ids[] __devinitdata = {
     {PCI_DEVICE(PCI_VENDOR_ID_MICRO_MEMORY, PCI_DEVICE_ID_MICRO_MEMORY_5415CN)},
     {PCI_DEVICE(PCI_VENDOR_ID_MICRO_MEMORY, PCI_DEVICE_ID_MICRO_MEMORY_5425CN)},
     {PCI_DEVICE(PCI_VENDOR_ID_MICRO_MEMORY, PCI_DEVICE_ID_MICRO_MEMORY_6155)},
-- 
1.5.3.8

