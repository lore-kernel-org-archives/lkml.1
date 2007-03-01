Return-Path: <linux-kernel-owner+w=401wt.eu-S964828AbXCAKJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964828AbXCAKJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 05:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964856AbXCAKJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 05:09:26 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:57289 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964828AbXCAKJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 05:09:25 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: akpm@linux-foundation.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Message-Id: <20070301100922.30048.40310.sendpatchset@skynet.skynet.ie>
In-Reply-To: <20070301100802.30048.45045.sendpatchset@skynet.skynet.ie>
References: <20070301100802.30048.45045.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 4/8] x86 - Specify amount of kernel memory at boot time
Date: Thu,  1 Mar 2007 10:09:22 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds the kernelcore= parameter for x86.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---

 setup.c |    1 +
 1 files changed, 1 insertion(+)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.20-mm2-003_mark_hugepages_movable/arch/i386/kernel/setup.c linux-2.6.20-mm2-004_x86_set_kernelcore/arch/i386/kernel/setup.c
--- linux-2.6.20-mm2-003_mark_hugepages_movable/arch/i386/kernel/setup.c	2007-02-19 01:19:26.000000000 +0000
+++ linux-2.6.20-mm2-004_x86_set_kernelcore/arch/i386/kernel/setup.c	2007-02-19 09:15:29.000000000 +0000
@@ -195,6 +195,7 @@ static int __init parse_mem(char *arg)
 	return 0;
 }
 early_param("mem", parse_mem);
+early_param("kernelcore", cmdline_parse_kernelcore);
 
 #ifdef CONFIG_PROC_VMCORE
 /* elfcorehdr= specifies the location of elf core header
