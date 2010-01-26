Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809Ab0A0AGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab0A0AGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941Ab0A0AGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:06:18 -0500
Received: from kroah.org ([198.145.64.141]:35097 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871Ab0AZXnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:01 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:22 2010
Message-Id: <20100126233921.894108085@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Klute <thomas2.klute@uni-dortmund.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: [08/98] ar9170: Add support for D-Link DWA 160 A2
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Klute <thomas2.klute@uni-dortmund.de>

commit 15295380f45aa0d35665f6e5596ac98c081d95b9 upstream.

At least two revisions of the D-Link DWA 160 exist, called A1 and A2. A1
(USB-ID 07d1:3c10) is already listed in usb.c as D-Link DWA 160A. A2
(USB-ID 07d1:3a09) works if added to ar9170_usb_ids. I didn't do much
testing until now, but I was able to connect to APs using WPA or WEP and
transmit data.

Summary:

* Add model revision number to the comment for D-Link DWA 160 A1 (07d1:3c10)
* Add support for D-Link DWA 160 A2 (07d1:3a09)

Signed-off-by: Thomas Klute <thomas2.klute@uni-dortmund.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ar9170/usb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -68,8 +68,10 @@ static struct usb_device_id ar9170_usb_i
 	{ USB_DEVICE(0x0cf3, 0x1002) },
 	/* Cace Airpcap NX */
 	{ USB_DEVICE(0xcace, 0x0300) },
-	/* D-Link DWA 160A */
+	/* D-Link DWA 160 A1 */
 	{ USB_DEVICE(0x07d1, 0x3c10) },
+	/* D-Link DWA 160 A2 */
+	{ USB_DEVICE(0x07d1, 0x3a09) },
 	/* Netgear WNDA3100 */
 	{ USB_DEVICE(0x0846, 0x9010) },
 	/* Netgear WN111 v2 */


