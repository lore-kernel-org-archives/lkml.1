Return-Path: <linux-kernel-owner+w=401wt.eu-S1765124AbXG0Pit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765124AbXG0Pit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 11:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758118AbXG0Pik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 11:38:40 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2958 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798AbXG0Pij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 11:38:39 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: thomas.dahlmann@amd.com, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] usb: remove redundant memset from amd5536udc
Date: Fri, 27 Jul 2007 17:38:37 +0200
User-Agent: KMail/1.9.5
Cc: info-linux@geode.amd.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707271738.37793.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	This patch removes redundant memset() call
from udc_pci_probe(). No functional change.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/usb/gadget/amd5536udc.c | 86768 -> 86731 (-37 bytes)
 drivers/usb/gadget/amd5536udc.o | 187342 -> 187066 (-276 bytes)

 drivers/usb/gadget/amd5536udc.c |    1 -
 1 file changed, 1 deletion(-)

--- linux-2.6.23-rc1-mm1-a/drivers/usb/gadget/amd5536udc.c	2007-07-26 13:07:41.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/usb/gadget/amd5536udc.c	2007-07-27 17:25:04.000000000 +0200
@@ -3242,11 +3242,10 @@ static int udc_pci_probe(
 	dev = kzalloc(sizeof(struct udc), GFP_KERNEL);
 	if (!dev) {
 		retval = -ENOMEM;
 		goto finished;
 	}
-	memset(dev, 0, sizeof(struct udc));

 	/* pci setup */
 	if (pci_enable_device(pdev) < 0) {
 		retval = -ENODEV;
 		goto finished;
