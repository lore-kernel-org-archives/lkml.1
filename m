Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbXKEOHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbXKEOHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 09:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755418AbXKEOHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 09:07:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:51771 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbXKEOHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 09:07:40 -0500
Date: Mon, 5 Nov 2007 15:07:27 +0100
From: Andre Haupt <andre@bitwigglers.org>
To: linux-kernel@vger.kernel.org
Cc: buytenh@wantstofly.org, Andre Haupt <andre@bitwigglers.org>
Subject: [patch 1/1] ep93xx: fix double include of linux/serial.h
Message-ID: <20071105140727.GA25667@ahaupt-debian-vm.localdomain>
References: <20071105140517.207833278@ahaupt-debian-vm.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=ep93xx_fix_double_include
User-Agent: quilt/0.45-1
X-Provags-ID: V01U2FsdGVkX193/Ievde764329xtJor3KC1psmkoa8vYkhB3i
 Zm5iAQS/XG5dHuNFRLGwvCeA2pg6OJdpUlFdjpEzHrtOpcLQsv
 5Foqb3BLwiTYU+o2E4Yfwx+/HxHcuHKLLM2ZXYOqLs=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andre Haupt <andre@bitwigglers.org>
---
 arch/arm/mach-ep93xx/core.c |    1 -
 1 file changed, 1 deletion(-)

Index: linus/arch/arm/mach-ep93xx/core.c
===================================================================
--- linus.orig/arch/arm/mach-ep93xx/core.c	2007-11-05 14:48:43.000000000 +0100
+++ linus/arch/arm/mach-ep93xx/core.c	2007-11-05 14:49:09.000000000 +0100
@@ -18,7 +18,6 @@
 #include <linux/spinlock.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
-#include <linux/serial.h>
 #include <linux/tty.h>
 #include <linux/bitops.h>
 #include <linux/serial.h>

--
