Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab0CFXUm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 18:20:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:44452 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab0CFXUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 18:20:39 -0500
Date: Sat, 6 Mar 2010 23:20:35 +0000
From: Kyle McMartin <kyle@hera.kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: [git patches] parisc fixes for v2.6.34
Message-ID: <20100306232035.GA20546@hera.kernel.org>
Reply-To: kyle@mcmartin.ca
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 06 Mar 2010 23:20:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, just a small parisc update for .34 as I've not had a chance to
fix up the new regset and tracehook stuff yet.

All of this code has been baking in -next since last release (except the
latest trivial ratelimit fix) and has been freshly rebased since jejb's
XFS coherence fix was merged seperately.

Tested to build and boot ok on my rp3440.

regards, Kyle

The following changes since commit 66b89159c25a47d2177743526c61b5ada7acc39e:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../joern/logfs

are available in the git repository at:

  /pub/scm/linux/kernel/git/kyle/parisc-2.6.git for-linus

Akinobu Mita (1):
      parisc: use __ratelimit in unaligned.c

Frans Pop (1):
      parisc: remove trailing space in messages

Helge Deller (3):
      parisc: wire up sys_recvmmsg
      parisc: add strict copy size checks (v2)
      parisc: drop unnecessary cast in __ldcw_align() macro

John Stultz (1):
      parisc: Convert to read/update_persistent_clock

Kyle McMartin (1):
      parisc: ditto sys_accept4

Robert P. J. Day (1):
      parisc: Simplify param.h by including <asm-generic/param.h>

 arch/parisc/Kconfig.debug          |   14 ++++++++++++++
 arch/parisc/include/asm/param.h    |   23 +----------------------
 arch/parisc/include/asm/system.h   |    2 +-
 arch/parisc/include/asm/uaccess.h  |   27 +++++++++++++++++++++++++--
 arch/parisc/include/asm/unistd.h   |    4 +++-
 arch/parisc/kernel/cache.c         |    4 ++--
 arch/parisc/kernel/syscall_table.S |    2 ++
 arch/parisc/kernel/time.c          |   29 +++++++++++++----------------
 arch/parisc/kernel/unaligned.c     |   14 ++++----------
 arch/parisc/lib/memcpy.c           |    3 ++-
 drivers/parisc/eisa_enumerator.c   |    2 +-
 drivers/parisc/superio.c           |    2 +-
 12 files changed, 69 insertions(+), 57 deletions(-)
