Return-Path: <linux-kernel-owner+w=401wt.eu-S1759968AbYKVRlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968AbYKVRlU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759426AbYKVRhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:37:07 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58487 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759248AbYKVRhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:37:05 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 23/32] alpha: pcibios_resource_to_bus() is callable from normal code
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L3wPo-0006aV-Ln@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:37:04 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


pci_enable_rom(), specifically.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/alpha/kernel/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/kernel/pci.c b/arch/alpha/kernel/pci.c
--- a/arch/alpha/kernel/pci.c
+++ b/arch/alpha/kernel/pci.c
@@ -338,7 +338,7 @@ common_swizzle(struct pci_dev *dev, u8 *pinp)
 	return PCI_SLOT(dev->devfn);
 }
 
-void __devinit
+void
 pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
 			 struct resource *res)
 {
