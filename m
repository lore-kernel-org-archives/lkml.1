Return-Path: <linux-kernel-owner+w=401wt.eu-S1751957AbZIXNQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbZIXNQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 09:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbZIXNQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 09:16:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:56170 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbZIXNQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 09:16:49 -0400
Subject: [PATCH] PCI: fix htmldocs pci.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Tiago Vignatti <tiago.vignatti@nokia.com>,
       Dave Airlie <airlied@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       linux-pci <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 18:45:47 +0530
Message-Id: <1253798147.10654.3.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the following htmldocs warnings:

  Warning(drivers/pci/pci.c:2552): No description found for parameter 'dev'
  Warning(drivers/pci/pci.c:2552): No description found for parameter 'decode'
  Warning(drivers/pci/pci.c:2552): No description found for parameter 'command_bits'
  Warning(drivers/pci/pci.c:2552): No description found for parameter 'change_bridge'

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tiago Vignatti <tiago.vignatti@nokia.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/pci/pci.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6edecff..67288ec 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2542,10 +2542,10 @@ int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type *type)
 
 /**
  * pci_set_vga_state - set VGA decode state on device and parents if requested
- * @dev the PCI device
- * @decode - true = enable decoding, false = disable decoding
- * @command_bits PCI_COMMAND_IO and/or PCI_COMMAND_MEMORY
- * @change_bridge - traverse ancestors and change bridges
+ * @dev: the PCI device
+ * @decode: true = enable decoding, false = disable decoding
+ * @command_bits: PCI_COMMAND_IO and/or PCI_COMMAND_MEMORY
+ * @change_bridge: traverse ancestors and change bridges
  */
 int pci_set_vga_state(struct pci_dev *dev, bool decode,
 		      unsigned int command_bits, bool change_bridge)
-- 
1.6.0.6


