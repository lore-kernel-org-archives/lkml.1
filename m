Return-Path: <linux-kernel-owner+w=401wt.eu-S1765341AbXEUKR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765341AbXEUKR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761997AbXEUKJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:44 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:4457 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761483AbXEUKJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:20 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="39510293:sNHT20543943"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 07/32] Blackfin arch: Fix reserved map after we changed PORT_H definition
Date: Mon, 21 May 2007 18:09:15 +0800
Message-Id: <11797421832692-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/bfin_gpio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index bc16252..3f49fae 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -188,9 +188,9 @@ static int __init bfin_gpio_init(void)
 
 #if defined(BF537_FAMILY) && (defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE))
 # if defined(CONFIG_BFIN_MAC_RMII)
-	reserved_map[PORT_H] = 0xC373;
+	reserved_map[gpio_bank(PORT_H)] = 0xC373;
 # else
-	reserved_map[PORT_H] = 0xFFFF;
+	reserved_map[gpio_bank(PORT_H)] = 0xFFFF;
 # endif
 #endif
 
-- 
1.5.1.2
