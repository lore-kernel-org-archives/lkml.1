Return-Path: <linux-kernel-owner+w=401wt.eu-S1762823AbZCTXXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762823AbZCTXXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757224AbZCTXOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:14:08 -0400
Received: from kroah.org ([198.145.64.141]:53282 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760130AbZCTXOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:14:00 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:27:13 2009
Message-Id: <20090320222713.363453936@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:26:39 -0700
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
       alan@lxorguk.ukuu.org.uk
Subject: [patch 28/32] USB: serial: new cp2101 device id
References: <20090320222611.872315885@mini.kroah.org>
Content-Disposition: inline; filename=usb-serial-new-cp2101-device-id.patch
In-Reply-To: <20090320231037.GA2732@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Robert M. Kenney <rmk@unh.edu>

commit c6535668798b0644e1af5934c2aec0e912280449 upstream.

From: Robert M. Kenney <rmk@unh.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/cp2101.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp2101.c
+++ b/drivers/usb/serial/cp2101.c
@@ -77,6 +77,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x10C4, 0x814A) }, /* West Mountain Radio RIGblaster P&P */
 	{ USB_DEVICE(0x10C4, 0x814B) }, /* West Mountain Radio RIGtalk */
 	{ USB_DEVICE(0x10C4, 0x815E) }, /* Helicomm IP-Link 1220-DVM */
+	{ USB_DEVICE(0x10C4, 0x819F) }, /* MJS USB Toslink Switcher */
 	{ USB_DEVICE(0x10C4, 0x81A6) }, /* ThinkOptics WavIt */
 	{ USB_DEVICE(0x10C4, 0x81AC) }, /* MSD Dash Hawk */
 	{ USB_DEVICE(0x10C4, 0x81C8) }, /* Lipowsky Industrie Elektronik GmbH, Baby-JTAG */


