Return-Path: <linux-kernel-owner+w=401wt.eu-S1757100AbZBSHAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbZBSHAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 02:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbZBSHAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 02:00:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:38403 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbZBSHAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 02:00:42 -0500
Subject: [git-pull -tip] x86: fix double declaration
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 19 Feb 2009 12:30:09 +0530
Message-Id: <1235026809.23776.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cc2d1a5b2dbb2a3ccbb24e17a454ed1aa1b8ece4:
  Ingo Molnar (1):
        Merge branch 'timers/new-apis'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tipclean.git master

Jaswinder Singh Rajput (1):
      x86: include/asm/processor.h remove double declaration of print_cpu_info

 arch/x86/include/asm/processor.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

Complete diff:
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index dabab1a..72914d0 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -403,7 +403,6 @@ DECLARE_PER_CPU(unsigned long, stack_canary);
 #endif
 #endif	/* X86_64 */
 
-extern void print_cpu_info(struct cpuinfo_x86 *);
 extern unsigned int xstate_size;
 extern void free_thread_xstate(struct task_struct *);
 extern struct kmem_cache *task_xstate_cachep;


