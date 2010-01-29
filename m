Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980Ab0A2Wpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab0A2Wpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 17:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384Ab0A2Wpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 17:45:30 -0500
Received: from p01c12o145.mxlogic.net ([208.65.145.68]:47927 "EHLO
	p01c12o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab0A2Wp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 17:45:29 -0500
X-MXL-Hash: 4b636509436f119f-bba217550bb4f6255148a30a3e67a852325e7041
X-MXL-Hash: 4b63645e6ad855ee-8751c3c60cb3b72b19b34692cd15a2649140b4e4
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH 2.6.33 3/4] net: Makefile change for KSZ884X driver
Date: Fri, 29 Jan 2010 14:42:36 -0800
Message-ID: <14385191E87B904DBD836449AA30269D021A4F@MORGANITE.micrel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.33 3/4] net: Makefile change for KSZ884X driver
Thread-Index: AcqhNFrg9zH781DZS4aVdHDT05YD/Q==
From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
To: "Dave Miller" <davem@davemloft.net>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 29 Jan 2010 22:42:37.0114 (UTC) FILETIME=[5B0891A0:01CAA134]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010011101)]
X-MAIL-FROM: <tristram.ha@micrel.com>
X-SOURCE-IP: [65.218.208.2]
X-AnalysisOut: [v=1.0 c=1 a=t5jVkz02HvQA:10 a=J3BOMSfJb05aRia9DmE+FQ==:17 ]
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
