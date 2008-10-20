Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbYJTXnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbYJTXnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYJTXmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:42:54 -0400
Received: from kroah.org ([198.145.64.141]:39238 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751209AbYJTXmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:42:54 -0400
Subject: patch staging-remove-remaining-uses-of-__function__.patch added to gregkh-2.6 tree
To: harvey.harrison@gmail.com, gregkh@suse.de, greg@kroah.com,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Mon, 20 Oct 2008 16:39:02 -0700
In-Reply-To: <1224542725.31861.224.camel@brick>
Message-ID: <1224545942149@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: remove remaining uses of __FUNCTION__

to my gregkh-2.6 tree.  Its filename is

    staging-remove-remaining-uses-of-__function__.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From harvey.harrison@gmail.com  Mon Oct 20 15:48:28 2008
From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Mon, 20 Oct 2008 15:45:25 -0700
Subject: Staging: remove remaining uses of __FUNCTION__
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-ID: <1224542725.31861.224.camel@brick>


__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/usbip/usbip_common.c  |    2 +-
 drivers/staging/wlan-ng/wlan_compat.h |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -221,7 +221,7 @@ static void usbip_dump_request_type(__u8
 static void usbip_dump_usb_ctrlrequest(struct usb_ctrlrequest *cmd)
 {
 	if (!cmd) {
-		printk("      %s : null pointer\n", __FUNCTION__);
+		printk("      %s : null pointer\n", __func__);
 		return;
 	}
 
--- a/drivers/staging/wlan-ng/wlan_compat.h
+++ b/drivers/staging/wlan-ng/wlan_compat.h
@@ -245,11 +245,11 @@ typedef int64_t		INT64;
 #  define preempt_count() (0UL)
 #endif
 
-#define WLAN_LOG_ERROR(x,args...) printk(KERN_ERR "%s: " x , __FUNCTION__ , ##args);
+#define WLAN_LOG_ERROR(x,args...) printk(KERN_ERR "%s: " x , __func__ , ##args);
 
-#define WLAN_LOG_WARNING(x,args...) printk(KERN_WARNING "%s: " x , __FUNCTION__ , ##args);
+#define WLAN_LOG_WARNING(x,args...) printk(KERN_WARNING "%s: " x , __func__ , ##args);
 
-#define WLAN_LOG_NOTICE(x,args...) printk(KERN_NOTICE "%s: " x , __FUNCTION__ , ##args);
+#define WLAN_LOG_NOTICE(x,args...) printk(KERN_NOTICE "%s: " x , __func__ , ##args);
 
 #define WLAN_LOG_INFO(args... ) printk(KERN_INFO args)
 
@@ -265,7 +265,7 @@ typedef int64_t		INT64;
 	#define DBFENTER { if ( WLAN_DBVAR >= 5 ){ WLAN_LOG_DEBUG(3,"---->\n"); } }
 	#define DBFEXIT  { if ( WLAN_DBVAR >= 5 ){ WLAN_LOG_DEBUG(3,"<----\n"); } }
 
-	#define WLAN_LOG_DEBUG(l,x,args...) if ( WLAN_DBVAR >= (l)) printk(KERN_DEBUG "%s(%lu): " x ,  __FUNCTION__, (preempt_count() & PREEMPT_MASK), ##args );
+	#define WLAN_LOG_DEBUG(l,x,args...) if ( WLAN_DBVAR >= (l)) printk(KERN_DEBUG "%s(%lu): " x ,  __func__, (preempt_count() & PREEMPT_MASK), ##args );
 #else
 	#define WLAN_ASSERT(c)
 	#define WLAN_HEX_DUMP( l, s, p, n)


Patches currently in gregkh-2.6 which might be from harvey.harrison@gmail.com are

staging/staging-sxg-replace-__function__-with-__func__.patch
staging/staging-remove-remaining-uses-of-__function__.patch
