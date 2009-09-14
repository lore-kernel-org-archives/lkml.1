Return-Path: <linux-kernel-owner+w=401wt.eu-S933756AbZINUKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756AbZINUKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933722AbZINUJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:09:29 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54198 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933670AbZINUJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:09:08 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 67/72] Blackfin: increase default async timings for parallel flashes
Date: Mon, 14 Sep 2009 16:08:11 -0400
Message-Id: <1252958896-25150-68-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

The default async timings are a little too fast for the parallel flash
that is attached by default to the async banks.  So slow things down a bit
so accessing the hardware is stable.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/configs/BF518F-EZBRD_defconfig |    4 ++--
 arch/blackfin/configs/BF526-EZBRD_defconfig  |    4 ++--
 arch/blackfin/configs/BF527-EZKIT_defconfig  |    4 ++--
 arch/blackfin/configs/BF548-EZKIT_defconfig  |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/blackfin/configs/BF518F-EZBRD_defconfig b/arch/blackfin/configs/BF518F-EZBRD_defconfig
index dcfb488..9905b26 100644
--- a/arch/blackfin/configs/BF518F-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF518F-EZBRD_defconfig
@@ -358,9 +358,9 @@ CONFIG_C_AMBEN_ALL=y
 # EBIU_AMBCTL Control
 #
 CONFIG_BANK_0=0x7BB0
-CONFIG_BANK_1=0x5554
+CONFIG_BANK_1=0x7BB0
 CONFIG_BANK_2=0x7BB0
-CONFIG_BANK_3=0xFFC0
+CONFIG_BANK_3=0x99B2
 
 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
diff --git a/arch/blackfin/configs/BF526-EZBRD_defconfig b/arch/blackfin/configs/BF526-EZBRD_defconfig
index 48a3a7a..9dc6820 100644
--- a/arch/blackfin/configs/BF526-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF526-EZBRD_defconfig
@@ -359,9 +359,9 @@ CONFIG_C_AMBEN_ALL=y
 # EBIU_AMBCTL Control
 #
 CONFIG_BANK_0=0x7BB0
-CONFIG_BANK_1=0x5554
+CONFIG_BANK_1=0x7BB0
 CONFIG_BANK_2=0x7BB0
-CONFIG_BANK_3=0xFFC0
+CONFIG_BANK_3=0x99B2
 
 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
diff --git a/arch/blackfin/configs/BF527-EZKIT_defconfig b/arch/blackfin/configs/BF527-EZKIT_defconfig
index dd83527..77e35d4 100644
--- a/arch/blackfin/configs/BF527-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT_defconfig
@@ -363,9 +363,9 @@ CONFIG_C_AMBEN_ALL=y
 # EBIU_AMBCTL Control
 #
 CONFIG_BANK_0=0x7BB0
-CONFIG_BANK_1=0x5554
+CONFIG_BANK_1=0x7BB0
 CONFIG_BANK_2=0x7BB0
-CONFIG_BANK_3=0xFFC0
+CONFIG_BANK_3=0x99B2
 
 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
diff --git a/arch/blackfin/configs/BF548-EZKIT_defconfig b/arch/blackfin/configs/BF548-EZKIT_defconfig
index b3d3cab..f773ad1 100644
--- a/arch/blackfin/configs/BF548-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF548-EZKIT_defconfig
@@ -400,7 +400,7 @@ CONFIG_C_AMBEN_ALL=y
 # EBIU_AMBCTL Control
 #
 CONFIG_BANK_0=0x7BB0
-CONFIG_BANK_1=0x5554
+CONFIG_BANK_1=0x7BB0
 CONFIG_BANK_2=0x7BB0
 CONFIG_BANK_3=0x99B2
 CONFIG_EBIU_MBSCTLVAL=0x0
-- 
1.6.4.2

