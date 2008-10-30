Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbYJ3W7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbYJ3W7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 18:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153AbYJ3W7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 18:59:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:16255 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325AbYJ3W7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 18:59:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RclhXPbPnz2WPmykfEXRYW5AQZtx/ggvcm0Tg1CpPPiWC9l1PiIdhBMXUoaXfT5Jf6
         FVDTMSSaQLkOipQMH4npuLrr/WKR8GaBYkGh9Y282c1UDrVQ5LE12pzRMXhn/YD0cjJP
         oYIEq/dGVTIeD0tiK0PEZkWIZpwn8w3es+c0A=
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] [STAGING] Always register wlan-ng driver
Date: Fri, 31 Oct 2008 01:48:32 +0300
Message-Id: <1225406912-18376-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently wlan-ng driver registration is under #ifdef MODULE.
Register the wlan-ng driver even if it's built-in into the kernel.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/wlan-ng/prism2_usb.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2_usb.c b/drivers/staging/wlan-ng/prism2_usb.c
index e45be23..d1844eb 100644
--- a/drivers/staging/wlan-ng/prism2_usb.c
+++ b/drivers/staging/wlan-ng/prism2_usb.c
@@ -329,8 +329,6 @@ static struct usb_driver prism2_usb_driver = {
 	/* fops, minor? */
 };
 
-#ifdef MODULE
-
 static int __init prism2usb_init(void)
 {
         DBFENTER;
@@ -357,5 +355,3 @@ static void __exit prism2usb_cleanup(void)
 
 module_init(prism2usb_init);
 module_exit(prism2usb_cleanup);
-
-#endif // module
-- 
1.5.6.5

