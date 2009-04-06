Return-Path: <linux-kernel-owner+w=401wt.eu-S1758832AbZDFPlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbZDFPlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756930AbZDFPg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:36:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57003 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756885AbZDFPg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:36:28 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 23/27] cdc-acm: zydas 1602 identifier needed
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Apr 2009 17:35:01 +0100
Message-ID: <20090406163458.12934.66631.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
References: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
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
index 85f22c6..869d47c 100644
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

