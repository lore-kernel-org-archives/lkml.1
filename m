Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968000Ab0B0It2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 03:49:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:34050 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967981Ab0B0It0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 03:49:26 -0500
Subject: [PATCH] ARM: includecheck fix for mach-at91/board-sam9m10g45ek.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Feb 2010 14:17:30 +0530
Message-Id: <1267260450.26906.9.camel@i7.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the following 'make includecheck' warning:
  arch/arm/mach-at91/board-sam9m10g45ek.c: mach/hardware.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/mach-at91/board-sam9m10g45ek.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index 98f9f4b..f2ba9e2 100644
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
1.6.6


