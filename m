Return-Path: <linux-kernel-owner+w=401wt.eu-S1759080AbZBLMrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080AbZBLMrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:47:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760329AbZBLMo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:44:26 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34503 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759343AbZBLMoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:44:24 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212143.515129156@firstfloor.org>
In-Reply-To: <20090212143.515129156@firstfloor.org>
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/4] x86: MCE: Enable machine checks in 64bit defconfig
Message-Id: <20090212124320.8682B3E666E@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:43:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Low priority fix

The 32bit defconfig already had it enabled. And it's a pretty 
fundamental feature, so better enable it on 64bit too.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/configs/x86_64_defconfig |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux/arch/x86/configs/x86_64_defconfig
===================================================================
--- linux.orig/arch/x86/configs/x86_64_defconfig	2009-02-12 11:30:48.000000000 +0100
+++ linux/arch/x86/configs/x86_64_defconfig	2009-02-12 11:30:51.000000000 +0100
@@ -247,7 +247,10 @@
 # CONFIG_PREEMPT is not set
 CONFIG_X86_LOCAL_APIC=y
 CONFIG_X86_IO_APIC=y
-# CONFIG_X86_MCE is not set
+CONFIG_X86_MCE=y
+CONFIG_X86_NEW_MCE=y
+CONFIG_X86_MCE_INTEL=y
+CONFIG_X86_MCE_AMD=y
 # CONFIG_I8K is not set
 CONFIG_MICROCODE=y
 CONFIG_MICROCODE_OLD_INTERFACE=y
