Return-Path: <linux-kernel-owner+w=401wt.eu-S933572AbXIUWwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572AbXIUWwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764234AbXIUWc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:57 -0400
Received: from mail.suse.de ([195.135.220.2]:57143 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762672AbXIUWcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:52 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [50/50] x86_64: Remove fpu io port resource
Message-Id: <20070921223251.1312913DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Not needed on modern systems without external FPU

TBD on i386 it is only needed for true 386s. Could remove it there
TBD for >= 486

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/setup.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux/arch/x86_64/kernel/setup.c
===================================================================
--- linux.orig/arch/x86_64/kernel/setup.c
+++ linux/arch/x86_64/kernel/setup.c
@@ -121,8 +121,6 @@ struct resource standard_io_resources[] 
 		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
 	{ .name = "dma2", .start = 0xc0, .end = 0xdf,
 		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
-	{ .name = "fpu", .start = 0xf0, .end = 0xff,
-		.flags = IORESOURCE_BUSY | IORESOURCE_IO }
 };
 
 #define IORESOURCE_RAM (IORESOURCE_BUSY | IORESOURCE_MEM)
