Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbZKIS4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbZKIS4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 13:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZKIS4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 13:56:39 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:51695 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752157AbZKIS4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 13:56:39 -0500
Date: Mon, 9 Nov 2009 18:56:44 +0000
To: linux-kernel@vger.kernel.org
Cc: Kumar Gala <galak@kernel.crashing.org>,
       Len Sorensen <lsorense@csclub.uwaterloo.ca>, netdev@vger.kernel.org
Subject: Fix syntax of mdio.txt to match actual syntax.
Message-ID: <20091109185644.GA15159@caffeine.csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The syntax in Documentation/powerpc/dts-bindings/gpio/mdio.txt is not
up to date and no longer works.  Fix this as well as actually show how
to represent a PHY on the gpio-bitbang bus.

Tested with 2.6.31 on a RuggedCom RX5000 (mpc8360e based).

Signed-off-by: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>

diff --git a/Documentation/powerpc/dts-bindings/gpio/mdio.txt b/Documentation/powerpc/dts-bindings/gpio/mdio.txt
index bc95495..7a84f25 100644
--- a/Documentation/powerpc/dts-bindings/gpio/mdio.txt
+++ b/Documentation/powerpc/dts-bindings/gpio/mdio.txt
@@ -14,6 +14,15 @@ mdio {
 	compatible = "virtual,mdio-gpio";
 	#address-cells = <1>;
 	#size-cells = <0>;
-	gpios = <&qe_pio_a 11
-		 &qe_pio_c 6>;
+	gpios = <&qe_pio_a 11 0
+		 &qe_pio_c 6 0>;
+
+	phy0: ethernet-phy@00 {
+		reg = <0x18>;
+		device_type = "ethernet-phy";
+	};
+	phy1: ethernet-phy@01 {
+		reg = <0x0f>;
+		device_type = "ethernet-phy";
+	};
 };
