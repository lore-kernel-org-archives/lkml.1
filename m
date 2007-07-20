Return-Path: <linux-kernel-owner+w=401wt.eu-S1764378AbXGTWTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764378AbXGTWTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762055AbXGTWT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:19:27 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:44222 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756178AbXGTWTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:19:25 -0400
Date: Sat, 21 Jul 2007 00:20:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] kbuild update
Message-ID: <20070720222039.GA25443@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Another smaller round of kbuild updates.
The important bit is the fix so we no longer warn too much on second
pass of modpost - section mismatch is avoided for vmlinux in second pass.

The 'larger' patch is a simple kconfig update I have used locally.
An earlier variant was reviewed with feedback incorporated in this updated patch.

Please pull from:
ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild.git

	Sam

[to lkml-readers. One of the below patches was the 'mssing' patch in the serie I just sent out].

Jesper Juhl (1):
      kbuild: fix up printing of Linux C Library version in scripts/ver_linux

Sam Ravnborg (3):
      kbuild: do not do section mismatch checks on vmlinux in 2nd pass
      kconfig: attach help text to menus
      kconfig: remove unused members from struct symbol

 scripts/Makefile.modpost            |   19 ++++++++++---------
 scripts/kconfig/conf.c              |   31 +++++++++++++++----------------
 scripts/kconfig/expr.h              |    4 +---
 scripts/kconfig/gconf.c             |   10 ++--------
 scripts/kconfig/kxgettext.c         |    4 ++--
 scripts/kconfig/lkc_proto.h         |    2 ++
 scripts/kconfig/mconf.c             |    4 ++--
 scripts/kconfig/menu.c              |   12 ++++++++++++
 scripts/kconfig/qconf.cc            |    2 +-
 scripts/kconfig/zconf.tab.c_shipped |   12 ++++++------
 scripts/kconfig/zconf.y             |   12 ++++++------
 scripts/mod/modpost.c               |   13 ++++++++++---
 scripts/ver_linux                   |    4 ++--
 13 files changed, 71 insertions(+), 58 deletions(-)
