Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbYLEKXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbYLEKXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 05:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbYLEKU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 05:20:59 -0500
Received: from vps1.tull.net ([66.180.172.116]:47108 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752565AbYLEKU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 05:20:57 -0500
Mail-From: nobody Fri Dec  5 14:08:03 2008
From: Nick Andrew <nick@nick-andrew.net>
Subject: [PATCH] Fix incorrect use of loose in spider_net.c
To: Ishizaki Kou <kou.ishizaki@toshiba.co.jp>, Jeff Garzik <jgarzik@pobox.com>,
       Jeff Garzik <jgarzik@redhat.com>, Jens Osterkamp <jens@de.ibm.com>,
       Kou Ishizaki <kou.ishizaki@toshiba.co.jp>,
       Nick Andrew <nick@nick-andrew.net>,
       Qinghuang Feng <qhfeng.kernel@gmail.com>, netdev@vger.kernel.org
Cc: <linux-kernel@vger.kernel.org>, Nick Andrew <nick@nick-andrew.net>
Date: Fri, 05 Dec 2008 14:08:03 +1100
Message-ID: <20081205030803.32099.345.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect use of loose in spider_net.c

It should be 'lose', not 'loose'.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/net/spider_net.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/net/spider_net.c b/drivers/net/spider_net.c
index 07599b4..325fbc9 100644
--- a/drivers/net/spider_net.c
+++ b/drivers/net/spider_net.c
@@ -789,7 +789,7 @@ spider_net_set_low_watermark(struct spider_net_card *card)
  * spider_net_release_tx_chain releases the tx descriptors that spider has
  * finished with (if non-brutal) or simply release tx descriptors (if brutal).
  * If some other context is calling this function, we return 1 so that we're
- * scheduled again (if we were scheduled) and will not loose initiative.
+ * scheduled again (if we were scheduled) and will not lose initiative.
  */
 static int
 spider_net_release_tx_chain(struct spider_net_card *card, int brutal)


