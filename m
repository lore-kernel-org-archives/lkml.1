Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYBIPR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYBIPR4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 10:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYBIPRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 10:17:04 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:37653 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbYBIPRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 10:17:03 -0500
From: Andi Kleen <ak@suse.de>
References: <20080209416.271135970@suse.de>
In-Reply-To: <20080209416.271135970@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/5] Fix wrong comment
Message-Id: <20080209151700.52DAF1B41D1@basil.firstfloor.org>
Date: Sat,  9 Feb 2008 16:17:00 +0100 (CET)
X-OriginalArrivalTime: 09 Feb 2008 15:10:39.0767 (UTC) FILETIME=[EE69CA70:01C86B2D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It should operate in BCD mode.
Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/include/asm-x86/mc146818rtc.h
===================================================================
--- linux.orig/include/asm-x86/mc146818rtc.h
+++ linux/include/asm-x86/mc146818rtc.h
@@ -11,7 +11,7 @@
 
 #ifndef RTC_PORT
 #define RTC_PORT(x)	(0x70 + (x))
-#define RTC_ALWAYS_BCD	1	/* RTC operates in binary mode */
+#define RTC_ALWAYS_BCD	1	/* RTC operates in BCD mode */
 #endif
 
 #if defined(CONFIG_X86_32) && defined(__HAVE_ARCH_CMPXCHG)
