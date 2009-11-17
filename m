Return-Path: <linux-kernel-owner+w=401wt.eu-S1752265AbZKQUIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbZKQUIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 15:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbZKQUIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 15:08:34 -0500
Received: from relay2-v.mail.gandi.net ([217.70.178.76]:58966 "EHLO
	relay2-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbZKQUIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 15:08:34 -0500
Date: Tue, 17 Nov 2009 12:08:42 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Subject: [GIT PULL] Fix various -Wmissing-prototypes warnings
Message-ID: <20091117200842.GA7501@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a3ccf63ee643ef243cbf8918da8b3f9238f10029:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../ieee1394/linux1394-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/josh/linux-misc wmissing-prototypes

Josh Triplett (11):
      tty: Make tty_port_users static inline, not extern inline
      quota: Make __dquot_alloc_space static
      pty: Mark pty_resize static
      drivers/char/vt_ioctl.c: Include <linux/suspend.h> for pm_set_vt_switch
      sched: Mark various internal functions static
      x86: Include asm/proto.h in setup_nx.c for check_efer
      timers: Mark posix_get_coarse_res static
      x86: apic: Mark enable_IR static
      x86: apic: Make asm/apic.h prototype default_init_apic_ldr on 64-bit too.
      fs: Include fs/internal.h in fs/file_table.c for mark_files_ro prototype
      trace: Mark tracing_dentry_percpu static

 arch/x86/include/asm/apic.h |    8 ++++----
 arch/x86/kernel/apic/apic.c |    2 +-
 arch/x86/mm/setup_nx.c      |    1 +
 drivers/char/pty.c          |    2 +-
 drivers/char/vt_ioctl.c     |    1 +
 fs/file_table.c             |    2 ++
 fs/quota/dquot.c            |    3 +--
 include/linux/tty.h         |    2 +-
 kernel/posix-timers.c       |    2 +-
 kernel/sched.c              |    4 ++--
 kernel/sched_fair.c         |    2 +-
 kernel/sched_idletask.c     |    2 +-
 kernel/sched_rt.c           |    2 +-
 kernel/trace/trace.c        |    2 +-
 14 files changed, 19 insertions(+), 16 deletions(-)
