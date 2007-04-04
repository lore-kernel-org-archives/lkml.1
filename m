Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbXDDSJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbXDDSJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbXDDSI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:08:57 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:37185 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbXDDSIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:08:53 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>
Subject: [PATCH 34/90] ARM: OMAP: Set keypad sense delays for the Palms
Date: Wed,  4 Apr 2007 14:05:13 -0400
Message-Id: <11757100623383-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1175710059333-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrzej Zaborowski <balrog@zabor.org>

Wait a fixed amount of time between writing to the columns
register and reading rows state to allow the keypad to respond
on Palm Tungsten E and Zire 71.  The value for Zire 71 keypad
was tested by Marek Vasut.

Signed-off-by: Andrzej Zaborowski <balrog@zabor.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-palmz71.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap1/board-palmz71.c b/arch/arm/mach-omap1/board-palmz71.c
index 786142b..54abbaa 100644
--- a/arch/arm/mach-omap1/board-palmz71.c
+++ b/arch/arm/mach-omap1/board-palmz71.c
@@ -76,6 +76,7 @@ static struct omap_kp_platform_data palmz71_kp_data = {
 	.cols	= 8,
 	.keymap	= palmz71_keymap,
 	.rep	= 1,
+	.delay	= 80,
 };
 
 static struct resource palmz71_kp_resources[] = {
-- 
1.4.4.2

