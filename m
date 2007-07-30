Return-Path: <linux-kernel-owner+w=401wt.eu-S969433AbXG3WM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969433AbXG3WM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969272AbXG3WKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:10:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969249AbXG3WKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:10:37 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/11] kernel-doc fixes for PCI and drivers/base/
Date: Mon, 30 Jul 2007 15:09:27 -0700
Message-Id: <11858333892232-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11858333853388-git-send-email-gregkh@suse.de>
References: <20070730220829.GB5263@kroah.com>
 <1185833373286-git-send-email-gregkh@suse.de>
 <11858333772499-git-send-email-gregkh@suse.de>
 <11858333823900-git-send-email-gregkh@suse.de>
 <11858333853388-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix undocumented function parameters in PCI and drivers/base.

Warning(linux-2.6.23-rc1//drivers/pci/pci.c:1526): No description found for parameter 'rq'
Warning(linux-2.6.23-rc1//drivers/base/firmware_class.c:245): No description found for parameter 'bin_attr'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware_class.c |    1 +
 drivers/pci/pci.c             |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 53f0ee6..b24efd4 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -232,6 +232,7 @@ fw_realloc_buffer(struct firmware_priv *fw_priv, int min_size)
 /**
  * firmware_data_write - write method for firmware
  * @kobj: kobject for the device
+ * @bin_attr: bin_attr structure
  * @buffer: buffer being written
  * @offset: buffer offset for write in total data store area
  * @count: buffer size
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index fba319d..1ee9cd9 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1517,7 +1517,7 @@ EXPORT_SYMBOL(pcie_get_readrq);
 /**
  * pcie_set_readrq - set PCI Express maximum memory read request
  * @dev: PCI device to query
- * @count: maximum memory read count in bytes
+ * @rq: maximum memory read count in bytes
  *    valid values are 128, 256, 512, 1024, 2048, 4096
  *
  * If possible sets maximum read byte count
-- 
1.5.2.2

