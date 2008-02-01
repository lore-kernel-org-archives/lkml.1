Return-Path: <linux-kernel-owner+w=401wt.eu-S936016AbYBAHtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936016AbYBAHtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935302AbYBAHlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:41:17 -0500
Received: from rex.snapgear.com ([203.143.235.140]:48108 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935098AbYBAHlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:41:14 -0500
Date: Fri, 1 Feb 2008 17:40:30 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010740.m117eUku022785@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU 04/07]: set config to use GENERIC_TIME
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch m68knommu arch to using GENERIC_TIME.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.24/arch/m68knommu/Kconfig linux-2.6.24-uc0/arch/m68knommu/Kconfig
--- linux-2.6.24/arch/m68knommu/Kconfig	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24-uc0/arch/m68knommu/Kconfig	2008-01-25 14:32:36.000000000 +1000
@@ -53,6 +53,10 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
+config GENERIC_TIME
+	bool
+	default y
+
 config TIME_LOW_RES
 	bool
 	default y
