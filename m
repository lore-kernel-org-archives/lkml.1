Return-Path: <linux-kernel-owner+w=401wt.eu-S1765938AbXH0Vk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765938AbXH0Vk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763165AbXH0V3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:29:23 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58867 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764481AbXH0V3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:29:22 -0400
Date: Mon, 27 Aug 2007 23:29:21 +0200
From: Adrian Bunk <bunk@kernel.org>
To: rmk@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] omap1/leds-innovator.c: remove dead code
Message-ID: <20070827212921.GG26410@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes dead code.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
327cae41c436186c6c480b0b8d5f125ab26b6b7c 
diff --git a/arch/arm/mach-omap1/leds-innovator.c b/arch/arm/mach-omap1/leds-innovator.c
index a0cd001..e7835d6 100644
--- a/arch/arm/mach-omap1/leds-innovator.c
+++ b/arch/arm/mach-omap1/leds-innovator.c
@@ -95,8 +95,5 @@ void innovator_leds_event(led_event_t evt)
 		break;
 	}
 
-	if (led_state & LED_STATE_ENABLED)
-		;
-
 	local_irq_restore(flags);
 }

