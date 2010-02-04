Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab0BDXYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 18:24:39 -0500
Received: from p01c11o144.mxlogic.net ([208.65.144.67]:38783 "EHLO
	p01c11o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498Ab0BDXYh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 18:24:37 -0500
X-MXL-Hash: 4b6b573567334582-c6aec2efd8f5691d1ae46678825a785c61e0b617
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH 2.6.33 2/4] net: Kconfig change for KSZ884X driver
Date: Thu, 4 Feb 2010 15:24:36 -0800
Message-ID: <14385191E87B904DBD836449AA30269D021A53@MORGANITE.micrel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.33 2/4] net: Kconfig change for KSZ884X driver
Thread-Index: Acql8TchOSOvlhbiQsCmxtHrLR+1rg==
From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
To: "Dave Miller" <davem@davemloft.net>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 04 Feb 2010 23:24:36.0477 (UTC) FILETIME=[372B5AD0:01CAA5F1]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010011101)]
X-MAIL-FROM: <tristram.ha@micrel.com>
X-SOURCE-IP: [65.218.208.2]
X-AnalysisOut: [v=1.0 c=1 a=8PPP1YHBDycA:10 a=J3BOMSfJb05aRia9DmE+FQ==:17 ]
X-AnalysisOut: [a=Q4n7fi2PAAAA:8 a=gpeGt47jHdT7ORR_t74A:9 a=VootWrtJUJbc0V]
X-AnalysisOut: [vtmLYCbRM12lAA:4 a=yJsD6ztlz_8A:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tristram Ha <Tristram.Ha@micrel.com>

Add Micrel KSZ8841/KSZ8842 PCI Ethernet chip support.

Signed-off-by: Tristram Ha <Tristram.Ha@micrel.com>
---
This is a resubmission of the Micrel KSZ8841/2 PCI Ethernet driver.

--- linux-2.6.33-rc5.old/drivers/net/Kconfig	2010-01-21 15:31:35.000000000 -0800
+++ linux-2.6.33-rc5.new/drivers/net/Kconfig	2010-02-04 12:12:58.000000000 -0800
@@ -1368,6 +1368,17 @@ config AC3200
 	  To compile this driver as a module, choose M here. The module
 	  will be called ac3200.
 
+config KSZ884X_PCI
+	tristate "Micrel KSZ8841/2 PCI"
+	depends on NET_PCI && PCI
+	select MII
+	select CRC32
+	help
+	  This PCI driver is for Micrel KSZ8841/KSZ8842 PCI Ethernet chip.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called ksz884x.
+
 config APRICOT
 	tristate "Apricot Xen-II on board Ethernet"
 	depends on NET_PCI && ISA
