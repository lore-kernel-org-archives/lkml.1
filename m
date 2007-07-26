Return-Path: <linux-kernel-owner+w=401wt.eu-S932665AbXGZIfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665AbXGZIfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 04:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbXGZIes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 04:34:48 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:38946 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880AbXGZIep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 04:34:45 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: galak@kernel.crashing.org, mporter@kernel.crashing.org, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 2/5 v3] Add RapidIO OF-node to the MPC8641HPCN board dts file.
Date: Thu, 26 Jul 2007 16:42:49 +0800
Message-Id: <11854393741899-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.1
In-Reply-To: <11854393733580-git-send-email-wei.zhang@freescale.com>
References: <11854393721520-git-send-email-wei.zhang@freescale.com> <11854393733580-git-send-email-wei.zhang@freescale.com>
X-OriginalArrivalTime: 26 Jul 2007 08:34:40.0797 (UTC) FILETIME=[CF2C2CD0:01C7CF5F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add RapidIO OF-node to the MPC8641HPCN board dts file.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 arch/powerpc/boot/dts/mpc8641_hpcn.dts |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/boot/dts/mpc8641_hpcn.dts b/arch/powerpc/boot/dts/mpc8641_hpcn.dts
index 5d82709..080ba8a 100644
--- a/arch/powerpc/boot/dts/mpc8641_hpcn.dts
+++ b/arch/powerpc/boot/dts/mpc8641_hpcn.dts
@@ -422,6 +422,19 @@
 				>;
 		};
 
+		rapidio@c0000 {
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

