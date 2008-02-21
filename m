Return-Path: <linux-kernel-owner+w=401wt.eu-S934746AbYBUXuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934746AbYBUXuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935869AbYBUXsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:48:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935862AbYBUXs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:48:27 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/11] driver-core: fix kernel-doc function parameters
Date: Thu, 21 Feb 2008 15:48:00 -0800
Message-Id: <1203637687-7273-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080221234649.GB7128@kroah.com>
References: <20080221234649.GB7128@kroah.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/driver.c     |    3 +++
 drivers/base/power/main.c |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index ba75184..bf31a01 100644
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
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index bdc03f7..d609560 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -523,6 +523,7 @@ static void lock_all_devices(void)
 
 /**
  *	device_suspend - Save state and stop all devices in system.
+ *	@state: new power management state
  *
  *	Prevent new devices from being registered, then lock all devices
  *	and suspend them.
-- 
1.5.4

