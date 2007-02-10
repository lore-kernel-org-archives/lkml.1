Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbXBJWpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbXBJWpp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 17:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbXBJWpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 17:45:45 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:43578 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbXBJWpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 17:45:44 -0500
Date: Sat, 10 Feb 2007 14:41:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: gregkh@suse.de
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] PCI/sysfs/kobject kernel-doc fixes
Message-Id: <20070210144156.38a5e261.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in PCI, sysfs, and kobject files.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/pci/pci-driver.c |    1 +
 drivers/pci/pci.c        |    2 +-
 fs/sysfs/file.c          |    2 +-
 lib/kobject.c            |    1 +
 4 files changed, 4 insertions(+), 2 deletions(-)

--- linux-2.6.20-git6.orig/drivers/pci/pci-driver.c
+++ linux-2.6.20-git6/drivers/pci/pci-driver.c
@@ -415,6 +415,7 @@ static struct kobj_type pci_driver_kobj_
  * __pci_register_driver - register a new pci driver
  * @drv: the driver structure to register
  * @owner: owner module of drv
+ * @mod_name: module name string
  * 
  * Adds the driver structure to the list of registered drivers.
  * Returns a negative value on error, otherwise 0. 
--- linux-2.6.20-git6.orig/drivers/pci/pci.c
+++ linux-2.6.20-git6/drivers/pci/pci.c
@@ -1300,7 +1300,7 @@ pci_set_consistent_dma_mask(struct pci_d
 
 /**
  * pci_select_bars - Make BAR mask from the type of resource
- * @pdev: the PCI device for which BAR mask is made
+ * @dev: the PCI device for which BAR mask is made
  * @flags: resource type mask to be selected
  *
  * This helper routine makes bar mask from the type of resource.
--- linux-2.6.20-git6.orig/fs/sysfs/file.c
+++ linux-2.6.20-git6/fs/sysfs/file.c
@@ -54,7 +54,7 @@ static struct sysfs_ops subsys_sysfs_ops
 /**
  *	add_to_collection - add buffer to a collection
  *	@buffer:	buffer to be added
- *	@node		inode of set to add to
+ *	@node:		inode of set to add to
  */
 
 static inline void
--- linux-2.6.20-git6.orig/lib/kobject.c
+++ linux-2.6.20-git6/lib/kobject.c
@@ -325,6 +325,7 @@ int kobject_rename(struct kobject * kobj
 /**
  *	kobject_rename - change the name of an object
  *	@kobj:	object in question.
+ *	@new_parent: object's new parent
  *	@new_name: object's new name
  */
 
