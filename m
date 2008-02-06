Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbYBGAN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbYBGAN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932104AbYBFX57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:57:59 -0500
Received: from ns2.suse.de ([195.135.220.15]:60868 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081AbYBFX55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:57:57 -0500
Date: Wed, 6 Feb 2008 15:53:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 39/73] USB: update sierra.c with latest device ids that are
	in 2.6.24-rc7
Message-ID: <20080206235308.GN13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-update-sierra.c-with-latest-device-ids-that-are-in-2.6.24-rc7.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Greg Kroah-Hartman <gregkh@suse.de>

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/sierra.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -100,6 +100,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x1199, 0x0218) },	/* Sierra Wireless MC5720 */
 	{ USB_DEVICE(0x0f30, 0x1b1d) },	/* Sierra Wireless MC5720 */
 	{ USB_DEVICE(0x1199, 0x0020) },	/* Sierra Wireless MC5725 */
+	{ USB_DEVICE(0x1199, 0x0220) },	/* Sierra Wireless MC5725 */
 	{ USB_DEVICE(0x1199, 0x0019) },	/* Sierra Wireless AirCard 595 */
 	{ USB_DEVICE(0x1199, 0x0021) },	/* Sierra Wireless AirCard 597E */
 	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless USB Dongle 595U */
@@ -108,6 +109,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x1199, 0x6804) },	/* Sierra Wireless MC8755 */
 	{ USB_DEVICE(0x1199, 0x6803) },	/* Sierra Wireless MC8765 */
 	{ USB_DEVICE(0x1199, 0x6812) },	/* Sierra Wireless MC8775 & AC 875U */
+	{ USB_DEVICE(0x1199, 0x6813) },	/* Sierra Wireless MC8775 (Thinkpad internal) */
 	{ USB_DEVICE(0x1199, 0x6820) },	/* Sierra Wireless AirCard 875 */
 	{ USB_DEVICE(0x1199, 0x6832) },	/* Sierra Wireless MC8780*/
 	{ USB_DEVICE(0x1199, 0x6833) },	/* Sierra Wireless MC8781*/
@@ -136,6 +138,7 @@ static struct usb_device_id id_table_3po
 	{ USB_DEVICE(0x0f30, 0x1b1d) },	/* Sierra Wireless MC5720 */
 	{ USB_DEVICE(0x1199, 0x0218) },	/* Sierra Wireless MC5720 */
 	{ USB_DEVICE(0x1199, 0x0020) },	/* Sierra Wireless MC5725 */
+	{ USB_DEVICE(0x1199, 0x0220) },	/* Sierra Wireless MC5725 */
 	{ USB_DEVICE(0x1199, 0x0019) },	/* Sierra Wireless AirCard 595 */
 	{ USB_DEVICE(0x1199, 0x0021) },	/* Sierra Wireless AirCard 597E */
 	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless USB Dongle 595U*/
@@ -144,6 +147,7 @@ static struct usb_device_id id_table_3po
 	{ USB_DEVICE(0x1199, 0x6804) },	/* Sierra Wireless MC8755 */
 	{ USB_DEVICE(0x1199, 0x6803) },	/* Sierra Wireless MC8765 */
 	{ USB_DEVICE(0x1199, 0x6812) },	/* Sierra Wireless MC8775 & AC 875U */
+	{ USB_DEVICE(0x1199, 0x6813) },	/* Sierra Wireless MC8775 (Thinkpad internal) */
 	{ USB_DEVICE(0x1199, 0x6820) },	/* Sierra Wireless AirCard 875 */
 	{ USB_DEVICE(0x1199, 0x6832) },	/* Sierra Wireless MC8780*/
 	{ USB_DEVICE(0x1199, 0x6833) },	/* Sierra Wireless MC8781*/

-- 
