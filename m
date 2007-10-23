Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbXJWEkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbXJWEkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 00:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbXJWEi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 00:38:57 -0400
Received: from rex.snapgear.com ([203.143.235.140]:58875 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751926AbXJWEiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 00:38:55 -0400
Date: Tue, 23 Oct 2007 14:37:54 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710230437.l9N4bscE001790@goober>
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
