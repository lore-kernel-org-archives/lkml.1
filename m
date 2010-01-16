Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825Ab0APDH2 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 22:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758527Ab0APDH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 22:07:26 -0500
Received: from p01c11o141.mxlogic.net ([208.65.144.64]:42560 "EHLO
	p01c11o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab0APDHZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 22:07:25 -0500
X-MXL-Hash: 4b512d6d229052d8-790386e9a66c8f011c5cadcad4df4b51da73ca94
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH 2.6.33 3/3] net: Makefile change for Micrel KSZ884X driver
Date: Fri, 15 Jan 2010 19:07:24 -0800
Message-ID: <14385191E87B904DBD836449AA30269D021A4C@MORGANITE.micrel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.33 3/3] net: Makefile change for Micrel KSZ884X driver
Thread-Index: AcqWWQaXJjIFdbOsRIuz1Odw6wfFwQ==
From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
To: "Dave Miller" <davem@davemloft.net>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Jan 2010 03:07:24.0025 (UTC) FILETIME=[06964E90:01CA9659]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010011101)]
X-MAIL-FROM: <tristram.ha@micrel.com>
X-SOURCE-IP: [65.218.208.2]
X-AnalysisOut: [v=1.0 c=1 a=zvxfC-iS3ooA:10 a=J3BOMSfJb05aRia9DmE+FQ==:17 ]
X-AnalysisOut: [a=Q4n7fi2PAAAA:8 a=cOmUgS1p8QT4h099ImMA:9 a=fV6M1bscOJUOtX]
X-AnalysisOut: [ZrVe7lwkF0rZAA:4 a=yJsD6ztlz_8A:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tristram Ha <Tristram.Ha@micrel.com>

Add Micrel KSZ884X network driver for KSZ8841/KSZ8842 PCI Ethernet chips.

Signed-off-by: Tristram Ha <Tristram.Ha@micrel.com>
---
diff -uprN linux-2.6.33-rc3.old/drivers/net/Makefile linux-2.6.33-rc3.new/drivers/net/Makefile
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
