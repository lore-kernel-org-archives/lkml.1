Return-Path: <linux-kernel-owner+w=401wt.eu-S932075AbYGGXNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbYGGXNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 19:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755421AbYGGXLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 19:11:15 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:2565 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758111AbYGGXLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 19:11:14 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080708110.487722491@firstfloor.org>
In-Reply-To: <20080708110.487722491@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [9/10] Add missing includes in mce_intel_64.c
Message-Id: <20080707231011.A89931B4315@basil.firstfloor.org>
Date: Tue,  8 Jul 2008 01:10:11 +0200 (CEST)
X-OriginalArrivalTime: 07 Jul 2008 23:02:47.0713 (UTC) FILETIME=[92BC1110:01C8E085]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In some i386 configurations these are not implicitely included.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -12,6 +12,8 @@
 #include <asm/hw_irq.h>
 #include <asm/idle.h>
 #include <asm/therm_throt.h>
+#include <asm/apic.h>
+#include <asm/pda.h>
 
 asmlinkage void smp_thermal_interrupt(void)
 {
