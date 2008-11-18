Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbYKRWOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbYKRWOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 17:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbYKRWNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 17:13:07 -0500
Received: from zbr.yandex.ru ([213.180.219.33]:34072 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752701AbYKRWND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 17:13:03 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH] pcm037: add 1wire support
Date: Wed, 19 Nov 2008 01:16:17 +0300
Message-Id: <12270465774152-git-send-email-zbr@ioremap.net>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <1227046577789-git-send-email-zbr@ioremap.net>
References: <1227046577988-git-send-email-zbr@ioremap.net>
 <1227046577498-git-send-email-zbr@ioremap.net>
 <12270465772346-git-send-email-zbr@ioremap.net>
 <1227046577789-git-send-email-zbr@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 arch/arm/mach-mx3/pcm037.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mx3/pcm037.c b/arch/arm/mach-mx3/pcm037.c
index 843f68c..8cd1fdf 100644
--- a/arch/arm/mach-mx3/pcm037.c
+++ b/arch/arm/mach-mx3/pcm037.c
@@ -81,6 +81,9 @@ static void __init mxc_board_init(void)
 	mxc_iomux_mode(MX31_PIN_CSPI3_MISO__TXD3);
 
 	mxc_register_device(&mxc_uart_device2, &uart_pdata);
+
+	mxc_iomux_mode(MX31_PIN_BATT_LINE__OWIRE);
+	mxc_register_device(&mxc_w1_master_device, NULL);
 }
 
 /*
-- 
1.5.2.5

