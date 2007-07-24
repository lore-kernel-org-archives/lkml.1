Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756AbXGXEiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbXGXEiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 00:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbXGXEiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 00:38:11 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:17864 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbXGXEiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 00:38:09 -0400
Date: Mon, 23 Jul 2007 21:42:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh <greg@kroah.com>
Subject: [PATCH] kernel-doc fixes for PCI and drivers/base/
Message-Id: <20070723214211.9beda07f.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix undocumented function parameters in PCI and drivers/base.

Warning(linux-2.6.23-rc1//drivers/pci/pci.c:1526): No description found for parameter 'rq'
Warning(linux-2.6.23-rc1//drivers/base/firmware_class.c:245): No description found for parameter 'bin_attr'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/base/firmware_class.c |    1 +
 drivers/pci/pci.c             |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.23-rc1.orig/drivers/base/firmware_class.c
+++ linux-2.6.23-rc1/drivers/base/firmware_class.c
@@ -232,6 +232,7 @@ fw_realloc_buffer(struct firmware_priv *
 /**
  * firmware_data_write - write method for firmware
  * @kobj: kobject for the device
+ * @bin_attr: bin_attr structure
  * @buffer: buffer being written
  * @offset: buffer offset for write in total data store area
  * @count: buffer size
--- linux-2.6.23-rc1.orig/drivers/pci/pci.c
+++ linux-2.6.23-rc1/drivers/pci/pci.c
@@ -1517,7 +1517,7 @@ EXPORT_SYMBOL(pcie_get_readrq);
 /**
  * pcie_set_readrq - set PCI Express maximum memory read request
  * @dev: PCI device to query
- * @count: maximum memory read count in bytes
+ * @rq: maximum memory read count in bytes
  *    valid values are 128, 256, 512, 1024, 2048, 4096
  *
  * If possible sets maximum read byte count
