Return-Path: <linux-kernel-owner+w=401wt.eu-S1761771AbXGDMar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761771AbXGDMar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 08:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761276AbXGDMaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 08:30:11 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:59057 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761581AbXGDMaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 08:30:09 -0400
Date: Wed, 4 Jul 2007 15:30:04 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [PATCH 9/11] arch/x86_64/kernel/process.c: lower printk severity
Message-ID: <4fe620fe3b24847bb8ebec3ffe10469f89351248.1183551645.git.da-x@monatomic.org>
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
 arch/x86_64/kernel/process.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86_64/kernel/process.c b/arch/x86_64/kernel/process.c
index 5909039..cd2a3cd 100644
--- a/arch/x86_64/kernel/process.c
+++ b/arch/x86_64/kernel/process.c
@@ -278,7 +278,7 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 		 */
 		if (!pm_idle) {
 			if (!printed) {
-				printk("using mwait in idle threads.\n");
+				printk(KERN_INFO "using mwait in idle threads.\n");
 				printed = 1;
 			}
 			pm_idle = mwait_idle;
-- 
1.4.4.3


-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
