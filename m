Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbXDDR7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbXDDR7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbXDDR7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:59:08 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:39696 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbXDDR7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:59:06 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Juha Yrjola <juha.yrjola@solidboot.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 6/90] ARM: OMAP: Enable serial idling and wakeup features
Date: Wed,  4 Apr 2007 13:46:33 -0400
Message-Id: <11757088904153-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757088883638-git-send-email-tony@atomide.com>
References: omap-2007-04-04-133556 <11757088774110-git-send-email-tony@atomide.com> <11757088791107-git-send-email-tony@atomide.com> <11757088822930-git-send-email-tony@atomide.com> <11757088844012-git-send-email-tony@atomide.com> <1175708886798-git-send-email-tony@atomide.com> <11757088883638-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juha Yrjola <juha.yrjola@solidboot.com>

Enable serial idling and wakeup features

Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/serial.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
index aaa5589..e9c367f 100644
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

