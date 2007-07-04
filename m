Return-Path: <linux-kernel-owner+w=401wt.eu-S1761710AbXGDM2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761710AbXGDM2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 08:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759761AbXGDM2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 08:28:36 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:58997 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481AbXGDM2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 08:28:36 -0400
Date: Wed, 4 Jul 2007 15:28:25 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/11] arch/x86_64/kernel/e820.c: lower printk severity
Message-ID: <b5b3ed1ee6a8f427e70a96590afc1a194462748f.1183551644.git.da-x@monatomic.org>
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
 arch/x86_64/kernel/e820.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86_64/kernel/e820.c b/arch/x86_64/kernel/e820.c
index 13c6c37..47a8ce6 100644
--- a/arch/x86_64/kernel/e820.c
+++ b/arch/x86_64/kernel/e820.c
@@ -355,7 +355,7 @@ void __init e820_print_map(char *who)
 	int i;
 
 	for (i = 0; i < e820.nr_map; i++) {
-		printk(" %s: %016Lx - %016Lx ", who,
+		printk(KERN_INFO " %s: %016Lx - %016Lx ", who,
 			(unsigned long long) e820.map[i].addr,
 			(unsigned long long) (e820.map[i].addr + e820.map[i].size));
 		switch (e820.map[i].type) {
-- 
1.4.4.3


-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
