Return-Path: <linux-kernel-owner+w=401wt.eu-S1751427AbZKEHHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbZKEHHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 02:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbZKEHHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 02:07:42 -0500
Received: from gate.crashing.org ([63.228.1.57]:40345 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbZKEHHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 02:07:41 -0500
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@lists.ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Nov 2009 18:07:22 +1100
Message-ID: <1257404842.13611.109.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are some small bits for .32

The Kconfig cleanup you asked for hugetlbfs selection, a few regression
fixes and an actual bug fix that I decided was worth putting in now
(the RTC dates thingy)

Cheers,
Ben. 

The following changes since commit 2e2ec952350f25242f2e0539db16b1e46f9eb01b:
  Linus Torvalds (1):
        Merge branch 'bugfix' of git://git.kernel.org/.../jeremy/xen

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Andre Detsch (1):
      powerpc/pci: Fix regression in powerpc MSI-X

Benjamin Herrenschmidt (4):
      powerpc: Cleanup Kconfig selection of hugetlbfs support
      powerpc/mm: Remove debug context clamping from nohash code
      powerpc: Avoid giving out RTC dates below EPOCH
      powerpc/kvm: Remove problematic BUILD_BUG_ON statement

 arch/powerpc/Kconfig                  |    4 ++++
 arch/powerpc/kernel/time.c            |   15 ++++++++++++++-
 arch/powerpc/kvm/timing.h             |    4 ++++
 arch/powerpc/mm/mmu_context_nohash.c  |    4 ++--
 arch/powerpc/platforms/pseries/msi.c  |    2 --
 arch/powerpc/platforms/pseries/xics.c |    9 +++++++++
 fs/Kconfig                            |    2 +-
 7 files changed, 34 insertions(+), 6 deletions(-)


