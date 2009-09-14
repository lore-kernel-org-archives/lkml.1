Return-Path: <linux-kernel-owner+w=401wt.eu-S933801AbZINUP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801AbZINUP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933573AbZINUPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:15:22 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54133 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933614AbZINUIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:53 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 48/72] Blackfin: SMP port does not yet support cpu frequency scaling
Date: Mon, 14 Sep 2009 16:07:52 -0400
Message-Id: <1252958896-25150-49-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

We have an item to get this fixed, but in the mean time, disable selection
via Kconfig dependencies.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 8d04ed9..6040aad 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -1152,11 +1152,12 @@ source "fs/Kconfig.binfmt"
 endmenu
 
 menu "Power management options"
+	depends on !SMP
+
 source "kernel/power/Kconfig"
 
 config ARCH_SUSPEND_POSSIBLE
 	def_bool y
-	depends on !SMP
 
 choice
 	prompt "Standby Power Saving Mode"
@@ -1244,6 +1245,7 @@ config PM_BFIN_WAKE_GP
 endmenu
 
 menu "CPU Frequency scaling"
+	depends on !SMP
 
 source "drivers/cpufreq/Kconfig"
 
-- 
1.6.4.2

