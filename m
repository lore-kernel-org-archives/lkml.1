Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab0BHVkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 16:40:43 -0500
Received: from p01c12o148.mxlogic.net ([208.65.145.71]:41864 "EHLO
	p01c12o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab0BHVkm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 16:40:42 -0500
X-MXL-Hash: 4b7084b6414b0931-806a07f76cb9b75e462e84fb531534a61b06f10b
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH 2.6.33 3/3] net: Makefile change for KSZ884X driver
Date: Mon, 8 Feb 2010 13:40:04 -0800
Message-ID: <14385191E87B904DBD836449AA30269D021A58@MORGANITE.micrel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.33 3/3] net: Makefile change for KSZ884X driver
Thread-Index: AcqpB0Zd+4RLvooBRo294+Z8Uxl3ug==
From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
To: "Dave Miller" <davem@davemloft.net>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 Feb 2010 21:40:04.0648 (UTC) FILETIME=[46853280:01CAA907]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010011101)]
X-MAIL-FROM: <tristram.ha@micrel.com>
X-SOURCE-IP: [65.218.208.2]
X-AnalysisOut: [v=1.0 c=1 a=KJY2SdwSdPIA:10 a=J3BOMSfJb05aRia9DmE+FQ==:17 ]
X-AnalysisOut: [a=Q4n7fi2PAAAA:8 a=cOmUgS1p8QT4h099ImMA:9 a=dJQiKqarB2VOBZ]
X-AnalysisOut: [CoSaiqe_Qi-zEA:4 a=yJsD6ztlz_8A:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tristram Ha <Tristram.Ha@micrel.com>

Add Micrel KSZ884X network driver for KSZ8841/KSZ8842 PCI Ethernet chips.

Signed-off-by: Tristram Ha <Tristram.Ha@micrel.com>
---
This is a resubmission of the Micrel KSZ8841/2 PCI Ethernet driver.

--- linux-2.6.33-rc3.old/drivers/net/Makefile	2010-01-05 16:02:46.000000000 -0800
+++ linux-2.6.33-rc3.new/drivers/net/Makefile	2010-01-12 18:56:37.000000000 -0800
@@ -95,6 +95,7 @@ obj-$(CONFIG_SKFP) += skfp/
 obj-$(CONFIG_KS8842)	+= ks8842.o
 obj-$(CONFIG_KS8851)	+= ks8851.o
 obj-$(CONFIG_KS8851_MLL)	+= ks8851_mll.o
+obj-$(CONFIG_KSZ884X_PCI)	+= ksz884x.o
 obj-$(CONFIG_VIA_RHINE) += via-rhine.o
 obj-$(CONFIG_VIA_VELOCITY) += via-velocity.o
 obj-$(CONFIG_ADAPTEC_STARFIRE) += starfire.o
