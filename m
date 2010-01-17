Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964Ab0AQV0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab0AQV0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 16:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875Ab0AQV0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 16:26:35 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:39738 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab0AQV0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 16:26:35 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] trivial: missing newline in usb core warning message
Date: Sun, 17 Jan 2010 19:24:03 -0200
Message-Id: <1263763443-9613-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/usb/core/message.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 1b99484..46e51cf 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1316,7 +1316,7 @@ int usb_set_interface(struct usb_device *dev, int interface, int alternate)
 
 	alt = usb_altnum_to_altsetting(iface, alternate);
 	if (!alt) {
-		dev_warn(&dev->dev, "selecting invalid altsetting %d",
+		dev_warn(&dev->dev, "selecting invalid altsetting %d\n",
 			 alternate);
 		return -EINVAL;
 	}
-- 
1.6.6

