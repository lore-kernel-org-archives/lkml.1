Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792Ab0A2J3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab0A2J3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756578Ab0A2J3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:29:07 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:40880 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab0A2J3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:29:04 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: isdn@linux-pingi.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
Subject: [PATCH 1/1] ISDN: mISDN, don't compile unused stuff
Date: Fri, 29 Jan 2010 10:29:03 +0100
Message-Id: <1264757343-445-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Remove these compiler warnings:
drivers/isdn/hardware/mISDN/w6692.c:534: warning: `setvolume' defined but not used
drivers/isdn/hardware/mISDN/w6692.c:561: warning: `enable_pots' defined but not used

by moving the functions inside #if 0 ... #endif. And an alternative
is to remove them completely if nobody has plans to use them.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Karsten Keil <isdn@linux-pingi.de>
---
 drivers/isdn/hardware/mISDN/w6692.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/w6692.c b/drivers/isdn/hardware/mISDN/w6692.c
index d3f1077..2952a58 100644
--- a/drivers/isdn/hardware/mISDN/w6692.c
+++ b/drivers/isdn/hardware/mISDN/w6692.c
@@ -529,6 +529,7 @@ W6692_fill_Bfifo(struct w6692_ch *wch)
 	}
 }
 
+#if 0
 static int
 setvolume(struct w6692_ch *wch, int mic, struct sk_buff *skb)
 {
@@ -571,6 +572,7 @@ enable_pots(struct w6692_ch *wch)
 	WriteW6692(card, W_PCTL, card->pctl);
 	return 0;
 }
+#endif
 
 static int
 disable_pots(struct w6692_ch *wch)
-- 
1.6.6.1

