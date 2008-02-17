Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbYBQIbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbYBQIbT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbYBQIa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:30:58 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:37336 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbYBQIa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:30:57 -0500
Date: Sun, 17 Feb 2008 10:30:31 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [2.6 patch] remove include/linux/netfilter_ipv4/ipt_SAME.h
Message-ID: <20080217083031.GY3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the no longer used include/linux/netfilter_ipv4/ipt_SAME.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/linux/netfilter_ipv4/Kbuild     |    1 -
 include/linux/netfilter_ipv4/ipt_SAME.h |   19 -------------------
 2 files changed, 20 deletions(-)

553bf355efd03581a094d8a4e0b278e04228aae8 diff --git a/include/linux/netfilter_ipv4/Kbuild b/include/linux/netfilter_ipv4/Kbuild
index 3a7105b..646d104 100644
--- a/include/linux/netfilter_ipv4/Kbuild
+++ b/include/linux/netfilter_ipv4/Kbuild
@@ -7,7 +7,6 @@ header-y += ipt_LOG.h
 header-y += ipt_MARK.h
 header-y += ipt_NFQUEUE.h
 header-y += ipt_REJECT.h
-header-y += ipt_SAME.h
 header-y += ipt_TCPMSS.h
 header-y += ipt_TOS.h
 header-y += ipt_TTL.h
diff --git a/include/linux/netfilter_ipv4/ipt_SAME.h b/include/linux/netfilter_ipv4/ipt_SAME.h
deleted file mode 100644
index be6e682..0000000
--- a/include/linux/netfilter_ipv4/ipt_SAME.h
+++ /dev/null
@@ -1,19 +0,0 @@
-#ifndef _IPT_SAME_H
-#define _IPT_SAME_H
-
-#define IPT_SAME_MAX_RANGE	10
-
-#define IPT_SAME_NODST		0x01
-
-struct ipt_same_info
-{
-	unsigned char info;
-	u_int32_t rangesize;
-	u_int32_t ipnum;
-	u_int32_t *iparray;
-
-	/* hangs off end. */
-	struct nf_nat_range range[IPT_SAME_MAX_RANGE];
-};
-
-#endif /*_IPT_SAME_H*/

