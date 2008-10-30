Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbYJ3Fgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbYJ3Fgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 01:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbYJ3FgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 01:36:14 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:34758 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbYJ3FgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 01:36:12 -0400
Date: Wed, 29 Oct 2008 22:35:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-pci@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       jbarnes@virtuousgeek.org
Subject: [PATCH 6/7] PCI: remove excess kernel-doc notation
Message-Id: <20081029223512.401bd1e6.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix pci/rom.c kernel-doc function notation:

Warning(drivers/pci/rom.c:110): Excess function parameter or struct member 'return' description in 'pci_map_rom'
Warning(drivers/pci/rom.c:177): Excess function parameter or struct member 'return' description in 'pci_map_rom_copy'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/pci/rom.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- lin2628-rc2.orig/drivers/pci/rom.c
+++ lin2628-rc2/drivers/pci/rom.c
@@ -100,7 +100,8 @@ size_t pci_get_rom_size(void __iomem *ro
  * pci_map_rom - map a PCI ROM to kernel space
  * @pdev: pointer to pci device struct
  * @size: pointer to receive size of pci window over ROM
- * @return: kernel virtual pointer to image of ROM
+ *
+ * Return: kernel virtual pointer to image of ROM
  *
  * Map a PCI ROM into kernel space. If ROM is boot video ROM,
  * the shadow BIOS copy will be returned instead of the
@@ -167,7 +168,8 @@ void __iomem *pci_map_rom(struct pci_dev
  * pci_map_rom_copy - map a PCI ROM to kernel space, create a copy
  * @pdev: pointer to pci device struct
  * @size: pointer to receive size of pci window over ROM
- * @return: kernel virtual pointer to image of ROM
+ *
+ * Return: kernel virtual pointer to image of ROM
  *
  * Map a PCI ROM into kernel space. If ROM is boot video ROM,
  * the shadow BIOS copy will be returned instead of the
