Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbYCZHx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbYCZHx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 03:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbYCZHxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 03:53:42 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:48308 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbYCZHxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 03:53:41 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH] fsldma: The MPC8377MDS board device tree node for fsldma driver
Date: Wed, 26 Mar 2008 15:42:36 +0800
Message-Id: <1206517356-11209-2-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1206517356-11209-1-git-send-email-wei.zhang@freescale.com>
References: <1206517356-11209-1-git-send-email-wei.zhang@freescale.com>
X-OriginalArrivalTime: 26 Mar 2008 07:47:39.0769 (UTC) FILETIME=[AA807690:01C88F15]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fsldma driver is tested on MPC8377MDS board.
The patch adds fsldma driver support into MPC8377MDS device tree.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 arch/powerpc/boot/dts/mpc8377_mds.dts |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/boot/dts/mpc8377_mds.dts b/arch/powerpc/boot/dts/mpc8377_mds.dts
index 49c05e9..ba5312e 100644
--- a/arch/powerpc/boot/dts/mpc8377_mds.dts
+++ b/arch/powerpc/boot/dts/mpc8377_mds.dts
@@ -268,6 +268,33 @@
 			interrupt-parent = <&ipic>;
 		};
 
+		dma@82a8 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "fsl,mpc8349-dma";
+			reg = <0x82a8 4>;
+			ranges = <0 0x8100 0x1a8>;
+			interrupt-parent = <&ipic>;
+			interrupts = <0x47 8>;
+			cell-index = <0>;
+			dma-channel@0 {
+				compatible = "fsl,mpc8349-dma-channel";
+				reg = <0 0x80>;
+			};
+			dma-channel@80 {
+				compatible = "fsl,mpc8349-dma-channel";
+				reg = <0x80 0x80>;
+			};
+			dma-channel@100 {
+				compatible = "fsl,mpc8349-dma-channel";
+				reg = <0x100 0x80>;
+			};
+			dma-channel@180 {
+				compatible = "fsl,mpc8349-dma-channel";
+				reg = <0x180 0x28>;
+			};
+		};
+
 		/* IPIC
 		 * interrupts cell = <intr #, sense>
 		 * sense values match linux IORESOURCE_IRQ_* defines:
-- 
1.5.4

