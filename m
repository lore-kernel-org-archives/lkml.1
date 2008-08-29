Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbYH2GXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbYH2GXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYH2GQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:16:01 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:59523 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbYH2GPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:15:30 -0400
Date: Thu, 28 Aug 2008 23:47:42 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808290547.m7T5lgGx016138@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc5 23/29] mdb: export __kernel_text_address 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export __kernel_text_address 


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/kernel/extable.c	2008-07-13 15:51:29.000000000 -0600
+++ b/kernel/extable.c	2008-08-28 14:20:04.000000000 -0600
@@ -59,6 +59,7 @@
 		return 1;
 	return __module_text_address(addr) != NULL;
 }
+EXPORT_SYMBOL_GPL(__kernel_text_address);
 
 int kernel_text_address(unsigned long addr)
 {
