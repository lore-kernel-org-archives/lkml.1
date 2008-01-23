Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbYAWV0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbYAWV0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 16:26:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbYAWV0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 16:26:37 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:60473 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbYAWV0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 16:26:36 -0500
Date: Wed, 23 Jan 2008 22:26:35 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andi Kleen <ak@suse.de>
cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/8] GBPAGES: Add feature macros for the gbpages cpuid
 bit
In-Reply-To: <20080119064830.5B00814EAD@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0801232225590.12676@fbirervta.pbzchgretzou.qr>
References: <20080119748.170864000@suse.de> <20080119064830.5B00814EAD@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 19 2008 07:48, Andi Kleen wrote:
>Subject: [PATCH] [2/8] GBPAGES: Add feature macros for the gbpages cpuid bit

Is there already a flag for /proc/cpuinfo or could you add one?

>Index: linux/include/asm-x86/cpufeature.h
>===================================================================
>--- linux.orig/include/asm-x86/cpufeature.h
>+++ linux/include/asm-x86/cpufeature.h
>@@ -49,6 +49,7 @@
> #define X86_FEATURE_MP		(1*32+19) /* MP Capable. */
> #define X86_FEATURE_NX		(1*32+20) /* Execute Disable */
> #define X86_FEATURE_MMXEXT	(1*32+22) /* AMD MMX extensions */
>+#define X86_FEATURE_GBPAGES	(1*32+26) /* GB pages */
> #define X86_FEATURE_RDTSCP	(1*32+27) /* RDTSCP */
> #define X86_FEATURE_LM		(1*32+29) /* Long Mode (x86-64) */
> #define X86_FEATURE_3DNOWEXT	(1*32+30) /* AMD 3DNow! extensions */
