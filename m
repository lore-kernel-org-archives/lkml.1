Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbYCVDZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbYCVDZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 23:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYCVDZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 23:25:25 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:14840 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbYCVDZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 23:25:24 -0400
Date: Fri, 21 Mar 2008 21:25:15 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] [POWERPC] mpc5200: fix incorrect compatible string for the
 mdio node
In-reply-to: <>
To: linux-kernel@vger.kernel.org, paulus@samba.org, linuxppc-dev@ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Message-id: <1206156315-4734-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.5.4.3
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MDIO node in the lite5200b.dts file needs to also claim compatibility
with the older mpc5200 chip.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
Paul, this one should also go in for .26

 arch/powerpc/boot/dts/lite5200b.dts |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/boot/dts/lite5200b.dts b/arch/powerpc/boot/dts/lite5200b.dts
index 30eaeab..001c955 100644
--- a/arch/powerpc/boot/dts/lite5200b.dts
+++ b/arch/powerpc/boot/dts/lite5200b.dts
@@ -270,7 +270,7 @@
 		mdio@3000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
-			compatible = "fsl,mpc5200b-mdio";
+			compatible = "fsl,mpc5200b-mdio", "fsl,mpc5200-mdio";
 			reg = <0x3000 0x400>;	// fec range, since we need to setup fec interrupts
 			interrupts = <2 5 0>;	// these are for "mii command finished", not link changes & co.
 			interrupt-parent = <&mpc5200_pic>;
-- 
1.5.4.3

