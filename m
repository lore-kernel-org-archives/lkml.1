Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbXJRF5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbXJRF5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 01:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbXJRF5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 01:57:44 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:32564 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbXJRF5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 01:57:43 -0400
X-IronPort-AV: i="4.21,293,1188792000"; 
   d="scan'208"; a="41946191:sNHT167410509"
From: Bryan Wu <bryan.wu@analog.com>
To: dmitry.torokhov@gmail.com, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Cc: Andrey Panin <pazke@donpac.ru>,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 1/1] INPUT/BF54x-KEYPAD driver:  Remove useless line -errno returned by irq_request
Date: Thu, 18 Oct 2007 13:57:35 +0800
Message-Id: <1192687055-11935-1-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Cc: Andrey Panin <pazke@donpac.ru>
Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/input/keyboard/bf54x-keys.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/input/keyboard/bf54x-keys.c b/drivers/input/keyboard/bf54x-keys.c
index a67b29b..e5f4da9 100644
--- a/drivers/input/keyboard/bf54x-keys.c
+++ b/drivers/input/keyboard/bf54x-keys.c
@@ -256,7 +256,6 @@ static int __devinit bfin_kpad_probe(struct platform_device *pdev)
 		printk(KERN_ERR DRV_NAME
 			": unable to claim irq %d; error %d\n",
 			bf54x_kpad->irq, error);
-		error = -EBUSY;
 		goto out2;
 	}
 
-- 
1.5.3.4
