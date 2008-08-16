Return-Path: <linux-kernel-owner+w=401wt.eu-S1759876AbYHPENG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759876AbYHPENG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 00:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbYHPEGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 00:06:14 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:33291 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbYHPEFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 00:05:44 -0400
Date: Fri, 15 Aug 2008 21:41:47 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808160341.m7G3flVx022572@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc3 22/28] mdb: fix conditional exports 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export the kernel_text_address() to allow symbol searching and 
matches of symbolic names contained the the kernel symbol table.

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/kernel/extable.c	2008-07-13 15:51:29.000000000 -0600
+++ b/kernel/extable.c	2008-08-15 15:41:57.000000000 -0600
@@ -59,6 +59,7 @@
 		return 1;
 	return __module_text_address(addr) != NULL;
 }
+EXPORT_SYMBOL_GPL(__kernel_text_address);
 
 int kernel_text_address(unsigned long addr)
 {
