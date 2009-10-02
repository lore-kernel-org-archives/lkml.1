Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbZJBBc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbZJBBc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbZJBBc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:32:26 -0400
Received: from kroah.org ([198.145.64.141]:32858 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117AbZJBBcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:24 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:06 2009
Message-Id: <20091002012406.184377731@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:15:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Christian Lamparter <chunkeey@googlemail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [003/136] p54usb: add Zcomax XG-705A usbid
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=p54usb-add-zcomax-xg-705a-usbid.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Christian Lamparter <chunkeey@googlemail.com>

commit f7f71173ea69d4dabf166533beffa9294090b7ef upstream.

This patch adds a new usbid for Zcomax XG-705A to the device table.

Reported-by: Jari Jaakola <jari.jaakola@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/p54usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -66,6 +66,7 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x0bf8, 0x1009)},   /* FUJITSU E-5400 USB D1700*/
 	{USB_DEVICE(0x0cde, 0x0006)},   /* Medion MD40900 */
 	{USB_DEVICE(0x0cde, 0x0008)},	/* Sagem XG703A */
+	{USB_DEVICE(0x0cde, 0x0015)},	/* Zcomax XG-705A */
 	{USB_DEVICE(0x0d8e, 0x3762)},	/* DLink DWL-G120 Cohiba */
 	{USB_DEVICE(0x124a, 0x4025)},	/* IOGear GWU513 (GW3887IK chip) */
 	{USB_DEVICE(0x1260, 0xee22)},	/* SMC 2862W-G version 2 */


