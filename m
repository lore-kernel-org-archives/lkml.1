Return-Path: <linux-kernel-owner+w=401wt.eu-S1751622AbZBFHM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbZBFHM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbZBFHLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:11:20 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:1470 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbZBFHLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:11:18 -0500
X-IronPort-AV: E=Sophos;i="4.37,390,1231131600"; 
   d="scan'208";a="82422008"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, akpm@linux-foundation.org
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 03/20] Blackfin SPI Driver: remove useless <asm/cplbinit.h>
Date: Fri,  6 Feb 2009 15:12:51 +0800
Message-Id: <1233904388-5765-4-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
References: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

We already moved bfin_addr_dcachable() and friends into the cacheflush
header where it belongs, so don't need to include <asm/cplbinit.h> here.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/spi/spi_bfin5xx.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index f2e18f7..1e046b1 100644
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
