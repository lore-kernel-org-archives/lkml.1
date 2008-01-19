Return-Path: <linux-kernel-owner+w=401wt.eu-S1764058AbYASBjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764058AbYASBjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 20:39:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760449AbYASBjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 20:39:01 -0500
Received: from ns2.suse.de ([195.135.220.15]:42375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760376AbYASBjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 20:39:00 -0500
Subject: patch driver-core-constify-the-name-passed-to-platform_device_register_simple.patch added to gregkh-2.6 tree
To: sfr@canb.auug.org.au, gregkh@suse.de, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Fri, 18 Jan 2008 17:39:24 -0800
In-Reply-To: <20080111172453.81644f8d.sfr@canb.auug.org.au>
Message-ID: <12007067633743@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: Driver Core: constify the name passed to platform_device_register_simple

to my gregkh-2.6 tree.  Its filename is

     driver-core-constify-the-name-passed-to-platform_device_register_simple.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From sfr@canb.auug.org.au  Fri Jan 18 17:28:36 2008
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 11 Jan 2008 17:24:53 +1100
Subject: Driver Core: constify the name passed to platform_device_register_simple
To: mochel@osdl.org
Cc: greg@kroah.com, LKML <linux-kernel@vger.kernel.org>
Message-ID: <20080111172453.81644f8d.sfr@canb.auug.org.au>


This name is just passed to platform_device_alloc which has its parameter
declared const.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/platform.c         |    2 +-
 include/linux/platform_device.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -360,7 +360,7 @@ EXPORT_SYMBOL_GPL(platform_device_unregi
  *	the Linux driver model.  In particular, when such drivers are built
  *	as modules, they can't be "hotplugged".
  */
-struct platform_device *platform_device_register_simple(char *name, int id,
+struct platform_device *platform_device_register_simple(const char *name, int id,
 							struct resource *res, unsigned int num)
 {
 	struct platform_device *pdev;
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -35,7 +35,7 @@ extern struct resource *platform_get_res
 extern int platform_get_irq_byname(struct platform_device *, char *);
 extern int platform_add_devices(struct platform_device **, int);
 
-extern struct platform_device *platform_device_register_simple(char *, int id,
+extern struct platform_device *platform_device_register_simple(const char *, int id,
 					struct resource *, unsigned int);
 
 extern struct platform_device *platform_device_alloc(const char *name, int id);


Patches currently in gregkh-2.6 which might be from sfr@canb.auug.org.au are

bad/battery-class-driver.patch
driver/driver-core-constify-the-name-passed-to-platform_device_register_simple.patch
