Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935019Ab0CMBP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:15:59 -0500
Received: from kroah.org ([198.145.64.141]:32800 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935017Ab0CMAUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:53 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:13 2010
Message-Id: <20100313001513.362171207@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [patch 094/123] USB: fix the idProduct value for USB-3.0 root hubs
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Alan Stern <stern@rowland.harvard.edu>

commit cd780694920fbf869b23c8afb0bd083e7b0448c7 upstream.

This patch (as1346) changes the idProduct value for USB-3.0 root hubs
from 0x0002 (which we already use for USB-2.0 root hubs) to 0x0003.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -141,7 +141,7 @@ static const u8 usb3_rh_dev_descriptor[1
 	0x09,       /*  __u8  bMaxPacketSize0; 2^9 = 512 Bytes */
 
 	0x6b, 0x1d, /*  __le16 idVendor; Linux Foundation */
-	0x02, 0x00, /*  __le16 idProduct; device 0x0002 */
+	0x03, 0x00, /*  __le16 idProduct; device 0x0003 */
 	KERNEL_VER, KERNEL_REL, /*  __le16 bcdDevice */
 
 	0x03,       /*  __u8  iManufacturer; */


