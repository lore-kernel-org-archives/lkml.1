Return-Path: <linux-kernel-owner+w=401wt.eu-S932271AbZHMUEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbZHMUEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932268AbZHMT77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:59 -0400
Received: from kroah.org ([198.145.64.141]:41884 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253AbZHMT75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:57 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:32 2009
Message-Id: <20090813195132.410969736@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roel Kluin <roel.kluin@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 53/74] atl1c: misplaced parenthesis
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=atl1c-misplaced-parenthesis.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: roel kluin <roel.kluin@gmail.com>

commit 37b76c697f4ac082e9923dfa8e8aecc8bc54a8e1 upstream.

Fix misplaced parenthesis

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/atl1c/atl1c_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/atl1c/atl1c_main.c
+++ b/drivers/net/atl1c/atl1c_main.c
@@ -1701,7 +1701,7 @@ static void atl1c_clean_rx_irq(struct at
 		if (likely(RRS_RXD_IS_VALID(rrs->word3))) {
 			rfd_num = (rrs->word0 >> RRS_RX_RFD_CNT_SHIFT) &
 				RRS_RX_RFD_CNT_MASK;
-			if (unlikely(rfd_num) != 1)
+			if (unlikely(rfd_num != 1))
 				/* TODO support mul rfd*/
 				if (netif_msg_rx_err(adapter))
 					dev_warn(&pdev->dev,


