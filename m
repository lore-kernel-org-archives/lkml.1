Return-Path: <linux-kernel-owner+w=401wt.eu-S1762802AbXEUKL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762802AbXEUKL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761520AbXEUKJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:21 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:5145 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757273AbXEUKJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:12 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="30505446:sNHT21301448"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 21/32] Blackfin arch: dont clear the bit that tells coreb to start booting
Date: Mon, 21 May 2007 18:09:29 +0800
Message-Id: <11797421861323-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mach-bf561/head.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/mach-bf561/head.S b/arch/blackfin/mach-bf561/head.S
index 9c8e688..ad9187a 100644
--- a/arch/blackfin/mach-bf561/head.S
+++ b/arch/blackfin/mach-bf561/head.S
@@ -431,7 +431,7 @@ ENTRY(_bfin_reset)
 	/* make sure SYSCR is set to use BMODE */
 	P0.h = hi(SICA_SYSCR);
 	P0.l = lo(SICA_SYSCR);
-	R0.l = 0x0;
+	R0.l = 0x20;
 	W[P0] = R0.l;
 	SSYNC;
 
-- 
1.5.1.2
