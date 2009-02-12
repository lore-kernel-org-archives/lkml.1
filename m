Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbZBLUai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbZBLUai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 15:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760563AbZBLU26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 15:28:58 -0500
Received: from kroah.org ([198.145.64.141]:58988 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760554AbZBLU25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 15:28:57 -0500
Subject: patch staging-rtl8187se-fix-printk-format-warnings.patch added to gregkh-2.6 tree
To: randy.dunlap@oracle.com, gregkh@suse.de, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 12 Feb 2009 12:25:28 -0800
In-Reply-To: <20090211131935.5d9621e4.randy.dunlap@oracle.com>
Message-ID: <12344703282243@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: rtl8187se: fix printk format warnings

to my gregkh-2.6 tree.  Its filename is

    staging-rtl8187se-fix-printk-format-warnings.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From randy.dunlap@oracle.com  Thu Feb 12 11:53:35 2009
From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Wed, 11 Feb 2009 13:19:35 -0800
Subject: Staging: rtl8187se: fix printk format warnings
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de
Message-ID: <20090211131935.5d9621e4.randy.dunlap@oracle.com>


From: Randy Dunlap <randy.dunlap@oracle.com>

Fix staging/rtl8187se printk format warnings:

drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c:845: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c:852: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
@@ -842,14 +842,14 @@ int ieee80211_wx_set_gen_ie(struct ieee8
 
 	if (len>MAX_WPA_IE_LEN || (len && ie == NULL))
 	{
-		printk("return error out, len:%d\n", len);
+		printk("return error out, len:%zu\n", len);
 	return -EINVAL;
 	}
 
 	if (len)
 	{
 		if (len != ie[1]+2){
-			printk("len:%d, ie:%d\n", len, ie[1]);
+			printk("len:%zu, ie:%d\n", len, ie[1]);
 			return -EINVAL;
 		}
 		buf = kmalloc(len, GFP_KERNEL);


Patches currently in gregkh-2.6 which might be from randy.dunlap@oracle.com are

pending/firmware-add-kconfig-and-makefile-to-build-the-firmware-samples.patch
staging/staging-dst-kconfig-update.patch
staging/staging-dst-fix-build-dependancy.patch
staging/staging-rt2860-fix-printk-format-warnings.patch
staging/staging-rtl8187se-fix-kconfig-dependencies.patch
staging/staging-rtl8187se-fix-printk-format-warnings.patch
staging/staging-stlc45xx-fix-printk-format-warnings.patch
staging/staging-otus-fix-mixed-declarations.patch
staging/staging-android-ram_console-fix-printk-format-warning.patch
staging/staging-android-binder-fix-printk-format-warnings.patch
staging/staging-altera-fix-printk-format-warnings.patch
