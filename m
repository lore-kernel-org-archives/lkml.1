Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbXF0I24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbXF0I24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 04:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbXF0I2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 04:28:34 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:33345 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbXF0I2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 04:28:33 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       galak@kernel.crashing.org, Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 2/5 v2] Add RapidIO sector to the MPC8641HPCN board dts file.
Date: Wed, 27 Jun 2007 16:35:45 +0800
Message-Id: <11829333481375-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.1
In-Reply-To: <11829333481977-git-send-email-wei.zhang@freescale.com>
References: <11829333481420-git-send-email-wei.zhang@freescale.com> <11829333481977-git-send-email-wei.zhang@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add RapidIO sector to the MPC8641HPCN board dts file.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 arch/powerpc/boot/dts/mpc8641_hpcn.dts |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/boot/dts/mpc8641_hpcn.dts b/arch/powerpc/boot/dts/mpc8641_hpcn.dts
index 04626b1..abc9ff3 100644
--- a/arch/powerpc/boot/dts/mpc8641_hpcn.dts
+++ b/arch/powerpc/boot/dts/mpc8641_hpcn.dts
@@ -329,6 +329,19 @@
 				>;
 		};
 
+		srio@c0000 {
+			compatible = "fsl,rapidio-delta";
+			#address-cells = <2>;
+			#size-cells = <2>;
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

