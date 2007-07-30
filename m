Return-Path: <linux-kernel-owner+w=401wt.eu-S968413AbXG3TM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968413AbXG3TM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968354AbXG3TMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:12:49 -0400
Received: from mail.suse.de ([195.135.220.2]:54926 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968355AbXG3TMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:12:48 -0400
Subject: patch kernel-doc-fixes-for-pci-and-drivers-base.patch added to gregkh-2.6 tree
To: randy.dunlap@oracle.com, greg@kroah.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Mon, 30 Jul 2007 12:12:37 -0700
In-Reply-To: <20070723214211.9beda07f.randy.dunlap@oracle.com>
Message-Id: <20070730191245.4540314458DB@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: kernel-doc fixes for PCI and drivers/base/

to my gregkh-2.6 tree.  Its filename is

     kernel-doc-fixes-for-pci-and-drivers-base.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From randy.dunlap@oracle.com Mon Jul 23 21:38:12 2007
From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Mon, 23 Jul 2007 21:42:11 -0700
Subject: kernel-doc fixes for PCI and drivers/base/
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh <greg@kroah.com>
Message-ID: <20070723214211.9beda07f.randy.dunlap@oracle.com>


From: Randy Dunlap <randy.dunlap@oracle.com>

Fix undocumented function parameters in PCI and drivers/base.

Warning(linux-2.6.23-rc1//drivers/pci/pci.c:1526): No description found for parameter 'rq'
Warning(linux-2.6.23-rc1//drivers/base/firmware_class.c:245): No description found for parameter 'bin_attr'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/firmware_class.c |    1 +
 drivers/pci/pci.c             |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -232,6 +232,7 @@ fw_realloc_buffer(struct firmware_priv *
 /**
  * firmware_data_write - write method for firmware
  * @kobj: kobject for the device
+ * @bin_attr: bin_attr structure
  * @buffer: buffer being written
  * @offset: buffer offset for write in total data store area
  * @count: buffer size
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


Patches currently in gregkh-2.6 which might be from randy.dunlap@oracle.com are

driver/fix-doc-sysfs-rules-typos.patch
driver/kernel-doc-fixes-for-pci-and-drivers-base.patch
driver/kset-kernel-doc-cleanups.patch
pci/pci-document-pci_iomap.patch
usb/usb-usb.h-kernel-doc-additions.patch
