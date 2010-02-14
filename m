Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364Ab0BNOS6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 09:18:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49847 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926Ab0BNOS5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 09:18:57 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1266157055.10567.13.camel@localhost>
References: <1266157055.10567.13.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 14 Feb 2010 14:18:53 +0000
Message-ID: <1266157133.10567.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 2/5] drivers/base: Fix first line of kernel-doc for a few
 functions
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function name must be followed by a space, hypen, space, and a
short description.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/base/firmware_class.c |    2 +-
 drivers/base/platform.c       |   16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 0797748..d0dc26a 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -613,7 +613,7 @@ request_firmware_work_func(void *arg)
 }
 
 /**
- * request_firmware_nowait: asynchronous version of request_firmware
+ * request_firmware_nowait - asynchronous version of request_firmware
  * @module: module requesting the firmware
  * @uevent: sends uevent to copy the firmware image if this flag
  *	is non-zero else the firmware copy must be done manually.
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 575e08b..1ba9d61 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -128,7 +128,7 @@ struct platform_object {
 };
 
 /**
- * platform_device_put
+ * platform_device_put - destroy a platform device
  * @pdev: platform device to free
  *
  * Free all memory associated with a platform device.  This function must
@@ -152,7 +152,7 @@ static void platform_device_release(struct device *dev)
 }
 
 /**
- * platform_device_alloc
+ * platform_device_alloc - create a platform device
  * @name: base name of the device we're adding
  * @id: instance id
  *
@@ -177,7 +177,7 @@ struct platform_device *platform_device_alloc(const char *name, int id)
 EXPORT_SYMBOL_GPL(platform_device_alloc);
 
 /**
- * platform_device_add_resources
+ * platform_device_add_resources - add resources to a platform device
  * @pdev: platform device allocated by platform_device_alloc to add resources to
  * @res: set of resources that needs to be allocated for the device
  * @num: number of resources
@@ -202,7 +202,7 @@ int platform_device_add_resources(struct platform_device *pdev,
 EXPORT_SYMBOL_GPL(platform_device_add_resources);
 
 /**
- * platform_device_add_data
+ * platform_device_add_data - add platform-specific data to a platform device
  * @pdev: platform device allocated by platform_device_alloc to add resources to
  * @data: platform specific data for this platform device
  * @size: size of platform specific data
@@ -344,7 +344,7 @@ void platform_device_unregister(struct platform_device *pdev)
 EXPORT_SYMBOL_GPL(platform_device_unregister);
 
 /**
- * platform_device_register_simple
+ * platform_device_register_simple - add a platform-level device and its resources
  * @name: base name of the device we're adding
  * @id: instance id
  * @res: set of resources that needs to be allocated for the device
@@ -396,7 +396,7 @@ error:
 EXPORT_SYMBOL_GPL(platform_device_register_simple);
 
 /**
- * platform_device_register_data
+ * platform_device_register_data - add a platform-level device with platform-specific data
  * @parent: parent device for the device we're adding
  * @name: base name of the device we're adding
  * @id: instance id
@@ -473,7 +473,7 @@ static void platform_drv_shutdown(struct device *_dev)
 }
 
 /**
- * platform_driver_register
+ * platform_driver_register - register a driver for platform-level devices
  * @drv: platform driver structure
  */
 int platform_driver_register(struct platform_driver *drv)
@@ -491,7 +491,7 @@ int platform_driver_register(struct platform_driver *drv)
 EXPORT_SYMBOL_GPL(platform_driver_register);
 
 /**
- * platform_driver_unregister
+ * platform_driver_unregister - unregister a driver for platform-level devices
  * @drv: platform driver structure
  */
 void platform_driver_unregister(struct platform_driver *drv)
-- 
1.6.6.2



