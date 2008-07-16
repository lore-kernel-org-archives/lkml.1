Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbYGPXCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbYGPXCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 19:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbYGPXCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 19:02:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599AbYGPXCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 19:02:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 0/4] x86 step/syscall-trace fixes & cleanups
X-Windows: simplicity made complex.
Message-Id: <20080716230217.3C25715410D@magilla.localdomain>
Date: Wed, 16 Jul 2008 16:02:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm posting these four patches for everyone to see on the list, but they
can be pulled from GIT as well.


The following changes since commit 8a0ca91e1db5de5eb5b18cfa919d52ff8be375af:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../drzeus/mmc

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git x86/step

Roland McGrath (4):
      x86 ptrace: block-step fix
      x86 ptrace: unify TIF_SINGLESTEP
      x86 ptrace: unify syscall tracing
      x86 ptrace: user-sets-TF nits

 arch/x86/ia32/ia32entry.S     |   17 +++--
 arch/x86/kernel/entry_32.S    |   23 ++-----
 arch/x86/kernel/entry_64.S    |   14 +++--
 arch/x86/kernel/ptrace.c      |  151 +++++++++++++++--------------------------
 arch/x86/kernel/signal_32.c   |    6 --
 arch/x86/kernel/signal_64.c   |    6 --
 arch/x86/kernel/step.c        |   35 ++++++++--
 include/asm-x86/calling.h     |    6 +-
 include/asm-x86/ptrace-abi.h  |    6 +-
 include/asm-x86/thread_info.h |   21 +++---
 10 files changed, 129 insertions(+), 156 deletions(-)



Thanks,
Roland
