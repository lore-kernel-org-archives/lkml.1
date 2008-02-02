Return-Path: <linux-kernel-owner+w=401wt.eu-S934467AbYBBVAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934467AbYBBVAK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 16:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756400AbYBBU76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:59:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:48861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992AbYBBU74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:59:56 -0500
Subject: patch driver-core-update-some-prototypes-in-platform.txt.patch added to gregkh-2.6 tree
To: sfr@canb.auug.org.au, gregkh@suse.de, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Sat, 02 Feb 2008 12:57:43 -0800
In-Reply-To: <20080202221507.fd916a3b.sfr@canb.auug.org.au>
Message-ID: <1201985862276@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: Driver core: Update some prototypes in platform.txt

to my gregkh-2.6 tree.  Its filename is

     driver-core-update-some-prototypes-in-platform.txt.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From sfr@canb.auug.org.au  Sat Feb  2 12:50:36 2008
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Sat, 2 Feb 2008 22:15:07 +1100
Subject: Driver core: Update some prototypes in platform.txt
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-ID: <20080202221507.fd916a3b.sfr@canb.auug.org.au>


Just make these match the actual code.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/driver-model/platform.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/driver-model/platform.txt
+++ b/Documentation/driver-model/platform.txt
@@ -122,15 +122,15 @@ None the less, there are some APIs to su
 using these calls except with such hotplug-deficient drivers.
 
 	struct platform_device *platform_device_alloc(
-			char *name, unsigned id);
+			const char *name, int id);
 
 You can use platform_device_alloc() to dynamically allocate a device, which
 you will then initialize with resources and platform_device_register().
 A better solution is usually:
 
 	struct platform_device *platform_device_register_simple(
-			char *name, unsigned id,
-			struct resource *res, unsigned nres);
+			const char *name, int id,
+			struct resource *res, unsigned int nres);
 
 You can use platform_device_register_simple() as a one-step call to allocate
 and register a device.


Patches currently in gregkh-2.6 which might be from sfr@canb.auug.org.au are

bad/battery-class-driver.patch
driver/ppc-fix-powerpc-vio_find_name-to-not-use-devices_subsys.patch
driver/driver-core-update-some-prototypes-in-platform.txt.patch
