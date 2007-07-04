Return-Path: <linux-kernel-owner+w=401wt.eu-S1759596AbXGDM2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596AbXGDM2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 08:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761167AbXGDM2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 08:28:19 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:58973 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761008AbXGDM2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 08:28:17 -0400
Date: Wed, 4 Jul 2007 15:28:12 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/11] arch/x86_64/kernel/apic.c: lower printk severity
Message-ID: <2466fe9e4cc366192d186c4ec73c314fbfed2d91.1183551644.git.da-x@monatomic.org>
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
 arch/x86_64/kernel/apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86_64/kernel/apic.c b/arch/x86_64/kernel/apic.c
index 1b0e07b..243116f 100644
--- a/arch/x86_64/kernel/apic.c
+++ b/arch/x86_64/kernel/apic.c
@@ -868,7 +868,7 @@ static int __init calibrate_APIC_clock(void)
 		result = (apic_start - apic) * 1000L * tsc_khz /
 					(tsc - tsc_start);
 	}
-	printk("result %d\n", result);
+	printk(KERN_DEBUG "result %d\n", result);
 
 
 	printk(KERN_INFO "Detected %d.%03d MHz APIC timer.\n",
-- 
1.4.4.3


-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
