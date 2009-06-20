Return-Path: <linux-kernel-owner+w=401wt.eu-S1754988AbZFTLmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbZFTLmA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 07:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbZFTLlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 07:41:52 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:34990 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbZFTLlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 07:41:51 -0400
Date: Sat, 20 Jun 2009 13:44:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mike Frysinger <vapier@gentoo.org>, WANG Cong <amwang@redhat.com>
Subject: [GIT] kbuild fixes
Message-ID: <20090620114411.GA32531@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

This tree has seen no testing - but the individual patches
has been tested. I decided to request a pull early because
the kallsyms bug annoys several people.

Please pull to fix:

- kallsyms fix
  fix build breakage on arm
  fix backtrace on at least sparc and presumeably also x86

- make htmldocs breakage

- 2 fixlets for kernel-doc

The following changes since commit fb20871a54961b82d35303b43452928186c1361d:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../gregkh/staging-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git master

Amerigo Wang (1):
      kbuild: fix build error during make htmldocs

Mike Frysinger (1):
      kallsyms: fix inverted valid symbol checking

Randy Dunlap (2):
      kernel-doc: ignore kmemcheck_bitfield_begin/end
      kernel-doc: fix param matching for array params

 scripts/basic/docproc.c |    2 +-
 scripts/kallsyms.c      |    6 +++---
 scripts/kernel-doc      |   19 +++++++++++++++++++
 3 files changed, 23 insertions(+), 4 deletions(-)
