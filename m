Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbZAZUKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbZAZUKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 15:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbZAZUKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 15:10:34 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:47748 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbZAZUKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 15:10:32 -0500
Date: Mon, 26 Jan 2009 21:12:17 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Andi Kleen <ak@linux.intel.com>,
       Wenji Huang <wenji.huang@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Dave Jones <davej@redhat.com>, Roland McGrath <roland@redhat.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: [GIT] kbuild updates
Message-ID: <20090126201217.GA9704@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please pull the following fixes.

1) It reverts the two patches that introduce improved stripping
   of modules and vmlinux. Expect them to come back later when we have
   sorted out all issues.
   Jan has posted a patch to disable the ill effects but we should
   fix the root couse somehow.

2) Two other trivialities


Note: I am rather unresponsive until week 11 due to day-time work and vacation.

	Sam


The following changes since commit a6525042bfdfcab128bd91fad264de10fd24a55e:
  Linus Torvalds (1):
        Merge branch 'x86-pat-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git master

Andi Kleen (1):
      kbuild: print usage with no arguments in scripts/config

Randy Dunlap (1):
      kbuild: fix kbuild.txt typos

Sam Ravnborg (1):
      Revert "kbuild: strip generated symbols from *.ko"

 Documentation/kbuild/kbuild.txt     |   29 +++---
 Makefile                            |   59 ++++--------
 arch/x86/scripts/strip-symbols      |    1 -
 init/Kconfig                        |    7 --
 kernel/kallsyms.c                   |   16 ++-
 scripts/Makefile.build              |   55 ++++-------
 scripts/Makefile.modinst            |    3 +-
 scripts/config                      |    4 +
 scripts/genksyms/genksyms.c         |   21 +---
 scripts/genksyms/keywords.c_shipped |  189 +++++++++++++++++------------------
 scripts/genksyms/keywords.gperf     |    2 -
 scripts/kallsyms.c                  |   21 +++--
 scripts/mksysmap                    |    7 +-
 scripts/strip-symbols               |   22 ----
 14 files changed, 185 insertions(+), 251 deletions(-)
 delete mode 100644 arch/x86/scripts/strip-symbols
 delete mode 100644 scripts/strip-symbols
