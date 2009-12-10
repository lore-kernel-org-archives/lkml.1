Return-Path: <linux-kernel-owner+w=401wt.eu-S1758833AbZLJNrC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833AbZLJNrC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 08:47:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbZLJNq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 08:46:59 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:48685 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738AbZLJNq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 08:46:58 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: isdn@linux-pingi.de
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] ISDN: mISDN, don't compile unused stuff
Date: Thu, 10 Dec 2009 14:47:03 +0100
Message-Id: <1260452823-1408-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Remove these compiler warnings:
drivers/isdn/hardware/mISDN/w6692.c:534: warning: `setvolume' defined but not used
drivers/isdn/hardware/mISDN/w6692.c:561: warning: `enable_pots' defined but not used

by moving the functions inside #if 0 ... #endif. And alternative
would to remove them compeltely if nobody has plans to use them.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
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
1.6.5.5

