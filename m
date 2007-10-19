Return-Path: <linux-kernel-owner+w=401wt.eu-S966394AbXJSEb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966394AbXJSEb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 00:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966577AbXJSEa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 00:30:58 -0400
Received: from rex.snapgear.com ([203.143.235.140]:35257 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966579AbXJSEa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 00:30:57 -0400
Date: Fri, 19 Oct 2007 14:30:15 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710190430.l9J4UFrb004909@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: add make support for Savant/Rosie1 board
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wilson Callan <wcallan@savantav.com>

Add make support for the Savant/Rosie1 board.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/arch/m68knommu/Makefile linux-2.6.23-uc0/arch/m68knommu/Makefile
--- linux-2.6.23/arch/m68knommu/Makefile	2007-10-19 10:30:58.000000000 +1000
+++ linux-2.6.23-uc0/arch/m68knommu/Makefile	2007-10-19 10:35:41.000000000 +1000
@@ -48,6 +48,7 @@ board-$(CONFIG_SNEHA) 	        := SNEHA
 board-$(CONFIG_M5208EVB)	:= M5208EVB
 board-$(CONFIG_MOD5272)		:= MOD5272
 board-$(CONFIG_AVNET)           := AVNET
+board-$(CONFIG_SAVANT)		:= SAVANT
 BOARD := $(board-y)
 
 model-$(CONFIG_RAMKERNEL)	:= ram
