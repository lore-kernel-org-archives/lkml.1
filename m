Return-Path: <linux-kernel-owner+w=401wt.eu-S1759209AbZCNA2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209AbZCNA2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbZCNASz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:18:55 -0400
Received: from kroah.org ([198.145.64.141]:46948 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753308AbZCNASx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:18:53 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:44 2009
Message-Id: <20090314000743.963791891@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:41 -0700
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
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 33/96] asix: new device ids
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=asix-new-device-ids.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
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
@@ -1448,6 +1448,14 @@ static const struct usb_device_id	produc
 	// Cables-to-Go USB Ethernet Adapter
 	USB_DEVICE(0x0b95, 0x772a),
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


