Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbZESMbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbZESMbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 08:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbZESMb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 08:31:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:45294 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbZESMb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 08:31:28 -0400
Date: Tue, 19 May 2009 12:30:34 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jaswinder@kernel.org, tglx@linutronix.de, mingo@elte.hu,
       jaswinderrajput@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, tglx@linutronix.de, jaswinderrajput@gmail.com,
       mingo@elte.hu
In-Reply-To: <1242733021.3377.1.camel@localhost.localdomain>
References: <1242733021.3377.1.camel@localhost.localdomain>
Subject: [tip:x86/cleanups] x86: asm/processor.h: remove double declaration
Message-ID: <tip-4aee2ad461889132bfb5a1518a9580d00e17008c@git.kernel.org>
Git-Commit-ID: 4aee2ad461889132bfb5a1518a9580d00e17008c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 19 May 2009 12:30:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4aee2ad461889132bfb5a1518a9580d00e17008c
Gitweb:     http://git.kernel.org/tip/4aee2ad461889132bfb5a1518a9580d00e17008c
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Tue, 19 May 2009 17:07:01 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 19 May 2009 14:16:24 +0200

x86: asm/processor.h: remove double declaration

Remove double declaration of:

 extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;

they are already defined in the same file.

[ Impact: cleanup ]

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
LKML-Reference: <1242733021.3377.1.camel@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/processor.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 34c5237..85628ea 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -403,9 +403,6 @@ DECLARE_PER_CPU(unsigned long, stack_canary);
 extern unsigned int xstate_size;
 extern void free_thread_xstate(struct task_struct *);
 extern struct kmem_cache *task_xstate_cachep;
-extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
-extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
-extern unsigned short num_cache_leaves;
 
 struct thread_struct {
 	/* Cached TLS descriptors: */
