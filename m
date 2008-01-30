Return-Path: <linux-kernel-owner+w=401wt.eu-S1760268AbYA3K1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760268AbYA3K1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 05:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYA3K13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 05:27:29 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:12728 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbYA3K12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 05:27:28 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="61207338"
From: Bryan Wu <bryan.wu@analog.com>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 1/1] [MTD] chips: add a new INTEL ID to kernel cfi driver.
Date: Wed, 30 Jan 2008 18:27:24 +0800
Message-Id: <1201688844-2318-1-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/mtd/chips/cfi_cmdset_0001.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
index 1707f98..a833618 100644
--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -246,6 +246,7 @@ static struct cfi_fixup cfi_fixup_table[] = {
 	{ CFI_MFR_ST, 0x00ba, /* M28W320CT */ fixup_st_m28w320ct, NULL },
 	{ CFI_MFR_ST, 0x00bb, /* M28W320CB */ fixup_st_m28w320cb, NULL },
 	{ MANUFACTURER_INTEL, 0x891c,	      fixup_use_powerup_lock, NULL, },
+	{ MANUFACTURER_INTEL, 0x891f,	      fixup_use_powerup_lock, NULL, },
 	{ 0, 0, NULL, NULL }
 };
 
-- 
1.5.3.4
