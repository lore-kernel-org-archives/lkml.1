Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbZBQVJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbZBQVJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 16:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbZBQVJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 16:09:29 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:33256 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbZBQVJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 16:09:28 -0500
Date: Tue, 17 Feb 2009 22:11:19 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT] kbuild
Message-ID: <20090217211119.GA29190@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please pull the following kbuild related fixes.

The significant part of this is the updates to the markup_oops.pl script.
The rest is udpated to tags, rpm and setlocalversion.
And a small update that touches top-lvel Makefile:
- We create a source symlink during *config and not the prepare phase as before

	Sam

The following changes since commit d2f8d7ee1a9b4650b4e43325b321801264f7c37a:
  Linus Torvalds (1):
        Linux 2.6.29-rc5

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git master

Alexey Dobriyan (1):
      kbuild: fix tags generation of config symbols

Andi Kleen (1):
      kbuild: create the source symlink earlier in the objdir

Arjan van de Ven (2):
      scripts: add x86 register parser to markup_oops.pl
      scripts: add x86 64 bit support to the markup_oops.pl script

Josh Hunt (1):
      kbuild: add vmlinux to kernel rpm

Michael Neuling (1):
      bootgraph: fix for use with dot symbols

Mike Frysinger (1):
      kbuild,setlocalversion: shorten the make time when using svn

Rabin Vincent (1):
      kbuild: add sys_* entries for syscalls in tags

 Makefile                |    2 +-
 scripts/bootgraph.pl    |    4 +-
 scripts/markup_oops.pl  |  161 ++++++++++++++++++++++++++++++++++++++++++++---
 scripts/package/mkspec  |    8 +++
 scripts/setlocalversion |    9 +---
 scripts/tags.sh         |   12 +++-
 6 files changed, 174 insertions(+), 22 deletions(-)
