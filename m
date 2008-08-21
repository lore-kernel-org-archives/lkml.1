Return-Path: <linux-kernel-owner+w=401wt.eu-S1759233AbYHUD0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233AbYHUD0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 23:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756930AbYHUDQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 23:16:45 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:50118 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500AbYHUDQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 23:16:08 -0400
Date: Wed, 20 Aug 2008 20:50:36 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808210250.m7L2oaaQ028343@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc4 21/27] mdb: export __kernel_text_address 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export __kernel_text_address 


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/kernel/extable.c	2008-07-13 15:51:29.000000000 -0600
+++ b/kernel/extable.c	2008-08-18 23:40:26.000000000 -0600
@@ -59,6 +59,7 @@
 		return 1;
 	return __module_text_address(addr) != NULL;
 }
+EXPORT_SYMBOL_GPL(__kernel_text_address);
 
 int kernel_text_address(unsigned long addr)
 {
