Return-Path: <linux-kernel-owner+w=401wt.eu-S1759088AbZFSClU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759088AbZFSClU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 22:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbZFSClM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 22:41:12 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:39945 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbZFSClL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 22:41:11 -0400
Message-ID: <4A3AFA06.1000107@oracle.com>
Date: Thu, 18 Jun 2009 19:37:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] block: fix blk-settings kernel-doc warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.4A3AFAC6.00A3:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc parameter name typo in blk-settings.c:

Warning(block/blk-settings.c:108): No description found for parameter 'lim'
Warning(block/blk-settings.c:108): Excess function parameter 'limits' description in 'blk_set_default_limits'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 block/blk-settings.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.30-git14.orig/block/blk-settings.c
+++ linux-2.6.30-git14/block/blk-settings.c
@@ -97,7 +97,7 @@ EXPORT_SYMBOL_GPL(blk_queue_lld_busy);
 
 /**
  * blk_set_default_limits - reset limits to default values
- * @limits:  the queue_limits structure to reset
+ * @lim:  the queue_limits structure to reset
  *
  * Description:
  *   Returns a queue_limit struct to its default state.  Can be used by


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
