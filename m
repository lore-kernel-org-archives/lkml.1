Return-Path: <linux-kernel-owner+w=401wt.eu-S1760275AbXGYMKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbXGYMKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763318AbXGYMIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:08:40 -0400
Received: from rex.snapgear.com ([203.143.235.140]:33038 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762969AbXGYMIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:08:36 -0400
Date: Wed, 25 Jul 2007 22:07:20 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707251207.l6PC7Kxr032166@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: add configure support for more Arcturus boards
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Wu <davidwu@arcturusnetworks.com>

Add configure support for the Arcturus UC5272 and UC5282 boards.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naur linux-2.6.22/arch/m68knommu/Kconfig linux-2.6.22-uc0/arch/m68knommu/Kconfig
--- linux-2.6.22/arch/m68knommu/Kconfig	2007-07-12 15:23:02.000000000 +1000
+++ linux-2.6.22-uc0/arch/m68knommu/Kconfig	2007-07-12 15:27:03.000000000 +1000
@@ -212,6 +216,18 @@
 	help
 	  Support the bugs of Xcopilot.
 
+config UC5272
+        bool 'Arcturus Networks uC5272 dimm board support'
+        depends on M5272
+        help
+          Support for the Arcturus Networks uC5272 dimm board.
+
+config UC5282
+       bool "Arcturus Networks uC5282 board support"
+          depends on M528x
+       help
+          Support for the Arcturus Networks uC5282 dimm board.
+
 config UCSIMM
 	bool "uCsimm module support"
 	depends on M68EZ328
