Return-Path: <linux-kernel-owner+w=401wt.eu-S1758147AbZHQVYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbZHQVYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 17:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbZHQVYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 17:24:42 -0400
Received: from kroah.org ([198.145.64.141]:49057 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbZHQVYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 17:24:41 -0400
Subject: patch staging-dream-separate-kconfig-makefile-into-subdirectory.patch added to gregkh-2.6 tree
To: pavel@ucw.cz, gregkh@suse.de, greg@kroah.com, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Mon, 17 Aug 2009 14:23:12 -0700
In-Reply-To: <20090808122701.GD11163@elf.ucw.cz>
Message-ID: <1250544192149@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: Dream: separate Kconfig/Makefile into subdirectory

to my gregkh-2.6 tree.  Its filename is

    staging-dream-separate-kconfig-makefile-into-subdirectory.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From pavel@ucw.cz  Mon Aug 17 13:03:17 2009
From: Pavel Machek <pavel@ucw.cz>
Date: Sat, 8 Aug 2009 14:27:02 +0200
Subject: Staging: Dream: separate Kconfig/Makefile into subdirectory
To: Greg KH <greg@kroah.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Message-ID: <20090808122701.GD11163@elf.ucw.cz>
Content-Disposition: inline

Separate Kconfig/Makefile glue from dream into subdirectory. I plan to
add few more drivers, and changing staging/Makefile each time sounds
like inviting conflicts.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/Kconfig  |    6 ++----
 drivers/staging/Makefile |    3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -99,6 +99,8 @@ source "drivers/staging/epl/Kconfig"
 
 source "drivers/staging/android/Kconfig"
 
+source "drivers/staging/dream/Kconfig"
+
 source "drivers/staging/dst/Kconfig"
 
 source "drivers/staging/pohmelfs/Kconfig"
@@ -131,10 +133,6 @@ source "drivers/staging/cpc-usb/Kconfig"
 
 source "drivers/staging/pata_rdc/Kconfig"
 
-source "drivers/staging/dream/smd/Kconfig"
-
-source "drivers/staging/dream/camera/Kconfig"
-
 source "drivers/staging/udlfb/Kconfig"
 
 source "drivers/staging/hv/Kconfig"
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_INPUT_MIMIO)	+= mimio/
 obj-$(CONFIG_TRANZPORT)		+= frontier/
 obj-$(CONFIG_EPL)		+= epl/
 obj-$(CONFIG_ANDROID)		+= android/
+obj-$(CONFIG_ANDROID)		+= dream/
 obj-$(CONFIG_DST)		+= dst/
 obj-$(CONFIG_POHMELFS)		+= pohmelfs/
 obj-$(CONFIG_STLC45XX)		+= stlc45xx/
@@ -48,6 +49,4 @@ obj-$(CONFIG_VT6656)		+= vt6656/
 obj-$(CONFIG_USB_CPC)		+= cpc-usb/
 obj-$(CONFIG_RDC_17F3101X)	+= pata_rdc/
 obj-$(CONFIG_FB_UDL)		+= udlfb/
-obj-$(CONFIG_MSM_ADSP)		+= dream/qdsp5/ dream/smd/
-obj-$(CONFIG_MSM_CAMERA)	+= dream/camera/
 obj-$(CONFIG_HYPERV)		+= hv/

