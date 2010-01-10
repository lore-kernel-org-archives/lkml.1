Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739Ab0AJREy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab0AJREy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 12:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557Ab0AJREx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 12:04:53 -0500
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:60503 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab0AJREw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 12:04:52 -0500
X-Authuid: nmarci
Message-ID: <4B4A089F.3090908@freemail.hu>
Date: Sun, 10 Jan 2010 18:04:31 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: linux-fbdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] video skeletonfb: use DEFINE_PCI_DEVICE_TABLE()
Content-Type: text/plain; charset=UTF-8
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
--- linux/drivers/video/skeletonfb.c.orig	2009-12-03 04:51:21.000000000 +0100
+++ linux/drivers/video/skeletonfb.c	2010-01-10 17:59:55.000000000 +0100
@@ -887,7 +887,7 @@ static int xxxfb_resume(struct pci_dev *
 #define xxxfb_resume NULL
 #endif /* CONFIG_PM */

-static struct pci_device_id xxxfb_id_table[] = {
+static DEFINE_PCI_DEVICE_TABLE(xxxfb_id_table) = {
 	{ PCI_VENDOR_ID_XXX, PCI_DEVICE_ID_XXX,
 	  PCI_ANY_ID, PCI_ANY_ID, PCI_BASE_CLASS_DISPLAY << 16,
 	  PCI_CLASS_MASK, 0 },
