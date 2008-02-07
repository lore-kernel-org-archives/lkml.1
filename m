Return-Path: <linux-kernel-owner+w=401wt.eu-S933755AbYBGUyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755AbYBGUyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933154AbYBGUuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:50:55 -0500
Received: from ns2.suse.de ([195.135.220.15]:38148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933131AbYBGUux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:50:53 -0500
Date: Thu, 7 Feb 2008 12:46:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, linux-usb@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jessica L Blank <j@twu.net>
Subject: [patch 08/45] USB: Sierra - Add support for Aircard 881U
Message-ID: <20080207204654.GI16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-sierra-add-support-for-aircard-881u.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jessica L. Blank <j@twu.net>

Adds the appropriate vendor and device IDs for the AirCard 881U to
sierra.c. (This device is often rebadged by AT&T as the USBConnect 881).

Signed-off-by: Jessica L Blank <j@twu.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/sierra.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -117,6 +117,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x1199, 0x6851) },	/* Sierra Wireless AirCard 881 */
 	{ USB_DEVICE(0x1199, 0x6852) },	/* Sierra Wireless AirCard 880 E */
 	{ USB_DEVICE(0x1199, 0x6853) },	/* Sierra Wireless AirCard 881 E */
+	{ USB_DEVICE(0x1199, 0x6856) },	/* Sierra Wireless AirCard 881 U */
 
 	{ USB_DEVICE(0x1199, 0x0112), .driver_info = DEVICE_1_PORT }, /* Sierra Wireless AirCard 580 */
 	{ USB_DEVICE(0x0F3D, 0x0112), .driver_info = DEVICE_1_PORT }, /* Airprime/Sierra PC 5220 */
@@ -155,6 +156,7 @@ static struct usb_device_id id_table_3po
 	{ USB_DEVICE(0x1199, 0x6851) },	/* Sierra Wireless AirCard 881 */
 	{ USB_DEVICE(0x1199, 0x6852) },	/* Sierra Wireless AirCard 880E */
 	{ USB_DEVICE(0x1199, 0x6853) },	/* Sierra Wireless AirCard 881E */
+	{ USB_DEVICE(0x1199, 0x6856) },	/* Sierra Wireless AirCard 881U */
 	{ }
 };
 

-- 
