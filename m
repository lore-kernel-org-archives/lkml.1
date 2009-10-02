Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbZJBBxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbZJBBxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbZJBBxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:53:45 -0400
Received: from kroah.org ([198.145.64.141]:33128 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755894AbZJBBdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:11 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:14 2009
Message-Id: <20091002012414.229834356@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       fangxiaozhi <huananhu@huawei.com>
Subject: [052/136] USB: usb-storage fails to attach to Huawei Datacard cdrom device
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-usb-storage-fails-to-attach-to-huawei-datacard-cdrom-device.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: fangxiaozhi <huananhu@huawei.com>

commit d0defb855c8504c49b92bdc0203689ce9b4cf7ba upstream.

In this patch, we always make the return value of function
usb_stor_huawei_e220_init to be zero. Then it will not prevent usb-storage
driver from attaching to the CDROM device of Huawei Datacard.

Signed-off-by: fangxiaozhi <huananhu@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/initializers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/initializers.c
+++ b/drivers/usb/storage/initializers.c
@@ -102,5 +102,5 @@ int usb_stor_huawei_e220_init(struct us_
 				      USB_TYPE_STANDARD | USB_RECIP_DEVICE,
 				      0x01, 0x0, NULL, 0x0, 1000);
 	US_DEBUGP("Huawei mode set result is %d\n", result);
-	return (result ? 0 : -ENODEV);
+	return 0;
 }


