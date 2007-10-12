Return-Path: <linux-kernel-owner+w=401wt.eu-S934473AbXJLXJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934473AbXJLXJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 19:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760328AbXJLW0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:26:49 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:43447 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757773AbXJLW0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:26:48 -0400
From: Sebastian Siewior <sebastian@breakpoint.cc>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus@drzeus.cx>
Date: Sat, 13 Oct 2007 00:25:15 +0200
Subject: [PATCH] [mmc] fix compile without LED Triggers
Message-Id: <E1IgSxy-0003pj-Ik@Chamillionaire.breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/mmc/core/host.c: In function 'mmc_remove_host':
drivers/mmc/core/host.c:146: error: implicit declaration of function 'led_trigger_unregister'
drivers/mmc/core/host.c:146: error: 'struct mmc_host' has no member named 'led'

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 include/linux/leds.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/leds.h b/include/linux/leds.h
index dc1178f..24c4830 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -98,6 +98,7 @@ extern void led_trigger_event(struct led_trigger *trigger,
 #define DEFINE_LED_TRIGGER_GLOBAL(x)
 #define led_trigger_register_simple(x, y) do {} while(0)
 #define led_trigger_unregister_simple(x) do {} while(0)
+#define led_trigger_unregister(x) do {} while(0)
 #define led_trigger_event(x, y) do {} while(0)
 
 #endif
-- 
1.5.3.4

