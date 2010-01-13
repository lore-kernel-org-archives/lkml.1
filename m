Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530Ab0AMXfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab0AMXfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 18:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541Ab0AMXfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 18:35:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54676 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755175Ab0AMXff convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 18:35:35 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Samuel Ortiz <samuel@sortiz.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Jan 2010 23:35:32 +0000
Message-ID: <1263425732.3852.118.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 02/11] irda-usb: declare MODULE_FIRMWARE
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
Please ack or nak this.

Ben.

 drivers/net/irda/irda-usb.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/irda/irda-usb.c b/drivers/net/irda/irda-usb.c
index e591b36..8b9200e 100644
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
1.6.5.7



