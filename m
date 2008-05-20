Return-Path: <linux-kernel-owner+w=401wt.eu-S1762948AbYETIks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762948AbYETIks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 04:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757164AbYETIkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 04:40:37 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:62635 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758522AbYETIkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 04:40:36 -0400
X-IronPort-AV: E=Sophos;i="4.27,514,1204520400"; 
   d="scan'208";a="68619898"
From: Bryan Wu <cooloney@kernel.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] mtd m25p80: fix bug - ATmel spi flash fails to be copied to - fix up
Date: Tue, 20 May 2008 16:40:39 +0800
Message-Id: <1211272839-9007-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

remove duplicate code.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mtd/devices/m25p80.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index b10649b..7f89b54 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -122,8 +122,6 @@ static int write_sr(struct m25p *flash, u8 val)
 	flash->command[0] = OPCODE_WRSR;
 	flash->command[1] = val;
 
-	spi_write(flash->spi, flash->command, 2);
-
 	return spi_write(flash->spi, flash->command, 2);
 }
 
-- 
1.5.5
