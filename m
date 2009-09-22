Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbZIVMvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbZIVMvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 08:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbZIVMvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 08:51:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:53105 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756250AbZIVMvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 08:51:05 -0400
Subject: [PATCH] ARM: includecheck fix: mach-bcmring, core.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>, Leo Chen <leochen@broadcom.com>,
       Scott Branden <sbranden@broadcom.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 18:21:01 +0530
Message-Id: <1253623861.3784.4.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/arm/mach-bcmring/core.c: linux/amba/bus.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/arm/mach-bcmring/core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-bcmring/core.c b/arch/arm/mach-bcmring/core.c
index 492c649..d3bf29b 100644
--- a/arch/arm/mach-bcmring/core.c
+++ b/arch/arm/mach-bcmring/core.c
@@ -31,7 +31,6 @@
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
 
-#include <linux/amba/bus.h>
 #include <mach/csp/mm_addr.h>
 #include <mach/hardware.h>
 #include <asm/clkdev.h>
-- 
1.6.0.6


