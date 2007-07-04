Return-Path: <linux-kernel-owner+w=401wt.eu-S1762326AbXGDMba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762326AbXGDMba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 08:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761510AbXGDMak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 08:30:40 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:59095 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762154AbXGDMaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 08:30:39 -0400
Date: Wed, 4 Jul 2007 15:30:35 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/11] kernel/sched.c: lower printk severity
Message-ID: <79339a0c95c2dc008d60b7f70accd2d379203a08.1183551645.git.da-x@monatomic.org>
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
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 50e1a31..45e9534 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6249,7 +6249,7 @@ static void calibrate_migration_costs(const cpumask_t *cpu_map)
 #endif
 		);
 	if (system_state == SYSTEM_BOOTING && num_online_cpus() > 1) {
-		printk("migration_cost=");
+		printk(KERN_INFO "migration_cost=");
 		for (distance = 0; distance <= max_distance; distance++) {
 			if (distance)
 				printk(",");
-- 
1.4.4.3


-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
