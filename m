Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbXKYWIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbXKYWIK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758674AbXKYWGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:06:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758667AbXKYWG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:06:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 22/27] x86: debugctlmsr constants
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Zippy-Says: NOT fucking!! Also not a PACKAGE of LOOSE-LEAF PAPER!!
Message-Id: <20071125220624.8569026F8C5@magilla.localdomain>
Date: Sun, 25 Nov 2007 14:06:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This adds constant macros for a few of the bits in MSR_IA32_DEBUGCTLMSR.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/asm-x86/msr-index.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/msr-index.h b/include/asm-x86/msr-index.h
index a494473..4045bbe 100644
--- a/include/asm-x86/msr-index.h
+++ b/include/asm-x86/msr-index.h
@@ -63,6 +63,13 @@
 #define MSR_IA32_LASTINTFROMIP		0x000001dd
 #define MSR_IA32_LASTINTTOIP		0x000001de
 
+/* DEBUGCTLMSR bits (others vary by model): */
+#define _DEBUGCTLMSR_LBR	0 /* last branch recording */
+#define _DEBUGCTLMSR_BTF	1 /* single-step on branches */
+
+#define DEBUGCTLMSR_LBR		(1UL << _DEBUGCTLMSR_LBR)
+#define DEBUGCTLMSR_BTF		(1UL << _DEBUGCTLMSR_BTF)
+
 #define MSR_IA32_MC0_CTL		0x00000400
 #define MSR_IA32_MC0_STATUS		0x00000401
 #define MSR_IA32_MC0_ADDR		0x00000402
