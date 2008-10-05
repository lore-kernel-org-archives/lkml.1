Return-Path: <linux-kernel-owner+w=401wt.eu-S1761861AbYJEQng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761861AbYJEQng (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757164AbYJEQiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:38:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54313 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760363AbYJEQix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:38:53 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 17/19] cdc-acm: Add another conexant modem to the quirks
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:38:53 +0100
Message-ID: <20081005163831.3799.55146.stgit@localhost.localdomain>
In-Reply-To: <20081005163302.3799.61899.stgit@localhost.localdomain>
References: <20081005163302.3799.61899.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/class/cdc-acm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index c257453..eef9b2e 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1365,6 +1365,9 @@ static struct usb_device_id acm_ids[] = {
 	{ USB_DEVICE(0x0572, 0x1321), /* Conexant USB MODEM CX93010 */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},
+	{ USB_DEVICE(0x0572, 0x1324), /* Conexant USB MODEM RD02-D400 */
+	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
+	},
 
 	/* control interfaces with various AT-command sets */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,

