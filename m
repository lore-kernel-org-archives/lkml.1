Return-Path: <linux-kernel-owner+w=401wt.eu-S1759702AbZDGPMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759702AbZDGPMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758625AbZDGPHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:07:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48843 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955AbZDGPHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:07:51 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [8/28] x86: MCE: Remove unused mce_events variable
Message-Id: <20090407150749.466EC1D046E@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:07:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Cleanup

Remove unused mce_events static variable.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:13.000000000 +0200
@@ -55,7 +55,6 @@
 static unsigned long notify_user;
 static int rip_msr;
 static int mce_bootlog = -1;
-static atomic_t mce_events;
 
 static char trigger[128];
 static char *trigger_argv[2] = { trigger, NULL };
@@ -91,7 +90,6 @@
 void mce_log(struct mce *mce)
 {
 	unsigned next, entry;
-	atomic_inc(&mce_events);
 	mce->finished = 0;
 	wmb();
 	for (;;) {
