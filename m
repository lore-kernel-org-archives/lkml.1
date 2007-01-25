Return-Path: <linux-kernel-owner+w=401wt.eu-S1030676AbXAZAUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030676AbXAZAUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 19:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030675AbXAZAUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 19:20:24 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:54159 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030673AbXAZAUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 19:20:23 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: linux-mm@kvack.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Message-Id: <20070125234618.28809.8385.sendpatchset@skynet.skynet.ie>
In-Reply-To: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 4/8] x86 - Specify amount of kernel memory at boot time
Date: Thu, 25 Jan 2007 23:46:18 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds the kernelcore= parameter for x86.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---

 setup.c |    1 +
 1 files changed, 1 insertion(+)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.20-rc4-mm1-003_mark_hugepages_movable/arch/i386/kernel/setup.c linux-2.6.20-rc4-mm1-004_x86_set_kernelcore/arch/i386/kernel/setup.c
--- linux-2.6.20-rc4-mm1-003_mark_hugepages_movable/arch/i386/kernel/setup.c	2007-01-17 17:07:57.000000000 +0000
+++ linux-2.6.20-rc4-mm1-004_x86_set_kernelcore/arch/i386/kernel/setup.c	2007-01-25 17:36:17.000000000 +0000
@@ -196,6 +196,7 @@ static int __init parse_mem(char *arg)
 	return 0;
 }
 early_param("mem", parse_mem);
+early_param("kernelcore", cmdline_parse_kernelcore);
 
 #ifdef CONFIG_PROC_VMCORE
 /* elfcorehdr= specifies the location of elf core header
