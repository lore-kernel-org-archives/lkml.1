Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbYCKJK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbYCKJK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 05:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYCKJKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 05:10:11 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:60934 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYCKJKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 05:10:10 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org, akpm@linux-foundation.org,
       galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 02/17] Add RapidIO option to kernel configuration.
Date: Tue, 11 Mar 2008 17:07:43 +0800
Message-Id: <1205226478-7641-2-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1205226478-7641-1-git-send-email-wei.zhang@freescale.com>
References: <1205226478-7641-1-git-send-email-wei.zhang@freescale.com>
X-OriginalArrivalTime: 11 Mar 2008 09:09:59.0914 (UTC) FILETIME=[AEDC84A0:01C88357]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 arch/powerpc/Kconfig                |   13 +++++++++++++
 arch/powerpc/platforms/86xx/Kconfig |    1 +
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 1189d8d..88f8b6c 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -560,6 +560,19 @@ source "drivers/pcmcia/Kconfig"
 
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
1.5.4

