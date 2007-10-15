Return-Path: <linux-kernel-owner+w=401wt.eu-S1764982AbXJOQ35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764982AbXJOQ35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758776AbXJOQ3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:29:49 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:58388 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbXJOQ3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:29:48 -0400
Message-id: <29940160702595520146@pripojeni.net>
In-reply-to: <25409162611123630013@pripojeni.net>
Subject: [PATCH 2/5] Char: rocket, don't re-set statics to 0
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Mon, 15 Oct 2007 12:29:48 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rocket, don't re-set statics to 0

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit ad37fddef12ce908078883fdc27297216c6d122e
tree bf07d0f19abdc4220b1888e5385023c936fe3028
parent afb1b8bbdc2cc13a8c2c7d9fff49a3098a370971
author Jiri Slaby <jirislaby@gmail.com> Mon, 15 Oct 2007 13:53:01 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 15 Oct 2007 13:53:01 +0200

 drivers/char/rocket.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 94bb3d0..5fd1ed7 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -2372,18 +2372,6 @@ static int __init rp_init(void)
 		return -ENOMEM;
 
 	/*
-	 * Initialize the array of pointers to our own internal state
-	 * structures.
-	 */
-	memset(rp_table, 0, sizeof (rp_table));
-	memset(xmit_flags, 0, sizeof (xmit_flags));
-
-	for (i = 0; i < MAX_RP_PORTS; i++)
-		lineNumbers[i] = 0;
-	nextLineNumber = 0;
-	memset(rocketModel, 0, sizeof (rocketModel));
-
-	/*
 	 *  If board 1 is non-zero, there is at least one ISA configured.  If controller is 
 	 *  zero, use the default controller IO address of board1 + 0x40.
 	 */
