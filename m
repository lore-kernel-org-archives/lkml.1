Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbZJBB4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbZJBB4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbZJBBc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:32:57 -0400
Received: from kroah.org ([198.145.64.141]:33040 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443AbZJBBc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:56 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:11 2009
Message-Id: <20091002012411.334126022@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Christian Lamparter <chunkeey@googlemail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [036/136] ar9170usb: add usbid for TP-Link TL-WN821N v2
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=ar9170usb-add-usbid-for-tp-link-tl-wn821n-v2.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Christian Lamparter <chunkeey@googlemail.com>

commit fe9f6342c86292aee1941447f22dc5470735e5a1 upstream.

This patch adds the usbid for TP-Link TL-WN821N v2.

Reported-by: Fabian Lenz <lenz_fabian@yahoo.de>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ar9170/usb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -64,6 +64,8 @@ static struct usb_device_id ar9170_usb_i
 	{ USB_DEVICE(0x0cf3, 0x9170) },
 	/* Atheros TG121N */
 	{ USB_DEVICE(0x0cf3, 0x1001) },
+	/* TP-Link TL-WN821N v2 */
+	{ USB_DEVICE(0x0cf3, 0x1002) },
 	/* Cace Airpcap NX */
 	{ USB_DEVICE(0xcace, 0x0300) },
 	/* D-Link DWA 160A */


