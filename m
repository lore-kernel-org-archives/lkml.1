Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbXEUO3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbXEUO3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 10:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbXEUO3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 10:29:17 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48270 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755326AbXEUO3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 10:29:16 -0400
Date: Mon, 21 May 2007 15:33:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pci_find_slot: Mark deprecated
Message-ID: <20070521153321.10c8dd35@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We've now fixed up most users of pci_find_slot, and the remainder are
either hard and need someone with the hardware and info to work on it, or
patches exist but are not yet merged.

Time therefore for some gentle encouragement

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/linux/pci.h linux-2.6.22-rc1-mm1/include/linux/pci.h
--- linux.vanilla-2.6.22-rc1-mm1/include/linux/pci.h	2007-05-18 16:22:56.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/linux/pci.h	2007-05-18 16:38:24.000000000 +0100
@@ -478,7 +478,7 @@
 /* Generic PCI functions exported to card drivers */
 
 struct pci_dev __deprecated *pci_find_device (unsigned int vendor, unsigned int device, const struct pci_dev *from);
-struct pci_dev *pci_find_slot (unsigned int bus, unsigned int devfn);
+struct pci_dev __deprecated *pci_find_slot (unsigned int bus, unsigned int devfn);
 int pci_find_capability (struct pci_dev *dev, int cap);
 int pci_find_next_capability (struct pci_dev *dev, u8 pos, int cap);
 int pci_find_ext_capability (struct pci_dev *dev, int cap);
