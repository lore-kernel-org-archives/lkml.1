Return-Path: <linux-kernel-owner+w=401wt.eu-S1757220AbYCDIb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbYCDIb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYCDIar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:30:47 -0500
Received: from de01egw02.freescale.net ([192.88.165.103]:42704 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbYCDIao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:30:44 -0500
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org, galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 07/17] Add RapidIO node into MPC8641HPCN dts file
Date: Wed,  5 Mar 2008 00:29:52 +0800
Message-Id: <1204648202-5495-7-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1204648202-5495-6-git-send-email-wei.zhang@freescale.com>
References: <1204648202-5495-1-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-2-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-3-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-4-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-5-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-6-git-send-email-wei.zhang@freescale.com>
X-OriginalArrivalTime: 04 Mar 2008 08:30:35.0172 (UTC) FILETIME=[04794640:01C87DD2]
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

