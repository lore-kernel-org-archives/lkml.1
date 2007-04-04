Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbXDDShd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbXDDShd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbXDDSH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:07:59 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:36606 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbXDDSHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:07:50 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Vasut <marek.vasut@gmail.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 23/90] ARM: OMAP: PalmZ71 extra brace fix
Date: Wed,  4 Apr 2007 14:05:02 -0400
Message-Id: <11757100242980-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757100214151-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Vasut <marek.vasut@gmail.com>

There is one extra brace in z71 board file, this patch fixes it.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-palmz71.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap1/board-palmz71.c b/arch/arm/mach-omap1/board-palmz71.c
index d02eb34..5d73e8c 100644
--- a/arch/arm/mach-omap1/board-palmz71.c
+++ b/arch/arm/mach-omap1/board-palmz71.c
@@ -251,7 +251,7 @@ static const struct ads7846_platform_data palmz71_ts_info = {
 	.get_pendown_state	= palmz71_get_pendown_state,
 };
 
-static struct spi_board_info __initdata palmz71_boardinfo[] = { {
+static struct spi_board_info __initdata palmz71_boardinfo[] = {
 {
 	/* MicroWire (bus 2) CS0 has an ads7846e */
 	.modalias	= "ads7846",
-- 
1.4.4.2

