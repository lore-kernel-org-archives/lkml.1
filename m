Return-Path: <linux-kernel-owner+w=401wt.eu-S1760886AbXGDM2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760886AbXGDM2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 08:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757328AbXGDM2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 08:28:05 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:58959 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669AbXGDM2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 08:28:04 -0400
Date: Wed, 4 Jul 2007 15:27:59 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/11] arch/x86_64/kernel/aperture.c: lower printk severity
Message-ID: <6789b0ff288d584d640ee65f8e1e5e27bf040862.1183551644.git.da-x@monatomic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Users that use kernel log filtering (e.g. via syslogd or a proprietry
method) wouldn't like to see warning prints that are not really warnings.

Signed-off-by: Dan Aloni <da-x@monatomic.org>
---
 arch/x86_64/kernel/aperture.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86_64/kernel/aperture.c b/arch/x86_64/kernel/aperture.c
index a3d450d..3b63074 100644
--- a/arch/x86_64/kernel/aperture.c
+++ b/arch/x86_64/kernel/aperture.c
@@ -214,7 +214,7 @@ void __init iommu_hole_init(void)
 	if (iommu_aperture_disabled || !fix_aperture || !early_pci_allowed())
 		return;
 
-	printk("Checking aperture...\n"); 
+	printk(KERN_INFO  "Checking aperture...\n");
 
 	fix = 0;
 	for (num = 24; num < 32; num++) {		
-- 
1.4.4.3


-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
