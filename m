Return-Path: <linux-kernel-owner+w=401wt.eu-S1761716AbXJXQcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761716AbXJXQcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759202AbXJXQXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:23:43 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33374 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759281AbXJXQXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:23:41 -0400
Date: Wed, 24 Oct 2007 18:24:10 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David L Stevens <dlstevens@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [2.6 patch] unexport icmpmsg_statistics
Message-ID: <20071024162410.GE30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused EXPORT_SYMBOL(icmpmsg_statistics).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
4ce74657ac0b1bdcb4c7bc359d05643f8cc4a08b 
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 272c69e..233de06 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1104,5 +1104,4 @@ void __init icmp_init(struct net_proto_family *ops)
 EXPORT_SYMBOL(icmp_err_convert);
 EXPORT_SYMBOL(icmp_send);
 EXPORT_SYMBOL(icmp_statistics);
-EXPORT_SYMBOL(icmpmsg_statistics);
 EXPORT_SYMBOL(xrlim_allow);

