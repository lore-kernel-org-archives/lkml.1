Return-Path: <linux-kernel-owner+w=401wt.eu-S1030675AbXAZAUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030675AbXAZAUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 19:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030673AbXAZAU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 19:20:26 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:54158 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030671AbXAZAUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 19:20:23 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: linux-mm@kvack.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Message-Id: <20070125234658.28809.91432.sendpatchset@skynet.skynet.ie>
In-Reply-To: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 6/8] x86_64 - Specify amount of kernel memory at boot time
Date: Thu, 25 Jan 2007 23:46:58 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds the kernelcore= parameter for x86_64.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---

 e820.c |    1 +
 1 files changed, 1 insertion(+)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.20-rc4-mm1-005_ppc64_set_kernelcore/arch/x86_64/kernel/e820.c linux-2.6.20-rc4-mm1-006_x8664_set_kernelcore/arch/x86_64/kernel/e820.c
--- linux-2.6.20-rc4-mm1-005_ppc64_set_kernelcore/arch/x86_64/kernel/e820.c	2007-01-17 17:08:01.000000000 +0000
+++ linux-2.6.20-rc4-mm1-006_x8664_set_kernelcore/arch/x86_64/kernel/e820.c	2007-01-25 17:40:16.000000000 +0000
@@ -617,6 +617,7 @@ static int __init parse_memopt(char *p)
 	return 0;
 } 
 early_param("mem", parse_memopt);
+early_param("kernelcore", cmdline_parse_kernelcore);
 
 static int userdef __initdata;
 
