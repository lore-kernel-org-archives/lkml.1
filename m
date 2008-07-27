Return-Path: <linux-kernel-owner+w=401wt.eu-S1757960AbYG0GtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbYG0GtS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYG0GtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:49:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbYG0GtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:49:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Fcc: ~/Mail/linus
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] powerpc tracehook
X-Shopping-List: (1) Ancient deviant bears
   (2) Uproarious meretricious helmet baskets
   (3) Repugnant paradoxes
   (4) Petulant fiction minions
Message-Id: <20080727064859.69692154280@magilla.localdomain>
Date: Sat, 26 Jul 2008 23:48:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are posted for review, but you can just pull the GIT branch
if you prefer.  Patch 1/5 corrects a long-standing (minor) error in ptrace
behavior.  The others change no existing behavior, just enable new and
future features to work on the arch.

The following changes since commit 8be1a6d6c77ab4532e4476fdb8177030ef48b52c:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../roland/infiniband

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-utrace.git powerpc-tracehook

Roland McGrath (5):
      powerpc: tracehook_signal_handler
      powerpc: tracehook syscall
      powerpc: tracehook: asm/syscall.h
      powerpc: tracehook: TIF_NOTIFY_RESUME
      powerpc: tracehook: CONFIG_HAVE_ARCH_TRACEHOOK

 arch/powerpc/Kconfig              |    1 +
 arch/powerpc/kernel/entry_32.S    |   11 ++++-
 arch/powerpc/kernel/entry_64.S    |   10 +++-
 arch/powerpc/kernel/ptrace.c      |   47 ++++++++++-----------
 arch/powerpc/kernel/signal.c      |   21 ++++++++-
 include/asm-powerpc/ptrace.h      |    1 +
 include/asm-powerpc/signal.h      |    3 +-
 include/asm-powerpc/syscall.h     |   84 +++++++++++++++++++++++++++++++++++++
 include/asm-powerpc/thread_info.h |    5 ++-
 9 files changed, 147 insertions(+), 36 deletions(-)
 create mode 100644 include/asm-powerpc/syscall.h


Thanks,
Roland
