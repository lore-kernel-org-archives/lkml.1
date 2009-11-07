Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbZKGVy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbZKGVy3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 16:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbZKGVy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 16:54:27 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42429 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753160AbZKGVy0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 16:54:26 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Samuel Ortiz <samuel@sortiz.org>
Cc: irda-users@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:54:22 +0000
Message-ID: <1257630862.15927.441.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 41/75] irda-usb: declare MODULE_FIRMWARE
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/irda/irda-usb.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/irda/irda-usb.c b/drivers/net/irda/irda-usb.c
index 5e462b9..8160cf6 100644
--- a/drivers/net/irda/irda-usb.c
+++ b/drivers/net/irda/irda-usb.c
@@ -1146,6 +1146,9 @@ static int stir421x_patch_device(struct irda_usb_cb *self)
         return ret;
 }
 
+MODULE_FIRMWARE("42101001.sb");
+MODULE_FIRMWARE("42101002.sb");
+
 
 /********************** IRDA DEVICE CALLBACKS **********************/
 /*
-- 
1.6.5.2



