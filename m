Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbZIVMsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbZIVMsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 08:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756242AbZIVMsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 08:48:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:52049 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756106AbZIVMsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 08:48:22 -0400
Subject: [PATCH] ARM: includecheck fix: mach-at91, board-sam9m10g45ek.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 18:17:48 +0530
Message-Id: <1253623668.3784.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/arm/mach-at91/board-sam9m10g45ek.c: mach/hardware.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/arm/mach-at91/board-sam9m10g45ek.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index b8558ea..db12393 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -36,7 +36,6 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/hardware.h>
 #include <mach/board.h>
 #include <mach/gpio.h>
 #include <mach/at91sam9_smc.h>
-- 
1.6.0.6


