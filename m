Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030382Ab0B0QzF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:55:05 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968647Ab0B0Qyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:54:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=UMDN7ymsQF0ZCYX2lFQCoX15sf6Q5Nab7iKcoLItkzBPmtn/yr3uWUDr+zP1g4hUrY
         KtXwC+yGqyrIqBP8hq4VuYNitoN1zQrMpR7uwflewLmQH2pXd+zv2T0djAkGKVJI45cS
         U7BDNNJSoeUfmanRQ1vxB9tK5lZXGwGz9agD4=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Andrew Hendry <andrew.hendry@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, linux-x25@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [PATCH 30/66] include/net/x25device.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:11 +0100
Message-Id: <1267289508-31031-31-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/net/x25device.h:13: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 include/net/x25device.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/net/x25device.h b/include/net/x25device.h
index 1415bcf..246a17b 100644
--- a/include/net/x25device.h
+++ b/include/net/x25device.h
@@ -10,7 +10,7 @@ static inline __be16 x25_type_trans(struct sk_buff *skb, struct net_device *dev)
 	skb->dev = dev;
 	skb_reset_mac_header(skb);
 	skb->pkt_type = PACKET_HOST;
-	
+
 	return htons(ETH_P_X25);
 }
 #endif
-- 
1.7.0.90.g251a4

