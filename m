Return-Path: <linux-kernel-owner+w=401wt.eu-S1751804AbXCEBsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbXCEBsk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbXCEBrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:47:53 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:49910 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751831AbXCEBrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:47:37 -0500
Date: Mon, 5 Mar 2007 02:47:38 +0100
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] i386/x86_64 early_printk.c: make simnow_init() static
Message-ID: <20070305014738.GQ3441@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global simnow_init() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc2-mm1/arch/x86_64/kernel/early_printk.c.old	2007-03-04 20:25:46.000000000 +0100
+++ linux-2.6.21-rc2-mm1/arch/x86_64/kernel/early_printk.c	2007-03-04 20:26:08.000000000 +0100
@@ -176,7 +176,7 @@
 	return ret;
 }
 
-void __init simnow_init(char *str)
+static void __init simnow_init(char *str)
 {
 	char *fn = "klog";
 	if (*str == '=')

