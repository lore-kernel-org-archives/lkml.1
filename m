Return-Path: <linux-kernel-owner+w=401wt.eu-S1752453AbZCNASi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbZCNASi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbZCNASW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:18:22 -0400
Received: from kroah.org ([198.145.64.141]:46553 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750898AbZCNASV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:18:21 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:38 2009
Message-Id: <20090314000738.731199401@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jason Cooper <jason@lakedaemon.net>
Subject: [patch 01/96] USB: net: asix: add support for Cables-to-Go USB Ethernet adapter
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=usb-net-asix-add-support-for-cables-to-go-usb-ethernet-adapter.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jason Cooper <jason@lakedaemon.net>

commit ccf95402d0ae6f433f29ce88cfd589cec8fc81ad upstream.

Add support to drivers/net/usb/asix.c for the Cables-to-Go "USB 2.0 to
10/100 Ethernet Adapter". USB id 0b95:772a.

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/asix.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -1444,6 +1444,10 @@ static const struct usb_device_id	produc
 	// Apple USB Ethernet Adapter
 	USB_DEVICE(0x05ac, 0x1402),
 	.driver_info = (unsigned long) &ax88772_info,
+}, {
+	// Cables-to-Go USB Ethernet Adapter
+	USB_DEVICE(0x0b95, 0x772a),
+	.driver_info = (unsigned long) &ax88772_info,
 },
 	{ },		// END
 };


