Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbZEETCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbZEETCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 15:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbZEETCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 15:02:09 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:51291 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbZEETCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 15:02:08 -0400
Date: Tue, 5 May 2009 21:04:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Manuel Lauss <mano@roarinelk.homelinux.net>,
       Jean Delvare <khali@linux-fr.org>, Anders Kaseorg <andersk@mit.edu>,
       Sean MacLennan <smaclennan@pikatech.com>
Subject: [GIT] kbuild fixes
Message-ID: <20090505190416.GA19475@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

This fixes an annoying warning "unexpected non-allocatable section",
that shows up in certain combinations of targets/gccs.

The tree commit fixes three different sources of the warnings.
This has now been in -next for a day or two with no additional comlains.

Please pull.

	Sam

The following changes since commit b4348f32dae3cb6eb4bc21c7ed8f76c0b11e9d6a:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://oss.sgi.com/xfs/xfs

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git master

Anders Kaseorg (1):
      kbuild, modpost: fix unexpected non-allocatable section when cross compiling

Sam Ravnborg (2):
      kbuild, modpost: fix "unexpected non-allocatable" warning with SUSE gcc
      kbuild, modpost: fix unexpected non-allocatable warning with mips

 scripts/mod/modpost.c |   47 ++++++++++++++++++++++++++++++++++-------------
 1 files changed, 34 insertions(+), 13 deletions(-)
