Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369Ab0AIMFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab0AIMFF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 07:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605Ab0AIMFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 07:05:03 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:10200 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab0AIMFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 07:05:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=AOJBQFvsUUnkCWW1ZGcdE1Gc9pcHJMPKZ9lYJ5uzC7F6pXhtCg3QAg7wX6GWhjNjid
         bIHzdz4NY/z+kP4Ac1dOe7kH1JjH5FfAKF/QBJpN1Jpp/4xSSYJSbLHzYvPPml1vNmxQ
         B0Zjph/oBdquN6OZX+TbgVT/CtAGahKvbfuvA=
Message-ID: <4B4871DD.5070505@gmail.com>
Date: Sat, 09 Jan 2010 13:09:01 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Felipe Balbi <felipe.balbi@nokia.com>, linux-usb@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] musb: Test always evaluates to false
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The removed part always evaluates to false.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/usb/musb/musb_gadget.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

Was a different test intended?

diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index cbcf14a..1a19203 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1697,8 +1697,7 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 		return -EINVAL;
 
 	/* driver must be initialized to support peripheral mode */
-	if (!musb || !(musb->board_mode == MUSB_OTG
-				|| musb->board_mode != MUSB_OTG)) {
+	if (!musb) {
 		DBG(1, "%s, no dev??\n", __func__);
 		return -ENODEV;
 	}
