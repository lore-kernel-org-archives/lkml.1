Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbZAAEhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbZAAEhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 23:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbZAAEhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 23:37:38 -0500
Received: from smtp.zeuux.org ([210.51.160.52]:63994 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbZAAEhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 23:37:37 -0500
Date: Thu, 1 Jan 2009 12:37:49 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: randy.dunlap@oracle.com
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>,
       mporter@kernel.crashing.org
Subject: [PATCH] rapidio: fix kernel-doc warning
Message-ID: <20090101043749.GA14614@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


rapidio: fix kernel-doc warning

Fix kernel-doc parameter warning and correct the descriptio:
Warning(/media/sda1/Project/linux-2.6//drivers/rapidio/rio-driver.c:88): Excess function parameter 'id'
description in 'rio_device_probe'
The parameter 'id' may be deleted.

Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
Cc: Matt Porter <mporter@kernel.crashing.org>

---
 drivers/rapidio/rio-driver.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/rapidio/rio-driver.c b/drivers/rapidio/rio-driver.c
index 956d3e7..cd6f14e 100644
--- a/drivers/rapidio/rio-driver.c
+++ b/drivers/rapidio/rio-driver.c
@@ -78,8 +78,7 @@ void rio_dev_put(struct rio_dev *rdev)
 }
 
 /**
- *  rio_device_probe - Tell if a RIO device structure has a matching RIO device id structure
- *  @id: the RIO device id structure to match against
+ *  rio_device_probe - Tell if a RIO device structure has a matching RIO device structure
  *  @dev: the RIO device structure to match against
  *
  * return 0 and set rio_dev->driver when drv claims rio_dev, else error
-- 
1.5.6.3

