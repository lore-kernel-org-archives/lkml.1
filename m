Return-Path: <linux-kernel-owner+w=401wt.eu-S1763684AbXGSKPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763684AbXGSKPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761819AbXGSJzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:50 -0400
Received: from mail.suse.de ([195.135.220.2]:35408 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758906AbXGSJz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:28 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: jbeulich@novell.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [36/58] x86_64: minor exception trace variables cleanup
Message-Id: <20070719095522.3D89314E06@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:22 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

 arch/x86_64/mm/fault.c |    2 +-
 arch/x86_64/mm/init.c  |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

Index: linux/arch/x86_64/mm/fault.c
===================================================================
--- linux.orig/arch/x86_64/mm/fault.c
+++ linux/arch/x86_64/mm/fault.c
@@ -301,7 +301,7 @@ static int vmalloc_fault(unsigned long a
 	return 0;
 }
 
-int page_fault_trace = 0;
+static int page_fault_trace;
 int exception_trace = 1;
 
 /*
Index: linux/arch/x86_64/mm/init.c
===================================================================
--- linux.orig/arch/x86_64/mm/init.c
+++ linux/arch/x86_64/mm/init.c
@@ -700,8 +700,6 @@ int kern_addr_valid(unsigned long addr) 
 #ifdef CONFIG_SYSCTL
 #include <linux/sysctl.h>
 
-extern int exception_trace, page_fault_trace;
-
 static ctl_table debug_table2[] = {
 	{
 		.ctl_name	= 99,
