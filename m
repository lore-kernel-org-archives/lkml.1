Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbYJZHQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbYJZHQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 03:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYJZHQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 03:16:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:14695 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbYJZHQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 03:16:46 -0400
Message-ID: <4904195F.1050508@larces.uece.br>
Date: Sun, 26 Oct 2008 04:16:47 -0300
From: Sergio Luis <sergio@larces.uece.br>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [patch 2/2] libertas: free sk_buff with kfree_skb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free sk_buff with kfree_skb, instead of kree
 
Signed-off-by: Sergio Luis <sergio@larces.uece.br>
Cc: Dan Williams <dcbw@redhat.com>

drivers/net/wireless/libertas/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
index 5749f22..079e6aa 100644
--- a/drivers/net/wireless/libertas/rx.c
+++ b/drivers/net/wireless/libertas/rx.c
@@ -328,7 +328,7 @@ static int process_rxed_802_11_packet(struct lbs_private *priv,
 		lbs_deb_rx("rx err: frame received with bad length\n");
 		priv->stats.rx_length_errors++;
 		ret = -EINVAL;
-		kfree(skb);
+		kfree_skb(skb);
 		goto done;
 	}
 
