Return-Path: <linux-kernel-owner+w=401wt.eu-S1752339AbZESLhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbZESLhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 07:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbZESLha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 07:37:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:42160 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbZESLh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 07:37:29 -0400
Subject: [PATCH -tip] x86: asm/processor.h remove double declaration
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 19 May 2009 17:07:01 +0530
Message-Id: <1242733021.3377.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

Remove double declaration of:
 extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;

they are already defined in the same file.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/processor.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 930d4ea..c776826 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -410,9 +410,6 @@ DECLARE_PER_CPU(unsigned long, stack_canary);
 extern unsigned int xstate_size;
 extern void free_thread_xstate(struct task_struct *);
 extern struct kmem_cache *task_xstate_cachep;
-extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
-extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
-extern unsigned short num_cache_leaves;
 
 struct thread_struct {
 	/* Cached TLS descriptors: */
-- 
1.6.1.1



