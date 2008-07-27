Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbYG0Ghu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbYG0Ghu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYG0Ghl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:37:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbYG0Ghk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:37:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: x86 tracehook
X-Fcc: ~/Mail/linus
X-Windows: a mistake carried out to perfection.
Message-Id: <20080727063737.09934154280@magilla.localdomain>
Date: Sat, 26 Jul 2008 23:37:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!  The generic tracehook patches were merged, so now the arch stuff
can go in any time.  These are the pending x86 changes.  The only
difference from what I posted before are fixing up some tiny syntax
nits in syscall.h that made gcc-3.x unhappy.

Sorry Ingo, I had already done this with git-rebase before I read your
admonition about that today.  (Anyway, the prerequisite tracehook
series went in via patches rather than a GIT merge, so I don't think
the x86/tracehook branch forked from my own tracehook branch could
still have been used.)

The following changes since commit 8be1a6d6c77ab4532e4476fdb8177030ef48b52c:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../roland/infiniband

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-utrace.git x86-tracehook

Roland McGrath (6):
      x86: tracehook_signal_handler
      x86: tracehook syscall
      x86: tracehook: asm/syscall.h
      x86 signals: use asm/syscall.h
      x86: tracehook: TIF_NOTIFY_RESUME
      x86: tracehook: CONFIG_HAVE_ARCH_TRACEHOOK

 arch/x86/Kconfig              |    1 +
 arch/x86/kernel/ptrace.c      |   34 +------
 arch/x86/kernel/signal_32.c   |   11 ++-
 arch/x86/kernel/signal_64.c   |   49 +++-------
 include/asm-x86/ptrace.h      |    5 +
 include/asm-x86/syscall.h     |  210 +++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/thread_info.h |    4 +-
 7 files changed, 248 insertions(+), 66 deletions(-)
 create mode 100644 include/asm-x86/syscall.h


Thanks,
Roland
