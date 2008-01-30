Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbYA3KU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbYA3KU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 05:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbYA3KUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 05:20:20 -0500
Received: from de01egw02.freescale.net ([192.88.165.103]:58406 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbYA3KUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 05:20:18 -0500
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org, galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 2/6] Add RapidIO option to kernel configuration.
Date: Wed, 30 Jan 2008 18:30:49 +0800
Message-Id: <12016890621727-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <1201689053956-git-send-email-wei.zhang@freescale.com>
References: <1201689053956-git-send-email-wei.zhang@freescale.com>
X-OriginalArrivalTime: 30 Jan 2008 10:20:12.0674 (UTC) FILETIME=[B2ECEE20:01C86329]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 arch/powerpc/Kconfig                |   13 +++++++++++++
 arch/powerpc/platforms/86xx/Kconfig |    1 +
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 47fe256..ad07964 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -535,6 +535,19 @@ source "drivers/pcmcia/Kconfig"
 
 source "drivers/pci/hotplug/Kconfig"
 
+config HAS_RAPIDIO
+	bool
+	default n
+
+config RAPIDIO
+	bool "RapidIO support"
+	depends on HAS_RAPIDIO
+	help
+	  If you say Y here, the kernel will include drivers and
+	  infrastructure code to support RapidIO interconnect devices.
+
+source "drivers/rapidio/Kconfig"
+
 endmenu
 
 menu "Advanced setup"
diff --git a/arch/powerpc/platforms/86xx/Kconfig b/arch/powerpc/platforms/86xx/Kconfig
index 21d1135..8c7c5ff 100644
--- a/arch/powerpc/platforms/86xx/Kconfig
+++ b/arch/powerpc/platforms/86xx/Kconfig
@@ -8,6 +8,7 @@ config MPC8641_HPCN
 	select PPC_I8259
 	select DEFAULT_UIMAGE
 	select FSL_ULI1575
+	select HAS_RAPIDIO
 	help
 	  This option enables support for the MPC8641 HPCN board.
 
-- 
1.5.2

