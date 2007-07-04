Return-Path: <linux-kernel-owner+w=401wt.eu-S1761549AbXGDM33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761549AbXGDM33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 08:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761884AbXGDM3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 08:29:03 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:59018 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759699AbXGDM3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 08:29:01 -0400
Date: Wed, 4 Jul 2007 15:28:55 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/11] drivers/char/ipmi/ipmi_poweroff.c: lower printk severity
Message-ID: <7f232225f5956dee4a8b9f7e5edcf4cd962286a6.1183551644.git.da-x@monatomic.org>
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
 drivers/char/ipmi/ipmi_poweroff.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_poweroff.c b/drivers/char/ipmi/ipmi_poweroff.c
index e02893b..b86186d 100644
--- a/drivers/char/ipmi/ipmi_poweroff.c
+++ b/drivers/char/ipmi/ipmi_poweroff.c
@@ -679,7 +679,7 @@ static int ipmi_poweroff_init (void)
 {
 	int rv;
 
-	printk ("Copyright (C) 2004 MontaVista Software -"
+	printk (KERN_INFO "Copyright (C) 2004 MontaVista Software -"
 		" IPMI Powerdown via sys_reboot.\n");
 
 	if (poweroff_powercycle)
-- 
1.4.4.3


-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
