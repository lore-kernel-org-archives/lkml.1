Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbZHMTvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbZHMTvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932122AbZHMTrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:47:55 -0400
Received: from kroah.org ([198.145.64.141]:36751 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095AbZHMTry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:47:54 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:43:38 2009
Message-Id: <20090813194337.902555537@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:40:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 15/28] asix: new device ids
References: <20090813194021.446758568@mini.kroah.org>
Content-Disposition: inline; filename=asix-new-device-ids.patch
In-Reply-To: <20090813194554.GA13947@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit fef7cc0893146550b286b13c0e6e914556142730 upstream.

This patch adds two new device ids to the asix driver.

One comes directly from the asix driver on their web site, the other was
reported by Armani Liao as needed for the MSI X320 to get the driver to
work properly for it.

Reported-by: Armani Liao <aliao@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
 drivers/net/usb/asix.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -1456,6 +1456,14 @@ static const struct usb_device_id	produc
 	// ASIX 88772a
 	USB_DEVICE(0x0db0, 0xa877),
 	.driver_info = (unsigned long) &ax88772_info,
+}, {
+	// ABOCOM for pci
+	USB_DEVICE(0x14ea, 0xab11),
+	.driver_info = (unsigned long) &ax88178_info,
+}, {
+	// ASIX 88772a
+	USB_DEVICE(0x0db0, 0xa877),
+	.driver_info = (unsigned long) &ax88772_info,
 },
 	{ },		// END
 };


