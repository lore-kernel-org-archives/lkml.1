Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbZFLQ3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbZFLQ3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764587AbZFLQZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:25:12 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39092 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763228AbZFLQZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:25:04 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 14/27] Blackfin: bf537-stamp: update ADP5520 resources
Date: Fri, 12 Jun 2009 12:24:32 -0400
Message-Id: <1244823885-22410-15-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ADP5520 hooks up to PF7 rather than PG0.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf537/boards/stamp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index dfb5036..ff7228c 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -1345,7 +1345,7 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 #if defined(CONFIG_PMIC_ADP5520) || defined(CONFIG_PMIC_ADP5520_MODULE)
 	{
 		I2C_BOARD_INFO("pmic-adp5520", 0x32),
-		.irq = IRQ_PF7,
+		.irq = IRQ_PG0,
 		.platform_data = (void *)&adp5520_pdev_data,
 	},
 #endif
-- 
1.6.3.1

