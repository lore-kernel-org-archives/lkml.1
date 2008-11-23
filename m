Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYKWMgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYKWMgG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 07:36:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758633AbYKWMfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 07:35:51 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:37408 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758626AbYKWMfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 07:35:50 -0500
Message-ID: <154e089b0811230435m5d3182feyff0babb8c55cec72@mail.gmail.com>
Date: Sun, 23 Nov 2008 13:35:48 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] x86: Remove duplicate #define from 'cpufeature.h'
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate #define from 'cpufeature.h'.

This also fixes the following sparse warning:

arch/x86/kernel/cpu/capflags.c:54:3: warning: Initializer entry defined twice
arch/x86/kernel/cpu/capflags.c:58:3:   also defined here

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 arch/x86/include/asm/cpufeature.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h
b/arch/x86/include/asm/cpufeature.h
index 694d1f8..5bce8ed 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -80,7 +80,6 @@
 #define X86_FEATURE_UP		(3*32+ 9) /* smp kernel running on up */
 #define X86_FEATURE_FXSAVE_LEAK (3*32+10) /* "" FXSAVE leaks FOP/FIP/FOP */
 #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
-#define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
 #define X86_FEATURE_PEBS	(3*32+12) /* Precise-Event Based Sampling */
 #define X86_FEATURE_BTS		(3*32+13) /* Branch Trace Store */
 #define X86_FEATURE_SYSCALL32	(3*32+14) /* "" syscall in ia32 userspace */
