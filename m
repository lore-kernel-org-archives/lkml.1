Return-Path: <linux-kernel-owner+w=401wt.eu-S933384AbYGCHIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384AbYGCHIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbYGCG5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35073 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbYGCECn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 00:02:43 -0400
Date: Wed, 2 Jul 2008 20:58:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.25.10
Message-ID: <20080703035807.GA8190@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.25.10
kernel.

It contains a number of assorted bugfixes all over the tree.  And once
again, any users of the 2.6.25 kernel series are STRONGLY encouraged to
upgrade to this release.

I'll also be replying to this message with a copy of the patch between
2.6.25.9 and 2.6.25.10

The updated 2.6.25.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.25.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=summary

thanks,

greg k-h

-------------

 Makefile                                    |    2 
 arch/x86/kernel/i387.c                      |    4 -
 arch/x86/kernel/ptrace.c                    |   45 +++++++------
 arch/x86/kernel/smpboot_64.c                |    1 
 drivers/char/drm/i915_drv.c                 |    1 
 drivers/infiniband/hw/mthca/mthca_memfree.c |    6 +
 drivers/net/hamradio/6pack.c                |    2 
 drivers/net/hamradio/mkiss.c                |    8 +-
 drivers/net/irda/irtty-sir.c                |    4 -
 drivers/net/ppp_async.c                     |    3 
 drivers/net/ppp_synctty.c                   |    3 
 drivers/net/slip.c                          |   14 +++-
 drivers/net/wan/x25_asy.c                   |   10 ++-
 drivers/net/wireless/strip.c                |    3 
 include/asm-x86/msr.h                       |    2 
 kernel/futex.c                              |   93 +++++++++++++++++++++-------
 kernel/sched.c                              |    1 
 17 files changed, 147 insertions(+), 55 deletions(-)


Alan Cox (1):
      TTY: fix for tty operations bugs

Dmitry Adamushko (1):
      sched: fix cpu hotplug

Eli Cohen (1):
      IB/mthca: Clear ICM pages before handing to FW

Greg Kroah-Hartman (1):
      Linux 2.6.25.10

Jie Luo (1):
      DRM: enable bus mastering on i915 at resume time

Max Asbock (1):
      x86: shift bits the right way in native_read_tscp

Roland McGrath (1):
      x86_64 ptrace: fix sys32_ptrace task_struct leak

TAKADA Yoshihito (1):
      ptrace GET/SET FPXREGS broken

Thomas Gleixner (1):
      futexes: fix fault handling in futex_lock_pi

Yanmin Zhang (1):
      x86: fix cpu hotplug crash

