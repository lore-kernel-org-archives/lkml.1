Return-Path: <linux-kernel-owner+w=401wt.eu-S1751940AbYKRHwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbYKRHwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbYKRHvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:51:25 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:43724 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYKRHvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:51:23 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62690390"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 03/16] Blackfin SPI Driver: move bfin_addr_dcachable() and friends into the cacheflush header where it belongs
Date: Tue, 18 Nov 2008 15:52:27 +0800
Message-Id: <1226994760-4301-4-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index a38106a..6c5671e 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -25,9 +25,6 @@
 #include <asm/dma.h>
 #include <asm/portmux.h>
 #include <asm/bfin5xx_spi.h>
-
-/* reserved_mem_dcache_on and cache friends */
-#include <asm/cplbinit.h>
 #include <asm/cacheflush.h>
 
 #define DRV_NAME	"bfin-spi"
-- 
1.5.6.3
