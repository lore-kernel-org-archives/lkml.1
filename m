Return-Path: <linux-kernel-owner+w=401wt.eu-S1752249AbYKRHLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbYKRHLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYKRHLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:11:15 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:46581 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbYKRHLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:11:14 -0500
X-IronPort-AV: E=Sophos;i="4.33,623,1220241600"; 
   d="scan'208";a="62688726"
From: Bryan Wu <cooloney@kernel.org>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] Parport driver: disable pc-style parport on Blackfin systems
Date: Tue, 18 Nov 2008 15:12:42 +0800
Message-Id: <1226992362-30928-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/parport/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/parport/Kconfig b/drivers/parport/Kconfig
index 209b4a4..855f389 100644
--- a/drivers/parport/Kconfig
+++ b/drivers/parport/Kconfig
@@ -36,7 +36,7 @@ if PARPORT
 config PARPORT_PC
 	tristate "PC-style hardware"
 	depends on (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV && \
-		(!M68K || ISA) && !MN10300 && !AVR32
+		(!M68K || ISA) && !MN10300 && !AVR32 && !BLACKFIN
 	---help---
 	  You should say Y here if you have a PC-style parallel port. All
 	  IBM PC compatible computers and some Alphas have PC-style
-- 
1.5.6.3
