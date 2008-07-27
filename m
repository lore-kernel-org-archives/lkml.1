Return-Path: <linux-kernel-owner+w=401wt.eu-S1757823AbYG0G3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823AbYG0G3s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758412AbYG0G3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:29:37 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:35936 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758262AbYG0G3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:29:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=U7LJeVFA5PZ2WPhsPMAIvts5dO6Hn+1L4KCdXvB1xEUXZYc0drgf7XwG0iiMppESAD
         3fWraaQRgDt9fvAnmMcDNEpR7554vGY1ev7DF+th9Fzbj2MZdPDCutBQWF/jreRCX0ZG
         bd728NMocRru9oSC+Ce42OXZfuwrhnmDMPF3w=
From: Bryan Wu <cooloney@kernel.org>
To: dwmw2@infradead.org, akpm@linux-foundation.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 5/7] [MTD] Blackfin NFC Driver: enable Blackfin nand HWECC support by default
Date: Sun, 27 Jul 2008 14:27:57 +0800
Message-Id: <1217140079-20014-6-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1217140079-20014-1-git-send-email-cooloney@kernel.org>
References: <1217140079-20014-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mtd/nand/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 6ca1ec0..582942d 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -105,6 +105,7 @@ config MTD_NAND_BF5XX
 
 config MTD_NAND_BF5XX_HWECC
 	bool "BF5XX NAND Hardware ECC"
+	default y
 	depends on MTD_NAND_BF5XX
 	help
 	  Enable the use of the BF5XX's internal ECC generator when
-- 
1.5.6

