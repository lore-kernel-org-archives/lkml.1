Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348Ab0BDRWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:22:22 -0500
Received: from kroah.org ([198.145.64.141]:34730 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933240Ab0BDRVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:55 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:07 2010
Message-Id: <20100204171507.112727504@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?ISO-8859-15?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
       Dmitry Torokhov <dtor@mail.ru>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [33/74] Input: winbond-cir - remove dmesg spam
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Härdeman <david@hardeman.nu>

commit 93fb84b50fe03aabca8d9dea5d3ba521a07e8571 upstream.

I missed converting one dev_info call to deb_dbg before submitting the driver.
Without this change, a message will be printed to dmesg for each button press
if a RC6 remote is used.

Signed-off-by: David Härdeman <david@hardeman.nu>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/misc/winbond-cir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/misc/winbond-cir.c
+++ b/drivers/input/misc/winbond-cir.c
@@ -768,7 +768,7 @@ wbcir_parse_rc6(struct device *dev, stru
 		return;
 	}
 
-	dev_info(dev, "IR-RC6 ad 0x%02X cm 0x%02X cu 0x%04X "
+	dev_dbg(dev, "IR-RC6 ad 0x%02X cm 0x%02X cu 0x%04X "
 		"toggle %u mode %u scan 0x%08X\n",
 		address,
 		command,


