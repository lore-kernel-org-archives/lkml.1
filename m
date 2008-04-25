Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbYDYEI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbYDYEI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 00:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYDYEH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 00:07:59 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:41144 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbYDYEH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 00:07:57 -0400
X-IronPort-AV: E=Sophos;i="4.25,706,1199682000"; 
   d="scan'208";a="67099941"
From: Bryan Wu <cooloney@kernel.org>
To: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 3/3] [MTD] m25p80: Add Support for ATMEL AT25DF641 64-Megabit SPI Flash
Date: Fri, 25 Apr 2008 12:07:33 +0800
Message-Id: <1209096453-21610-4-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1209096453-21610-1-git-send-email-cooloney@kernel.org>
References: <1209096453-21610-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mtd/devices/m25p80.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 14dd88d..e6f9cc9 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -446,6 +446,7 @@ static struct flash_info __devinitdata m25p_data [] = {
 	{ "at25fs040",  0x1f6604, 64 * 1024, 8, SECT_4K, },
 
 	{ "at25df041a", 0x1f4401, 64 * 1024, 8, SECT_4K, },
+	{ "at25df641",  0x1f4800, 64 * 1024, 128, SECT_4K, },
 
 	{ "at26f004",   0x1f0400, 64 * 1024, 8, SECT_4K, },
 	{ "at26df081a", 0x1f4501, 64 * 1024, 16, SECT_4K, },
-- 
1.5.5
