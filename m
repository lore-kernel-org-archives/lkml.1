Return-Path: <linux-kernel-owner+w=401wt.eu-S1758836AbZANUue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836AbZANUue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 15:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbZANUu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 15:50:26 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:60213 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbZANUuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 15:50:25 -0500
Date: Wed, 14 Jan 2009 21:52:08 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT] kbuild fixes that needs some testing
Message-ID: <20090114205208.GA4076@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I plan to ask Linus to pull kbuild-fixes.git soon as it reverts the
commits that introduces the problems with distcc, too large modules etc.

The pull request are below.

I has been in the work for too long but as my current setup
is br0ken(*) then I need someone to pull the tree and check
if it builds etc.

I had hoped to find time to test this myself but thats not this week.

(*) Motherboard on my primary linux box is dead and the box I use
    atm is far away from decent...

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
