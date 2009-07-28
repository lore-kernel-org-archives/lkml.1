Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbZG1XzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbZG1XzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbZG1XzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:55:08 -0400
Received: from kroah.org ([198.145.64.141]:35885 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbZG1XuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:18 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:59 2009
Message-Id: <20090728234159.223294144@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jorrit Schippers <jorrit@ncode.nl>
Subject: [patch 50/71] Staging: rt2870: Add USB ID for Sitecom WL-608
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=staging-rt2870-add-usb-id-for-sitecom-wl-608.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jorrit Schippers <jorrit@ncode.nl>

commit 8dfb00571819ce491ce1760523d50e85bcd2185f upstream.

Add the USB id 0x0DF6,0x003F to the rt2870.h file such that the
Sitecom WL-608 device will be recognized by this driver.

Signed-off-by: Jorrit Schippers <jorrit@ncode.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rt2870/rt2870.h |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/rt2870/rt2870.h
+++ b/drivers/staging/rt2870/rt2870.h
@@ -97,6 +97,7 @@
 	{USB_DEVICE(0x0DF6,0x002C)}, /* Sitecom */		\
 	{USB_DEVICE(0x0DF6,0x002D)}, /* Sitecom */		\
 	{USB_DEVICE(0x0DF6,0x0039)}, /* Sitecom */		\
+	{USB_DEVICE(0x0DF6,0x003F)}, /* Sitecom WL-608 */	\
 	{USB_DEVICE(0x14B2,0x3C06)}, /* Conceptronic */		\
 	{USB_DEVICE(0x14B2,0x3C28)}, /* Conceptronic */		\
 	{USB_DEVICE(0x2019,0xED06)}, /* Planex Communications, Inc. */		\


