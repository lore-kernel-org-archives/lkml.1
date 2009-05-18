Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbZERGer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbZERGer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 02:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbZERGeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 02:34:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:55433 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbZERGef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 02:34:35 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 May 2009 16:34:25 +1000
Message-Id: <1242628465.18075.46.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

A few more 2.6.30 things for you... a defconfig update, and a couple
of small fixes, either obvious enough or regression fixes.

Cheers,
Ben.

The following changes since commit 86460103c412f9e11aeb7950cce64b9e51539d4d:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../rafael/suspend-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Benjamin Herrenschmidt (1):
      powerpc: Explicit alignment for .data.cacheline_aligned

Geoff Levand (1):
      powerpc/ps3: Update ps3_defconfig

Mel Gorman (1):
      powerpc: Do not assert pte_locked for hugepage PTE entries

Michael Ellerman (1):
      powerpc/ftrace: Use pr_devel() in ftrace.c

Steven Rostedt (1):
      powerpc/ftrace: Fix constraint to be early clobber

 arch/powerpc/configs/ps3_defconfig |  105 +++++++++++++++++++++---------------
 arch/powerpc/kernel/ftrace.c       |   22 ++++----
 arch/powerpc/kernel/vmlinux.lds.S  |    1 +
 arch/powerpc/mm/pgtable.c          |    3 +-
 4 files changed, 76 insertions(+), 55 deletions(-)


