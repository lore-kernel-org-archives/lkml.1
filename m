Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbYBSXFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbYBSXFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756441AbYBSXF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:05:29 -0500
Received: from ns1.suse.de ([195.135.220.2]:60422 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755972AbYBSXF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:05:28 -0500
Subject: patch driver-core-fix-kernel-doc-function-parameters.patch added to gregkh-2.6 tree
To: randy.dunlap@oracle.com, greg@kroah.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Tue, 19 Feb 2008 15:03:08 -0800
In-Reply-To: <20080218130903.ae375db8.randy.dunlap@oracle.com>
Message-ID: <12034621882137@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: [PATCH] driver-core: fix kernel-doc function parameters

to my gregkh-2.6 tree.  Its filename is

     driver-core-fix-kernel-doc-function-parameters.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From randy.dunlap@oracle.com Mon Feb 18 13:09:55 2008
From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Mon, 18 Feb 2008 13:09:03 -0800
Subject: [PATCH] driver-core: fix kernel-doc function parameters
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh <greg@kroah.com>
Message-ID: <20080218130903.ae375db8.randy.dunlap@oracle.com>


From: Randy Dunlap <randy.dunlap@oracle.com>

Fix drivers/base/ missing kernel-doc parameters:
Warning(linux-2.6.24-git12//drivers/base/driver.c:133): No description found for parameter 'drv'
Warning(linux-2.6.24-git12//drivers/base/driver.c:133): No description found for parameter 'kobj'
Warning(linux-2.6.24-git12//drivers/base/driver.c:133): No description found for parameter 'fmt'
Warning(linux-2.6.24-git12//drivers/base/power/main.c:530): No description found for parameter 'state'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/driver.c     |    3 +++
 drivers/base/power/main.c |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -120,6 +120,9 @@ EXPORT_SYMBOL_GPL(driver_remove_file);
 
 /**
  * driver_add_kobj - add a kobject below the specified driver
+ * @drv: requesting device driver
+ * @kobj: kobject to add below this driver
+ * @fmt: format string that names the kobject
  *
  * You really don't want to do this, this is only here due to one looney
  * iseries driver, go poke those developers if you are annoyed about
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -523,6 +523,7 @@ static void lock_all_devices(void)
 
 /**
  *	device_suspend - Save state and stop all devices in system.
+ *	@state: new power management state
  *
  *	Prevent new devices from being registered, then lock all devices
  *	and suspend them.


Patches currently in gregkh-2.6 which might be from randy.dunlap@oracle.com are

driver/driver-core-fix-kernel-doc-function-parameters.patch
pci/pci-kernel-doc-fix-pci-acpi-warning.patch
usb/usb-convert-usb.h-struct-usb_device-to-kernel-doc.patch
