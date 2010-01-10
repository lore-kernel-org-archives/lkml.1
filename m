Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601Ab0AJPlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0AJPlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 10:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034Ab0AJPlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 10:41:51 -0500
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:55337 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab0AJPlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 10:41:50 -0500
X-Authuid: nmarci
Message-ID: <4B49F535.6080108@freemail.hu>
Date: Sun, 10 Jan 2010 16:41:41 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] block: make PCI device id constant
References: <20100110141106.GA4293@x200>
In-Reply-To: <20100110141106.GA4293@x200>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02d.mail.t-online.hu 32711; Body=2 Fuz1=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Use DEFINE_PCI_DEVICE_TABLE() when declaring the PCI device
table as suggested in Documentation/PCI/pci.txt .

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- drivers/block/DAC960.c.orig	2010-01-10 16:12:25.000000000 +0100
+++ drivers/block/DAC960.c	2010-01-10 16:16:26.000000000 +0100
@@ -7134,7 +7134,7 @@
 	.MemoryWindowSize =	DAC960_PD_RegisterWindowSize,
 };

-static struct pci_device_id DAC960_id_table[] = {
+static DEFINE_PCI_DEVICE_TABLE(DAC960_id_table) = {
 	{
 		.vendor 	= PCI_VENDOR_ID_MYLEX,
 		.device		= PCI_DEVICE_ID_MYLEX_DAC960_GEM,
--- drivers/block/sx8.c.orig	2010-01-10 16:12:38.000000000 +0100
+++ drivers/block/sx8.c	2010-01-10 16:17:57.000000000 +0100
@@ -409,7 +409,7 @@
 static void carm_remove_one (struct pci_dev *pdev);
 static int carm_bdev_getgeo(struct block_device *bdev, struct hd_geometry *geo);

-static struct pci_device_id carm_pci_tbl[] = {
+static DEFINE_PCI_DEVICE_TABLE(carm_pci_tbl) = {
 	{ PCI_VENDOR_ID_PROMISE, 0x8000, PCI_ANY_ID, PCI_ANY_ID, 0, 0, },
 	{ PCI_VENDOR_ID_PROMISE, 0x8002, PCI_ANY_ID, PCI_ANY_ID, 0, 0, },
 	{ }	/* terminate list */
