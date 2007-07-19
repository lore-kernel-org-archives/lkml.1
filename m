Return-Path: <linux-kernel-owner+w=401wt.eu-S1761276AbXGSKSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761276AbXGSKSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761699AbXGSJz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:35418 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758738AbXGSJze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:34 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: bunk@stusta.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [41/58] i386: arch/i386/kernel/i8253.c should #include <asm/timer.h>
Message-Id: <20070719095527.844EC14E05@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Adrian Bunk <bunk@stusta.de>

Every file should include the headers containing the prototypes for its
global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/i8253.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/i386/kernel/i8253.c
===================================================================
--- linux.orig/arch/i386/kernel/i8253.c
+++ linux/arch/i386/kernel/i8253.c
@@ -13,6 +13,7 @@
 #include <asm/delay.h>
 #include <asm/i8253.h>
 #include <asm/io.h>
+#include <asm/timer.h>
 
 #include "io_ports.h"
 
