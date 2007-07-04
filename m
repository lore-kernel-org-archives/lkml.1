Return-Path: <linux-kernel-owner+w=401wt.eu-S1762008AbXGDM3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762008AbXGDM3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 08:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761899AbXGDM3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 08:29:18 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:59032 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761803AbXGDM3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 08:29:16 -0400
Date: Wed, 4 Jul 2007 15:29:10 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/11] drivers/char/ipmi/ipmi_si_intf.c: lower printk severity
Message-ID: <40de8243be3a16cea3de203d02518d2d3be3c026.1183551644.git.da-x@monatomic.org>
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
 drivers/char/ipmi/ipmi_si_intf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 78e1b96..4edfdda 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2857,7 +2857,7 @@ static int try_smi_init(struct smi_info *new_smi)
 
 	mutex_unlock(&smi_infos_lock);
 
-	printk(" IPMI %s interface initialized\n",si_to_str[new_smi->si_type]);
+	printk(KERN_INFO "IPMI %s interface initialized\n",si_to_str[new_smi->si_type]);
 
 	return 0;
 
-- 
1.4.4.3


-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
