Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbYFBKBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbYFBKBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYFBJ7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:59:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32966 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbYFBJ7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:59:05 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] bogus format in ip6mr
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Message-Id: <E1K36og-0007Z5-Ht@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 02 Jun 2008 10:59:02 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ptrdiff_t is %t..., not %Z...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 2de3c46..1479618 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -197,7 +197,7 @@ static int ip6mr_vif_seq_show(struct seq_file *seq, void *v)
 		const char *name = vif->dev ? vif->dev->name : "none";
 
 		seq_printf(seq,
-			   "%2Zd %-10s %8ld %7ld  %8ld %7ld %05X\n",
+			   "%2td %-10s %8ld %7ld  %8ld %7ld %05X\n",
 			   vif - vif6_table,
 			   name, vif->bytes_in, vif->pkt_in,
 			   vif->bytes_out, vif->pkt_out,
