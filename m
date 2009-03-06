Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbZCFQKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbZCFQKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 11:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbZCFQKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 11:10:04 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:38611 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbZCFQKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 11:10:03 -0500
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH] w1: coding style cleanups in w1_io.c
Date: Fri,  6 Mar 2009 17:09:50 +0100
Message-Id: <1236355790-13856-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a number of coding style issues I stubled over.

Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Daniel Mack <daniel@caiaq.de>
---
 drivers/w1/w1_io.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/w1/w1_io.c b/drivers/w1/w1_io.c
index 442bd8b..3ebe972 100644
--- a/drivers/w1/w1_io.c
+++ b/drivers/w1/w1_io.c
@@ -69,7 +69,7 @@ static u8 w1_touch_bit(struct w1_master *dev, int bit)
 		return w1_read_bit(dev);
 	else {
 		w1_write_bit(dev, 0);
-		return(0);
+		return 0;
 	}
 }
 
@@ -184,17 +184,17 @@ static u8 w1_read_bit(struct w1_master *dev)
  */
 u8 w1_triplet(struct w1_master *dev, int bdir)
 {
-	if ( dev->bus_master->triplet )
-		return(dev->bus_master->triplet(dev->bus_master->data, bdir));
+	if (dev->bus_master->triplet)
+		return dev->bus_master->triplet(dev->bus_master->data, bdir);
 	else {
 		u8 id_bit   = w1_touch_bit(dev, 1);
 		u8 comp_bit = w1_touch_bit(dev, 1);
 		u8 retval;
 
-		if ( id_bit && comp_bit )
-			return(0x03);  /* error */
+		if (id_bit && comp_bit)
+			return 0x03;  /* error */
 
-		if ( !id_bit && !comp_bit ) {
+		if (!id_bit && !comp_bit) {
 			/* Both bits are valid, take the direction given */
 			retval = bdir ? 0x04 : 0;
 		} else {
@@ -203,11 +203,11 @@ u8 w1_triplet(struct w1_master *dev, int bdir)
 			retval = id_bit ? 0x05 : 0x02;
 		}
 
-		if ( dev->bus_master->touch_bit )
+		if (dev->bus_master->touch_bit)
 			w1_touch_bit(dev, bdir);
 		else
 			w1_write_bit(dev, bdir);
-		return(retval);
+		return retval;
 	}
 }
 
-- 
1.6.1.3

