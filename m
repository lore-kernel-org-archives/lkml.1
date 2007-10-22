Return-Path: <linux-kernel-owner+w=401wt.eu-S1752186AbXJVJIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbXJVJIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbXJVJIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:08:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60930
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbXJVJIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:08:38 -0400
Date: Mon, 22 Oct 2007 02:09:00 -0700 (PDT)
Message-Id: <20071022.020900.41634188.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: bzolnier@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH]: Fix IDE host_flags regression.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Bart, please test your changes.

Thank you.

[IDE]: Expand hwif->host_flags so that it fits new flags.

This fixes regressions added by:
238e4f142c33bb34440cc64029dde7b9fbc4e65f

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/linux/ide.h b/include/linux/ide.h
index 2e4b8dd..4ed4777 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -667,7 +667,7 @@ typedef struct hwif_s {
 	u8 straight8;	/* Alan's straight 8 check */
 	u8 bus_state;	/* power state of the IDE bus */
 
-	u16 host_flags;
+	u32 host_flags;
 
 	u8 pio_mask;
 
