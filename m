Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbZCJX6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbZCJX6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 19:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbZCJX6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 19:58:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:54148 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbZCJX6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 19:58:17 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 10:57:24 +1100
Message-Id: <1236729444.7086.24.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are some late fixes for 2.6.29. I've included a radeonfb/aty128fb commit
as it only affects a powerpc specific code path and solves a reported regression.
There's also an hvc_console commit that only affects powerpc pseries backends,
and also solves a regression. The rest are defconfig fixes and removing some
obsolete and non-building code from a pair of embedded platforms.
 
Cheers,
Ben.

The following changes since commit 99adcd9d67aaf04e28f5ae96df280f236bde4b66:
  Linus Torvalds (1):
        Merge branch 'fixes' of git://git.kernel.org/.../davej/cpufreq

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Benjamin Herrenschmidt (3):
      Merge commit 'gcl/merge' into merge
      hvc_console: Remove tty->low_latency on pseries backends
      radeonfb/aty128fb: Disable broken early resume hook for PowerBooks

Grant Likely (1):
      powerpc/4xx: Enable SERIAL_OF support by default for Virtex platforms

Guennadi Liakhovetski (1):
      powerpc: fix linkstation and storcenter compilation breakage

 arch/powerpc/configs/40x/virtex_defconfig        |    2 +-
 arch/powerpc/configs/44x/virtex5_defconfig       |    2 +-
 arch/powerpc/configs/linkstation_defconfig       |   36 ++++++++++++--------
 arch/powerpc/configs/storcenter_defconfig        |   35 ++++++++++++-------
 arch/powerpc/platforms/embedded6xx/linkstation.c |   38 ----------------------
 arch/powerpc/platforms/embedded6xx/storcenter.c  |   32 ------------------
 drivers/char/hvcs.c                              |    9 -----
 drivers/char/hvsi.c                              |    1 -
 drivers/video/aty/aty128fb.c                     |   10 +++++-
 drivers/video/aty/radeon_pm.c                    |   10 +++++-
 10 files changed, 64 insertions(+), 111 deletions(-)


