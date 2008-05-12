Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbYELNCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbYELNCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 09:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902AbYELNCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 09:02:41 -0400
Received: from ozlabs.org ([203.10.76.45]:42568 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341AbYELNCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 09:02:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18472.16324.442125.351127@cargo.ozlabs.ibm.com>
Date: Mon, 12 May 2008 23:01:56 +1000
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

to get 5 commits; one that fixes a compile problem for ARCH=powerpc,
and 4 that fix compile problems for ARCH=ppc.  Since 2.6.26 will be
the last release that includes arch/ppc, we probably should make sure
it works in case anyone wants to refer to it subsequently.

Thanks,
Paul.

 arch/powerpc/kernel/Makefile   |    6 ++++++
 arch/powerpc/kernel/cputable.c |    2 ++
 arch/powerpc/lib/Makefile      |    2 +-
 arch/ppc/Makefile              |    2 +-
 arch/ppc/kernel/ppc_ksyms.c    |    1 +
 arch/ppc/kernel/setup.c        |    1 +
 arch/ppc/platforms/residual.c  |    1 +
 include/asm-ppc/system.h       |    2 +-
 8 files changed, 14 insertions(+), 3 deletions(-)

Paul Mackerras (2):
      [POWERPC] Fix default cputable entries for e200 and e500 families
      [POWERPC] ppc: More compile fixes

Segher Boessenkool (3):
      [POWERPC] ppc: Use ebony_defconfig for defconfig
      [POWERPC] ppc: Include <asm/cacheflush.h> in kernel/ppc_ksyms.c
      [POWERPC] ppc: Don't run prom_init_check for arch/ppc builds

