Return-Path: <linux-kernel-owner+w=401wt.eu-S1752940AbXDIVkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbXDIVkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030283AbXDIVbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:31:50 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:33182 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966017AbXDIVbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:31:21 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Juha Yrjola <juha.yrjola@solidboot.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3/18] ARM: OMAP: Enable serial idling and wakeup features
Date: Mon,  9 Apr 2007 17:30:46 -0400
Message-Id: <11761542712251-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761542683139-git-send-email-tony@atomide.com>
References: <1176154261668-git-send-email-tony@atomide.com> <11761542642563-git-send-email-tony@atomide.com> <11761542683139-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juha Yrjola <juha.yrjola@solidboot.com>

Enable serial idling and wakeup features

Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/serial.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

--- a/arch/arm/mach-omap2/serial.c
+++ b/arch/arm/mach-omap2/serial.c
@@ -84,7 +84,7 @@ static inline void __init omap_serial_reset(struct plat_serial8250_port *p)
 	serial_write_reg(p, UART_OMAP_MDR1, 0x07);
 	serial_write_reg(p, UART_OMAP_SCR, 0x08);
 	serial_write_reg(p, UART_OMAP_MDR1, 0x00);
-	serial_write_reg(p, UART_OMAP_SYSC, 0x01);
+	serial_write_reg(p, UART_OMAP_SYSC, (0x02 << 3) | (1 << 2) | (1 << 0));
 }
 
 void __init omap_serial_init()
-- 
1.4.4.2

