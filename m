Return-Path: <linux-kernel-owner+w=401wt.eu-S1762062AbYBRVJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762062AbYBRVJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbYBRVJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:09:49 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:12085 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbYBRVJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:09:48 -0500
Date: Mon, 18 Feb 2008 13:09:03 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh <greg@kroah.com>
Subject: [PATCH] driver-core: fix kernel-doc function parameters
Message-Id: <20080218130903.ae375db8.randy.dunlap@oracle.com>
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

Fix drivers/base/ missing kernel-doc parameters:
Warning(linux-2.6.24-git12//drivers/base/driver.c:133): No description found for parameter 'drv'
Warning(linux-2.6.24-git12//drivers/base/driver.c:133): No description found for parameter 'kobj'
Warning(linux-2.6.24-git12//drivers/base/driver.c:133): No description found for parameter 'fmt'
Warning(linux-2.6.24-git12//drivers/base/power/main.c:530): No description found for parameter 'state'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/base/driver.c     |    3 +++
 drivers/base/power/main.c |    1 +
 2 files changed, 4 insertions(+)

--- linux-2.6.25-rc1-git4.orig/drivers/base/driver.c
+++ linux-2.6.25-rc1-git4/drivers/base/driver.c
@@ -120,6 +120,9 @@ EXPORT_SYMBOL_GPL(driver_remove_file);
 
 /**
  * driver_add_kobj - add a kobject below the specified driver
+ * @drv: requesting device driver
+ * @kobj: kobject to add below this driver
+ * @fmt: format string that names the kobject
  *
  * You really don't want to do this, this is only here due to one looney
  * iseries driver, go poke those developers if you are annoyed about
--- linux-2.6.25-rc1-git4.orig/drivers/base/power/main.c
+++ linux-2.6.25-rc1-git4/drivers/base/power/main.c
@@ -523,6 +523,7 @@ static void lock_all_devices(void)
 
 /**
  *	device_suspend - Save state and stop all devices in system.
+ *	@state: new power management state
  *
  *	Prevent new devices from being registered, then lock all devices
  *	and suspend them.
