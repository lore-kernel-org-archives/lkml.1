Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbYCKJMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbYCKJMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 05:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYCKJKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 05:10:22 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:61142 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbYCKJKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 05:10:20 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org, akpm@linux-foundation.org,
       galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 07/17] Add RapidIO node into MPC8641HPCN dts file
Date: Tue, 11 Mar 2008 17:07:48 +0800
Message-Id: <1205226478-7641-7-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1205226478-7641-6-git-send-email-wei.zhang@freescale.com>
References: <1205226478-7641-1-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-2-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-3-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-4-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-5-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-6-git-send-email-wei.zhang@freescale.com>
X-OriginalArrivalTime: 11 Mar 2008 09:10:01.0117 (UTC) FILETIME=[AF9414D0:01C88357]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 arch/powerpc/boot/dts/mpc8641_hpcn.dts |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/boot/dts/mpc8641_hpcn.dts b/arch/powerpc/boot/dts/mpc8641_hpcn.dts
index 79385bc..4b296af 100644
--- a/arch/powerpc/boot/dts/mpc8641_hpcn.dts
+++ b/arch/powerpc/boot/dts/mpc8641_hpcn.dts
@@ -26,6 +26,7 @@
 		serial1 = &serial1;
 		pci0 = &pci0;
 		pci1 = &pci1;
+		rapidio0 = &rapidio0;
 	};
 
 	cpus {
@@ -500,4 +501,15 @@
 				  0x0 0x00100000>;
 		};
 	};
+	rapidio0: rapidio@f80c0000 {
+		#address-cells = <2>;
+		#size-cells = <2>;
+		compatible = "fsl,rapidio-delta";
+		reg = <0xf80c0000 0x20000>;
+		ranges = <0 0 0xc0000000 0 0x20000000>;
+		interrupt-parent = <&mpic>;
+		/* err_irq bell_outb_irq bell_inb_irq
+			msg1_tx_irq msg1_rx_irq	msg2_tx_irq msg2_rx_irq */
+		interrupts = <48 2 49 2 50 2 53 2 54 2 55 2 56 2>;
+	};
 };
-- 
1.5.4

