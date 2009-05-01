Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273AbZEAKNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbZEAKNL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 06:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbZEAKM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 06:12:56 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:53267 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbZEAKMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 06:12:55 -0400
Date: Fri, 1 May 2009 12:15:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Anders Kaseorg <andersk@mit.edu>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nico Schottelius <nico@ikn.schottelius.org>,
       Cedric Hombourger <chombourger@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Matt Kraai <kraai@ftbfs.org>,
       =?iso-8859-1?B?RnLpZOlyaWMgQnJp6HJl?= <fbriere@fbriere.net>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [GIT] kbuild
Message-ID: <20090501101503.GA21406@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

kbuild fixes:

o fixed check for section flags. Replace a heuristics with correct check of the flags

o a cygwin build fix (people do build kernels with cygwin these days)

o remove more files when cleaning

o fix tags so we do not append to the tags database

o improve support for git tags in setlocalversion


	Sam

The following changes since commit 091438dd5668396328a3419abcbc6591159eb8d1:
  Linus Torvalds (1):
        Linux 2.6.30-rc4

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git master

Anders Kaseorg (1):
      kbuild, modpost: Check the section flags, to catch missing "ax"/"aw"

Cedric Hombourger (1):
      kbuild: fix Module.markers permission error under cygwin

Frédéric Brière (1):
      kbuild: clean Module.markers and modules.order for out-of-tree modules

Matt Kraai (1):
      kbuild: remove a tag file before it is regenerated

Nico Schottelius (1):
      kbuild: fix scripts/setlocalversion with git

Randy Dunlap (1):
      docs: also clean index.html

Robert P. J. Day (1):
      kbuild: "make prepare" should be "make modules_prepare"

Sam Ravnborg (2):
      avr32: drop unused CLEAN_FILES
      kbuild: fix comment in modpost.c

 Documentation/DocBook/Makefile |    5 ++-
 Makefile                       |    6 +++-
 arch/avr32/Makefile            |    2 -
 scripts/mod/modpost.c          |   55 +++++++++++++++------------------------
 scripts/setlocalversion        |   13 ++++-----
 scripts/tags.sh                |    2 +
 6 files changed, 36 insertions(+), 47 deletions(-)
