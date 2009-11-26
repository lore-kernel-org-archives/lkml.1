Return-Path: <linux-kernel-owner+w=401wt.eu-S1760386AbZKZM0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760386AbZKZM0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 07:26:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760374AbZKZM0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 07:26:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:33723 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760378AbZKZM0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 07:26:06 -0500
Message-ID: <4B0E73E1.50900@suse.cz>
Date: Thu, 26 Nov 2009 13:26:09 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-5.3 Thunderbird/3.0b4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       =?ISO-8859-2?Q?An=EDbal_Monsalve_?= =?ISO-8859-2?Q?Salazar?= 
	<anibal@debian.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: linux-kbuild.git
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

I went through the patches posted to linux-kbuild and picked those that
were easy enough to review, looked safe and worked for me. I also took
Sam's series from kbuild-next.git, but I didn't really review it yet, so
there is no signoff from me (TBD). The repo is at

  git://repo.or.cz/linux-kbuild.git for-next

Please ignore the other branches. The shortlog is

Jie Zhang (1):
      net: add net_tstamp.h to headers_install

Jonathan Nieder (2):
      scripts/package: add KBUILD_PKG_ROOTCMD variable
      scripts/package: deb-pkg: use fakeroot if available

Michael Tokarev (1):
      kbuild: fix bzImage build for x86

Michal Marek (2):
      scripts/package: tar-pkg: use tar --owner=root
      kbuild: create include/generated in silentoldconfig

Sam Ravnborg (14):
      kbuild: search arch/$ARCH/include before include/
      dontdiff: add generated
      kbuild: move bounds.h to include/generated
      kbuild: move asm-offsets.h to include/generated
      ia64: move nr-irqs.h to include/generated
      arm: move mach-types to include/generated
      sh: move machtypes.h to include/generated
      kbuild: drop include2/ used for O=... builds
      kbuild: do not check for include/asm-$ARCH
      kbuild: drop include/asm
      kbuild: move compile.h to include/generated
      drop explicit include of autoconf.h
      kbuild: move autoconf.h to include/generated
      kbuild: move utsrelease.h to include/generated

Wenji Huang (2):
      Kbuild: clear marker out of modpost
      Kbuild: clean up marker

There are some more patches on the mailing list and in -mm, which I'm
going to look at, but I think this should be a good start. What do you
think? Could this be added to linux-next?

Michal
