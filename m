Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbYEWJyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbYEWJyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 05:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYEWJx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 05:53:58 -0400
Received: from ozlabs.org ([203.10.76.45]:52187 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbYEWJx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 05:53:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18486.37935.242555.465662@cargo.ozlabs.ibm.com>
Date: Fri, 23 May 2008 19:53:51 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git merge branch
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

to get some more small bug and warning fixes for powerpc (and one
commit that just updates some comments).

Thanks,
Paul.

 arch/powerpc/kernel/prom_init_check.sh |    2 +-
 arch/powerpc/mm/pgtable_32.c           |    2 +-
 arch/powerpc/platforms/ps3/mm.c        |    3 +++
 arch/powerpc/sysdev/mpic.c             |   20 +++-----------------
 drivers/block/viodasd.c                |    2 +-
 drivers/cdrom/viocd.c                  |    2 +-
 drivers/char/viocons.c                 |    2 +-
 drivers/char/viotape.c                 |    2 +-
 include/asm-powerpc/mpic.h             |    3 +--
 9 files changed, 13 insertions(+), 25 deletions(-)

David Gibson (1):
      [POWERPC] Fix __set_fixmap() for STRICT_MM_TYPECHECKS

Geoff Levand (1):
      [POWERPC] PS3: Fix memory hotplug

Michael Ellerman (1):
      [POWERPC] Add kernstart_addr to list of allowed symbols in prom_init

Stephen Rothwell (2):
      [POWERPC] mpic: Fix use of uninitialized variable
      [POWERPC] iSeries: Remove unused mail address

