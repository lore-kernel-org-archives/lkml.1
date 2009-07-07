Return-Path: <linux-kernel-owner+w=401wt.eu-S1759015AbZGGOii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015AbZGGOii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758699AbZGGOgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:36:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:42775 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758702AbZGGOge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:36:34 -0400
Subject: [PATCH 18/22] trivial: fix typo "too too"
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:54:12 +0530
Message-Id: <1246976652.3613.35.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replaced "too too" with "too"

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 net/dccp/ipv4.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index a0a36c9..d27500f 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -731,7 +731,7 @@ int dccp_invalid_packet(struct sk_buff *skb)
 		return 1;
 	}
 	/*
-	 * If P.Data Offset is too too large for packet, drop packet and return
+	 * If P.Data Offset is too large for packet, drop packet and return
 	 */
 	if (!pskb_may_pull(skb, dh->dccph_doff * sizeof(u32))) {
 		DCCP_WARN("P.Data Offset(%u) too large\n", dh->dccph_doff);
-- 
1.6.0.6



