Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbYGOI4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbYGOI4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 04:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbYGOIz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 04:55:56 -0400
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:39472 "EHLO
	young-lust.wild-wind.fr.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755047AbYGOIz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:55:56 -0400
Message-ID: <487C664A.2020606@misterjones.org>
Date: Tue, 15 Jul 2008 10:56:42 +0200
From: Marc Zyngier <maz@misterjones.org>
Organization: Metropolis -- Nowhere
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Oleg Drokin <green@crimea.edu>, wim@iguana.be
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Compile fix for sa1100_wdt
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 81.255.32.141
X-SA-Exim-Rcpt-To: green@crimea.edu, wim@iguana.be, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on young-lust.wild-wind.fr.eu.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg, Wim,

The enclosed patch, against Linus GIT tree (as of 10 minutes ago...),
fixes sa1100_wdt.c compilation by adding missing include.

Regards,

	M.

Signed-off-by: Marc Zyngier <marc.zyngier@altran.com>

diff --git a/drivers/watchdog/sa1100_wdt.c b/drivers/watchdog/sa1100_wdt.c
index 34a2b3b..40b724d 100644
--- a/drivers/watchdog/sa1100_wdt.c
+++ b/drivers/watchdog/sa1100_wdt.c
@@ -29,6 +29,7 @@

  #ifdef CONFIG_ARCH_PXA
  #include <asm/arch/pxa-regs.h>
+#include <asm/arch/pxa2xx-regs.h>
  #endif

  #include <asm/hardware.h>
-- 
A rat a day keeps the plague away.
