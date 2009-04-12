Return-Path: <linux-kernel-owner+w=401wt.eu-S1760295AbZDLLU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295AbZDLLU7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 07:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbZDLLUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 07:20:50 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:16486 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbZDLLUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 07:20:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :user-agent;
        b=XJDiFbouzk8h03lh/GaJddc1MjLDfc1yPnfmGW856zjCesTxW6auVJgC+YFcNkFnv3
         BUqTj/hWYuttyhY1XikhRMwZxFRJIxBVMGsm+aJ8uhDooIIa20wiTuhTr40RJGP4JEE3
         bTjOBdwc8RTROgKc/iqxdFVfoLXiolyyHqEek=
Date: Sun, 12 Apr 2009 19:19:25 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH]fix a warning on drivers/pci/hotplug/ibmphp_core.c
Message-ID: <20090412111925.GB3574@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix this warning:
drivers/pci/hotplug/ibmphp_core.c:1414: warning: ‘ibmphp_exit’ defined but not used

It missed the "module_exit".


>From bb3c7845b38dff4628fe482207790b82a3df0ab4 Mon Sep 17 00:00:00 2001
From: Zhenwen Xu <Helight.Xu@gmail.com>
Date: Sun, 12 Apr 2009 19:10:58 +0800
Subject: [PATCH] fix the warning ‘ibmphp_exit’ defined but not used
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
---
 drivers/pci/hotplug/ibmphp_core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
index dd18f85..29ccb8a 100644
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -1419,3 +1419,4 @@ static void __exit ibmphp_exit(void)
 }
 
 module_init(ibmphp_init);
+module_exit(ibmphp_exit);
-- 
1.5.6.5

-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org
My Studio:	http://dim4.cn

