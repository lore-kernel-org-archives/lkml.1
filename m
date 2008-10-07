Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbYJGLnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbYJGLnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYJGLnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:43:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38023 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbYJGLnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:43:16 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20081007143.793379346@firstfloor.org>
In-Reply-To: <20081007143.793379346@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/3] Remove unused EAX_EDX_ARGS
Message-Id: <20081007114314.D03C93E6A0C@basil.firstfloor.org>
Date: Tue,  7 Oct 2008 13:43:14 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.27-rc4-misc/include/asm-x86/msr.h
===================================================================
--- linux-2.6.27-rc4-misc.orig/include/asm-x86/msr.h
+++ linux-2.6.27-rc4-misc/include/asm-x86/msr.h
@@ -15,12 +15,10 @@
 #ifdef CONFIG_X86_64
 #define DECLARE_ARGS(val, low, high)	unsigned low, high
 #define EAX_EDX_VAL(val, low, high)	((low) | ((__u64)(high) << 32))
-#define EAX_EDX_ARGS(val, low, high)	"a" (low), "d" (high)
 #define EAX_EDX_RET(val, low, high)	"=a" (low), "=d" (high)
 #else
 #define DECLARE_ARGS(val, low, high)	unsigned long long val
 #define EAX_EDX_VAL(val, low, high)	(val)
-#define EAX_EDX_ARGS(val, low, high)	"A" (val)
 #define EAX_EDX_RET(val, low, high)	"=A" (val)
 #endif
 
