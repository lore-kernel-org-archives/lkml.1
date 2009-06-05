Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbZFEXfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbZFEXfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZFEXfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:35:06 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:44611 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbZFEXfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:35:05 -0400
Date: Sat, 6 Jun 2009 01:37:21 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: kbuild-next content
Message-ID: <20090605233720.GA13588@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been offline for a while - but found some time this weekend
to do some kbuild work.
This is the patches that has accumulated in kbuild-next so far.

I have almost everything applied that I had queued up.
So if there is something missing assume I deleted it by mistake
and resend it to me.

I have a number of patches sitting in my local trees but
I need to look over them once more before they are ready
for public review.
This is mostly related to generated headers and simplfied
vmlinux.lds scripts (Tim is eagerly await this...).

Patches will follow.

	Sam

Amerigo Wang (2):
      kbuild/headers_check: refine extern check
      kbuild: clean up scripts/headers.sh

Cheng Renquan (1):
      kbuild: remove extra ifdef/endif of top Makefile

David VomLehn (1):
      kbuild/Documentation: Incorrect makefile syntax in example

Frans Pop (9):
      kbuild, deb-pkg: minor general improvements in builddeb script
      kbuild, deb-pkg: refactor code to reduce duplication
      kbuild, deb-pkg: fix 'file not found' error when building .deb package for arm
      kbuild, deb-pkg: pass Debian maintainer script parameters to packaging hook scripts
      kbuild, deb-pkg: allow to specify a custom revision for .deb packages
      kbuild, deb-pkg: allow alternative hook scripts directory in .deb packages
      kbuild, deb-pkg: improve changelog entry and package descriptions
      kbuild, deb-pkg: generate debian/copyright file
      kbuild, deb-pkg: improve Source field

Jan Beulich (1):
      initconst adjustments

Jiri Slaby (1):
      kbuild: allow docproc invocation from external

Manish Katiyar (1):
      kernel/kallsyms.c: replace deprecated __initcall with device_initcall and fix whitespace

Markus Heidelberg (10):
      kconfig: fix typo "mconfig" to "menuconfig" in a comment
      kconfig: add a note about the deps to the 'silentoldconfig' help
      kconfig: resort the documentation of the environment variables
      gitignore: ignore Kconfig i18n files
      kconfig qconf: fix -Wall compiler warnings
      kconfig qconf: fix namespace for Horizontal and Vertical enum values
      kconfig qconf: add namespace for use of Key_ enum values
      kconfig qconf: fix the type of the desktop widget
      kconfig: do not hardcode ".config" filename
      kconfig: do not hardcode "include/config/auto.conf" filename

Mike Frysinger (1):
      ignore *.patch files

Peter Korsgaard (1):
      kconfig: handle comment entries within choice/endchoice

Randy Dunlap (1):
      menu: fix embedded menu presentation

Robert P. J. Day (1):
      scripts/headers_check.pl: correct RE in header CONFIG leak check

Sam Ravnborg (2):
      kbuild: fix header export when __ASSEMBLY__ is used
      kbuild: add hint about __refdata to modpost

Sergei Poselenov (1):
      kbuild: fix "Argument list too long" error for "make headers_check",

dann frazier (1):
      Remove bashisms from scripts

maximilian attems (5):
      kbuild, deb-pkg: improve maintainer identification
      kbuild, deb-pkg: fix generated package name
      kbuild, deb-pkg: fix Provides field
      kbuild, deb-pkg: fix Section field
      kbuild, deb-pkg: bump standards version

 .gitignore                           |    1 +
 Documentation/kbuild/kconfig.txt     |  116 ++++++++++++++-------------
 Documentation/kbuild/modules.txt     |    2 +-
 Makefile                             |   26 ++----
 README                               |    1 +
 include/asm-generic/vmlinux.lds.h    |    5 +-
 include/linux/init.h                 |    3 +-
 init/Kconfig                         |   16 ++--
 kernel/kallsyms.c                    |  134 ++++++++++++++++++-------------
 scripts/Makefile.headersinst         |    8 ++-
 scripts/basic/docproc.c              |   13 ++-
 scripts/gcc-version.sh               |    2 +-
 scripts/headers.sh                   |    7 --
 scripts/headers_check.pl             |   16 +++--
 scripts/headers_install.pl           |    2 +-
 scripts/kconfig/.gitignore           |    3 +
 scripts/kconfig/Makefile             |    4 +-
 scripts/kconfig/conf.c               |    7 +-
 scripts/kconfig/confdata.c           |   20 +++--
 scripts/kconfig/lkc.h                |    1 +
 scripts/kconfig/lxdialog/checklist.c |    3 +-
 scripts/kconfig/mconf.c              |   10 ++-
 scripts/kconfig/qconf.cc             |   48 ++++++-----
 scripts/kconfig/util.c               |    6 +-
 scripts/mod/modpost.c                |   50 +++++++++---
 scripts/package/builddeb             |  149 +++++++++++++++++++++++-----------
 scripts/ver_linux                    |    2 +-
 27 files changed, 395 insertions(+), 260 deletions(-)
