Return-Path: <linux-kernel-owner+w=401wt.eu-S1751814AbZDTIRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbZDTIRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 04:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbZDTIRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 04:17:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:7902 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZDTIRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 04:17:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=A/rahxBjRG6wbCFX20R0+5Cg4QJ89P2ZG7+Z/oKr38bPvb+RI018VqQKgbF8uXUE/2
         OsjEIyRUvqmD6V2o7XMIQHoOHF8L8Gk7PXicKFuVFiH3KPYerCfYCHzJgChLeR2kRaHC
         W8Og3Ag203eVmJyHJA2W+9Cbp5S9xbxyHn7Dk=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 2/2] pktcdvd.h should include mempool.h
Date: Mon, 20 Apr 2009 12:17:24 +0400
Message-Id: <1240215444-8137-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com> 

Fix this build error:
In file included from fs/compat_ioctl.c:104:
include/linux/pktcdvd.h:285: error: expected specifier-qualifier-list before 'mempool_t'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 include/linux/pktcdvd.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pktcdvd.h b/include/linux/pktcdvd.h
index 04b4d73..d745f5b 100644
--- a/include/linux/pktcdvd.h
+++ b/include/linux/pktcdvd.h
@@ -113,6 +113,7 @@ struct pkt_ctrl_command {
 #include <linux/cdrom.h>
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
+#include <linux/mempool.h>
 
 /* default bio write queue congestion marks */
 #define PKT_WRITE_CONGESTION_ON    10000
-- 
1.6.2.3

