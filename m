Return-Path: <linux-kernel-owner+w=401wt.eu-S1765359AbXJOQcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765359AbXJOQcD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758967AbXJOQbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:31:50 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:58403 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758731AbXJOQbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:31:49 -0400
Message-id: <2257526776635831649@pripojeni.net>
In-reply-to: <25409162611123630013@pripojeni.net>
Subject: [PATCH 5/5] Char: rocket, fix signed/unsigned warning
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Mon, 15 Oct 2007 12:31:49 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rocket, fix signed/unsigned warning

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 5c008a5651ee92ebe020dd5108a66a7db74fe41d
tree 644fcf0e18b8fbf06d70014c95acd7cfc7b5dfa6
parent 8aa70f167a6ae0f80af0d73a5365c81f2e146709
author Jiri Slaby <jirislaby@gmail.com> Mon, 15 Oct 2007 15:44:58 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 15 Oct 2007 15:44:58 +0200

 drivers/char/rocket.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 27bb0cd..a825316 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -548,8 +548,8 @@ static void rp_handle_port(struct r_port *info)
 static void rp_do_poll(unsigned long dummy)
 {
 	CONTROLLER_t *ctlp;
-	int ctrl, aiop, ch, line, i;
-	unsigned int xmitmask;
+	int ctrl, aiop, ch, line;
+	unsigned int xmitmask, i;
 	unsigned int CtlMask;
 	unsigned char AiopMask;
 	Word_t bit;
