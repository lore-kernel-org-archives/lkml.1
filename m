Return-Path: <linux-kernel-owner+w=401wt.eu-S1761505AbZCZUtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761505AbZCZUtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 16:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756790AbZCZUtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 16:49:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33489 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758031AbZCZUtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:49:04 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] cdc-acm: zydas 1602 identifier needed
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Thu, 26 Mar 2009 20:50:02 +0000
Message-ID: <20090326204959.5020.80841.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bugzilla #9095 and a couple of other confirmations

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/usb/class/cdc-acm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index b3d5a23..5f957a9 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1358,6 +1358,9 @@ static struct usb_device_id acm_ids[] = {
 	{ USB_DEVICE(0x079b, 0x000f), /* BT On-Air USB MODEM */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},
+	{ USB_DEVICE(0x0ace, 0x1602), /* ZyDAS 56K USB MODEM */
+	.driver_info = SINGLE_RX_URB,
+	},
 	{ USB_DEVICE(0x0ace, 0x1608), /* ZyDAS 56K USB MODEM */
 	.driver_info = SINGLE_RX_URB, /* firmware bug */
 	},

