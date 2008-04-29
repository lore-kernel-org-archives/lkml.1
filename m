Return-Path: <linux-kernel-owner+w=401wt.eu-S1758365AbYD2RUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365AbYD2RUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbYD2RUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:20:04 -0400
Received: from ns2.suse.de ([195.135.220.15]:42793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656AbYD2RUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:20:02 -0400
Date: Tue, 29 Apr 2008 10:17:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stefan Seyfried <seife@suse.de>
Subject: [02/37] USB: Add HP hs2300 Broadband Wireless Module to sierra.c
Message-ID: <20080429171754.GC14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-add-hp-hs2300-broadband-wireless-module-to-sierra.c.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Stefan Seyfried <seife@suse.de>

commit 8f7f85e9f9561507b009d26395c53e70758695ec upstream

Add the HP hs2300 Broadband Wireless Module (relabeled MC8775) USB IDs

Signed-off-by: Stefan Seyfried <seife@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/sierra.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -164,6 +164,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x1199, 0x6812) },	/* Sierra Wireless MC8775 & AC 875U */
 	{ USB_DEVICE(0x1199, 0x6813) },	/* Sierra Wireless MC8775 (Thinkpad internal) */
 	{ USB_DEVICE(0x1199, 0x6815) },	/* Sierra Wireless MC8775 */
+	{ USB_DEVICE(0x03f0, 0x1e1d) },	/* HP hs2300 a.k.a MC8775 */
 	{ USB_DEVICE(0x1199, 0x6820) },	/* Sierra Wireless AirCard 875 */
 	{ USB_DEVICE(0x1199, 0x6832) },	/* Sierra Wireless MC8780*/
 	{ USB_DEVICE(0x1199, 0x6833) },	/* Sierra Wireless MC8781*/

-- 
