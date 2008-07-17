Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbYGQHqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbYGQHqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbYGQHpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:45:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbYGQHpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:45:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 0/6] x86 tracehook patches
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080717074550.EE1E215411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:45:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!  Here is the x86 arch work that goes with the "tracehook" patch
series that I posted for the generic code.  I don't know how the
merging will go with that.  But when there is a tree containing all
that to base it on, you can merge these arch patches on top of that.
You can't take these without the generic tracehook series, some will
break the build until the generic file is there.

This series also requires as a baseline what you have in tip/x86/step.

The following changes since commit dc2cda6931dd54cd02b05da3a5bc969032e10992:
  Roland McGrath (1):
        x86 ptrace: user-sets-TF nits

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
