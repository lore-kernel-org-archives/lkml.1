Return-Path: <linux-kernel-owner+w=401wt.eu-S1760049AbXGDM3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbXGDM3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 08:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761715AbXGDM2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 08:28:49 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:59006 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761684AbXGDM2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 08:28:48 -0400
Date: Wed, 4 Jul 2007 15:28:43 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/11] net/ipv4/netfilter/ip_tables.c: lower printk severity
Message-ID: <c2dd2c6f0209c2d5396c69470588e0411b520e1d.1183551644.git.da-x@monatomic.org>
References: <6789b0ff288d584d640ee65f8e1e5e27bf040862.1183551644.git.da-x@monatomic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6789b0ff288d584d640ee65f8e1e5e27bf040862.1183551644.git.da-x@monatomic.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dan Aloni <da-x@monatomic.org>
---
 net/ipv4/netfilter/ip_tables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 9bacf1a..9a6354e 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -2230,7 +2230,7 @@ static int __init ip_tables_init(void)
 	if (ret < 0)
 		goto err5;
 
-	printk("ip_tables: (C) 2000-2006 Netfilter Core Team\n");
+	printk(KERN_INFO "ip_tables: (C) 2000-2006 Netfilter Core Team\n");
 	return 0;
 
 err5:
-- 
1.4.4.3


-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
