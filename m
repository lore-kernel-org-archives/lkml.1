Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbYCAGFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbYCAGFL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 01:05:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbYCAGEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 01:04:39 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:32114 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbYCAGEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 01:04:37 -0500
Date: Fri, 29 Feb 2008 22:03:15 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5/6] docbook: fix kernel-api source files
Message-Id: <20080229220315.d51003be.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
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

Fix docbook problems in kernel-api.tmpl.
These cause the generated docbook to be incorrect.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/base/transport_class.c |    4 +---
 drivers/pci/rom.c              |    3 +--
 mm/truncate.c                  |    3 +--
 3 files changed, 3 insertions(+), 7 deletions(-)

--- lin2625-rc3g2-kdoc.orig/drivers/base/transport_class.c
+++ lin2625-rc3g2-kdoc/drivers/base/transport_class.c
@@ -126,9 +126,7 @@ static int transport_setup_classdev(stru
 }
 
 /**
- * transport_setup_device - declare a new dev for transport class association
- *			    but don't make it visible yet.
- *
+ * transport_setup_device - declare a new dev for transport class association but don't make it visible yet.
  * @dev: the generic device representing the entity being added
  *
  * Usually, dev represents some component in the HBA system (either
--- lin2625-rc3g2-kdoc.orig/drivers/pci/rom.c
+++ lin2625-rc3g2-kdoc/drivers/pci/rom.c
@@ -242,8 +242,7 @@ void pci_remove_rom(struct pci_dev *pdev
 #endif  /*  0  */
 
 /**
- * pci_cleanup_rom - internal routine for freeing the ROM copy created
- * by pci_map_rom_copy called from remove.c
+ * pci_cleanup_rom - free the ROM copy created by pci_map_rom_copy
  * @pdev: pointer to pci device struct
  *
  * Free the copied ROM if we allocated one.
--- lin2625-rc3g2-kdoc.orig/mm/truncate.c
+++ lin2625-rc3g2-kdoc/mm/truncate.c
@@ -134,8 +134,7 @@ invalidate_complete_page(struct address_
 }
 
 /**
- * truncate_inode_pages - truncate range of pages specified by start and
- * end byte offsets
+ * truncate_inode_pages - truncate range of pages specified by start & end byte offsets
  * @mapping: mapping to truncate
  * @lstart: offset from which to truncate
  * @lend: offset to which to truncate
