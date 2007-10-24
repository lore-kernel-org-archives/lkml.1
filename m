Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbXJXCG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbXJXCG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326AbXJXCEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:04:23 -0400
Received: from rex.snapgear.com ([203.143.235.140]:34305 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755246AbXJXCEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:04:22 -0400
Date: Wed, 24 Oct 2007 12:03:41 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710240203.l9O23fZi016665@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: mark setup_arch() as __init
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark the m68knommu setup_arch() function as __init.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naurp linux-2.6.23-git19/arch/m68knommu/kernel/setup.c linux-2.6.23-git19.hacked/arch/m68knommu/kernel/setup.c
--- linux-2.6.23-git19/arch/m68knommu/kernel/setup.c	2007-10-24 11:20:35.000000000 +1000
+++ linux-2.6.23-git19.hacked/arch/m68knommu/kernel/setup.c	2007-10-24 11:36:55.000000000 +1000
@@ -116,7 +116,7 @@ void (*mach_power_off)(void);
 extern int _stext, _etext, _sdata, _edata, _sbss, _ebss, _end;
 extern int _ramstart, _ramend;
 
-void setup_arch(char **cmdline_p)
+void __init setup_arch(char **cmdline_p)
 {
 	int bootmap_size;
 
