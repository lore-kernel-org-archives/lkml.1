Return-Path: <linux-kernel-owner+w=401wt.eu-S1759948AbZFTSvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbZFTSvE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758396AbZFTSrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:47:32 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48204 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758372AbZFTSrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:47:31 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 23/25] Blackfin: fix GPTMR0_CLOCKSOURCE dependency on BFIN_GPTIMERS
Date: Sat, 20 Jun 2009 14:44:46 -0400
Message-Id: <1245523488-26536-24-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPTMR0_CLOCKSOURCE Kconfig option requires the gptimers framework, so
make sure it is selected when this option is enabled.

Reported-by: Peter Meerwald <pmeerw@pmeerw.net>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 384f7cd..7faa2f5 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -648,6 +648,7 @@ config CYCLES_CLOCKSOURCE
 
 config GPTMR0_CLOCKSOURCE
 	bool "Use GPTimer0 as a clocksource (higher rating)"
+	select BFIN_GPTIMERS
 	depends on GENERIC_CLOCKEVENTS
 	depends on !TICKSOURCE_GPTMR0
 
-- 
1.6.3.1

