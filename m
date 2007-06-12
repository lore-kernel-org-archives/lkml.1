Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbXFLI4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbXFLI4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 04:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbXFLIzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 04:55:38 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:46599 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785AbXFLIzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 04:55:37 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       galak@kernel.crashing.org, Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 2/5] Add RapidIO sector to MPC8641HPCN board dts file.
Date: Tue, 12 Jun 2007 17:02:17 +0800
Message-Id: <11816389401714-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.1
In-Reply-To: <1181638939310-git-send-email-wei.zhang@freescale.com>
References: <11816389393593-git-send-email-wei.zhang@freescale.com> <1181638939310-git-send-email-wei.zhang@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add RapidIO sector to the MPC8641HPCN board dts file.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 arch/powerpc/boot/dts/mpc8641_hpcn.dts |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/boot/dts/mpc8641_hpcn.dts b/arch/powerpc/boot/dts/mpc8641_hpcn.dts
index 04626b1..e2ce06e 100644
--- a/arch/powerpc/boot/dts/mpc8641_hpcn.dts
+++ b/arch/powerpc/boot/dts/mpc8641_hpcn.dts
@@ -329,6 +329,19 @@
 				>;
 		};
 
+		srio@c0000 {
+			device_type = "rapidio";
+			compatible = "fsl,rapidio-v1.0";
+			#address-cells = <2>;
+			reg = <c0000 20000>;
+			ranges = <0 0 c0000000 20000000>;
+			interrupt-parent = <&mpic>;
+			/* err_irq bell_outb_irq bell_inb_irq
+						msg1_tx_irq msg1_rx_irq
+						msg2_tx_irq msg2_rx_irq */
+			interrupts = <30 2 31 2 32 2 35 2 36 2 37 2 38 2>;
+		};
+
 		mpic: pic@40000 {
 			clock-frequency = <0>;
 			interrupt-controller;
-- 
1.5.1

