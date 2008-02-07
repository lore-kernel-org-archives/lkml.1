Return-Path: <linux-kernel-owner+w=401wt.eu-S1762461AbYBGU5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762461AbYBGU5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933200AbYBGUvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:51:19 -0500
Received: from mail.suse.de ([195.135.220.2]:45210 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758289AbYBGUvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:51:16 -0500
Date: Thu, 7 Feb 2008 12:47:08 -0800
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
       Bruno Redondi <bruno.redondi@altarisoluzione.com>
Subject: [patch 13/45] USB: sierra: add support for Onda H600/Zte MF330
	datacard to USB Driver for Sierra Wireless
Message-ID: <20080207204708.GN16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-sierra-add-support-for-onda-h600-zte-mf330-datacard-to-usb-driver-for-sierra-wireless.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Bruno Redondi <bruno.redondi@altarisoluzione.com>

Added support for Onda H600/Zte MF330 GPRS/UMTS/HSDPA datacard

Signed-off-by: Bruno Redondi <bruno.redondi@altarisoluzione.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/sierra.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -126,6 +126,7 @@ static struct usb_device_id id_table [] 
 
 	{ USB_DEVICE(0x1199, 0x0112), .driver_info = DEVICE_1_PORT }, /* Sierra Wireless AirCard 580 */
 	{ USB_DEVICE(0x0F3D, 0x0112), .driver_info = DEVICE_1_PORT }, /* Airprime/Sierra PC 5220 */
+	{ USB_DEVICE(0x05C6, 0x6613), .driver_info = DEVICE_1_PORT }, /* Onda H600/ZTE MF330 */
 
 	{ USB_DEVICE(0x1199, 0x0FFF), .driver_info = DEVICE_INSTALLER},
 	{ }
@@ -135,6 +136,7 @@ MODULE_DEVICE_TABLE(usb, id_table);
 static struct usb_device_id id_table_1port [] = {
 	{ USB_DEVICE(0x1199, 0x0112) }, /* Sierra Wireless AirCard 580 */
 	{ USB_DEVICE(0x0F3D, 0x0112) }, /* AirPrime/Sierra PC 5220 */
+	{ USB_DEVICE(0x05C6, 0x6613) }, /* Onda H600/ZTE MF330 */
 	{ }
 };
 

-- 
