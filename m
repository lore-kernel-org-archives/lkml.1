Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbYBCXGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbYBCXGy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 18:06:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755072AbYBCXGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 18:06:19 -0500
Received: from xenotime.net ([66.160.160.81]:37418 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755052AbYBCXGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 18:06:18 -0500
Date: Sun, 3 Feb 2008 15:06:16 -0800 (PST)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-kernel@vger.kernel.org
cc: greg@kroah.com, akpm@linux-foundation.org
Subject: [PATCH 4/8] kernel-doc: fix drivers/base/ warnings
Message-ID: <Pine.LNX.4.64.0802031442520.3021@shark.he.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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

--- linux-2.6.24-git12.orig/drivers/base/driver.c
+++ linux-2.6.24-git12/drivers/base/driver.c
@@ -123,6 +123,9 @@ EXPORT_SYMBOL_GPL(driver_remove_file);

  /**
   * driver_add_kobj - add a kobject below the specified driver
+ * @drv: requesting device driver
+ * @kobj: kobject to add below this driver
+ * @fmt: format string that names the kobject
   *
   * You really don't want to do this, this is only here due to one looney
   * iseries driver, go poke those developers if you are annoyed about
--- linux-2.6.24-git12.orig/drivers/base/power/main.c
+++ linux-2.6.24-git12/drivers/base/power/main.c
@@ -522,6 +522,7 @@ static void lock_all_devices(void)

  /**
   *	device_suspend - Save state and stop all devices in system.
+ *	@state: new power management state
   *
   *	Prevent new devices from being registered, then lock all devices
   *	and suspend them.
