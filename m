Return-Path: <linux-kernel-owner+w=401wt.eu-S1762250AbXGYMJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762250AbXGYMJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763204AbXGYMIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:08:38 -0400
Received: from rex.snapgear.com ([203.143.235.140]:33037 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762943AbXGYMIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:08:35 -0400
Date: Wed, 25 Jul 2007 22:07:20 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707251207.l6PC7Ktn032170@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: add build support for more Arcturus boards
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add build support for the new Arcturus boards.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.22/arch/m68knommu/Makefile linux-2.6.22-uc0/arch/m68knommu/Makefile
--- linux-2.6.22/arch/m68knommu/Makefile	2007-07-12 15:23:02.000000000 +1000
+++ linux-2.6.22-uc0/arch/m68knommu/Makefile	2007-07-12 15:27:04.000000000 +1000
@@ -26,6 +26,8 @@
 PLATFORM := $(platform-y)
 
 board-$(CONFIG_PILOT)		:= pilot
+board-$(CONFIG_UC5272)          := UC5272
+board-$(CONFIG_UC5282)          := UC5282
 board-$(CONFIG_UCSIMM)		:= ucsimm
 board-$(CONFIG_UCDIMM)		:= ucdimm
 board-$(CONFIG_UCQUICC)		:= uCquicc
