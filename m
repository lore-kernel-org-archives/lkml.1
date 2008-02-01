Return-Path: <linux-kernel-owner+w=401wt.eu-S934991AbYBAHuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934991AbYBAHuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935043AbYBAHlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:41:36 -0500
Received: from rex.snapgear.com ([203.143.235.140]:45232 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935366AbYBAHlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:41:36 -0500
Date: Fri, 1 Feb 2008 17:40:49 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010740.m117enqQ022800@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU 06/07]: remove empty timer offset function for 68360
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switching to GENERIC_TIME means we no longer need the empty timer offset
function for the 68360 CPU.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.24/arch/m68knommu/platform/68360/config.c linux-2.6.24-uc0/arch/m68knommu/platform/68360/config.c
--- linux-2.6.24/arch/m68knommu/platform/68360/config.c	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24-uc0/arch/m68knommu/platform/68360/config.c	2008-01-11 20:33:46.000000000 +1000
@@ -103,11 +103,6 @@ void hw_timer_init(void)
   pquicc->timer_tgcr  = tgcr_save;
 }
 
-unsigned long hw_timer_offset(void)
-{
-  return 0;
-}
-
 void BSP_gettod (int *yearp, int *monp, int *dayp,
 		   int *hourp, int *minp, int *secp)
 {
