Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbZIYTNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbZIYTNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 15:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbZIYTNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 15:13:45 -0400
Received: from [195.41.46.235] ([195.41.46.235]:59129 "EHLO pfepa.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752537AbZIYTNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 15:13:44 -0400
Date: Fri, 25 Sep 2009 21:13:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Tim Abbott <tabbott@ksplice.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>,
       Manuel Lauss <manuel.lauss@gmail.com>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: [GIT] fixes for alpha+mips
Message-ID: <20090925191340.GA3280@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Two fixlets.

One to fix alpha build after vmlinux.lds.S cleanup.
Another to fix mips build - a bug included in my prevoius batch
of updates.

Note: master.kernel.org is slow on mirroring and this was
not mirrored out when I sent this mail.

	Sam


The following changes since commit 94e0fb086fc5663c38bbc0fe86d698be8314f82f:
  Linus Torvalds (1):
        Merge branch 'drm-intel-next' of git://git.kernel.org/.../anholt/drm-intel

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git master

Manuel Lauss (1):
      mips: fix build of vmlinux.lds

Sam Ravnborg (1):
      alpha: fix build after vmlinux.lds.S cleanup

 arch/alpha/kernel/vmlinux.lds.S |    1 +
 arch/mips/kernel/Makefile       |    2 ++
 arch/mips/kernel/vmlinux.lds.S  |   12 ++++++------
 3 files changed, 9 insertions(+), 6 deletions(-)
