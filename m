Return-Path: <linux-kernel-owner+w=401wt.eu-S1757573AbZEDQ6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbZEDQ6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755778AbZEDQ6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:58:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:37492 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227AbZEDQ6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:58:34 -0400
Date: Mon, 4 May 2009 16:58:08 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jaswinder@kernel.org, tglx@linutronix.de, mingo@elte.hu,
       jaswinderrajput@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, tglx@linutronix.de, jaswinderrajput@gmail.com,
       mingo@elte.hu
In-Reply-To: <1241329295.6321.1.camel@localhost.localdomain>
References: <1241329295.6321.1.camel@localhost.localdomain>
Subject: [tip:x86/cpufeature] x86: cpufeature.h fix name for X86_FEATURE_MCE
Message-ID: <tip-3969c52d4d2fef5a4b9e3ab0e51b3901e1cc8b83@git.kernel.org>
Git-Commit-ID: 3969c52d4d2fef5a4b9e3ab0e51b3901e1cc8b83
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 04 May 2009 16:58:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3969c52d4d2fef5a4b9e3ab0e51b3901e1cc8b83
Gitweb:     http://git.kernel.org/tip/3969c52d4d2fef5a4b9e3ab0e51b3901e1cc8b83
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Sun, 3 May 2009 11:11:35 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 3 May 2009 10:40:57 +0200

x86: cpufeature.h fix name for X86_FEATURE_MCE

X86_FEATURE_MCE = Machine Check Exception
X86_FEATURE_MCA = Machine Check Architecture

[ Impact: cleanup ]

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
LKML-Reference: <1241329295.6321.1.camel@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/cpufeature.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index bb83b1c..ccc1061 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -22,7 +22,7 @@
 #define X86_FEATURE_TSC		(0*32+ 4) /* Time Stamp Counter */
 #define X86_FEATURE_MSR		(0*32+ 5) /* Model-Specific Registers */
 #define X86_FEATURE_PAE		(0*32+ 6) /* Physical Address Extensions */
-#define X86_FEATURE_MCE		(0*32+ 7) /* Machine Check Architecture */
+#define X86_FEATURE_MCE		(0*32+ 7) /* Machine Check Exception */
 #define X86_FEATURE_CX8		(0*32+ 8) /* CMPXCHG8 instruction */
 #define X86_FEATURE_APIC	(0*32+ 9) /* Onboard APIC */
 #define X86_FEATURE_SEP		(0*32+11) /* SYSENTER/SYSEXIT */
