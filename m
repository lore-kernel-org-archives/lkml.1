Return-Path: <linux-kernel-owner+w=401wt.eu-S932110AbZCTXhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbZCTXhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763008AbZCTXYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:52 -0400
Received: from kroah.org ([198.145.64.141]:48769 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762191AbZCTXYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:50 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:28 2009
Message-Id: <20090320222928.107324607@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:43 -0700
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
Subject: [patch 33/43] USB: usbtmc: add protocol 1 support
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=usb-usbtmc-add-protocol-1-support.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit 228dd05dbfdd0fced8ab1a28ed73b500ba6bb0a6 upstream.

The driver already supports the 1 protocol support, so just add it to
the MODULE_DEVICE_TABLE entry so it properly picks up these devices.

Thanks to Jouni Rynö for pointing this out.

Reported-by: Jouni Ryno <Jouni.Ryno@fmi.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/usbtmc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -49,6 +49,7 @@
 
 static struct usb_device_id usbtmc_devices[] = {
 	{ USB_INTERFACE_INFO(USB_CLASS_APP_SPEC, 3, 0), },
+	{ USB_INTERFACE_INFO(USB_CLASS_APP_SPEC, 3, 1), },
 	{ 0, } /* terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, usbtmc_devices);


