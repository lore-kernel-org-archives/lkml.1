Return-Path: <linux-kernel-owner+w=401wt.eu-S1754465AbZEMAFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbZEMAFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbZEMAFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:05:08 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1645 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbZEMAFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:05:07 -0400
Subject: [GIT PULL] MAINTAINERS, scripts/get_maintainer.pl, and
 Documentation/SubmittingPatches
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Sam Ravnborg <sam@ravnborg.org>, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <1241987200.3877.9.camel@Joe-AcerAspire>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
	 <20090417134711.ba0f03e7.randy.dunlap@oracle.com>
	 <1240003652.31116.44.camel@localhost> <20090407081312.GH1408@ucw.cz>
	 <1240415689.21848.19.camel@localhost>
	 <20090422185916.GA3864@uranus.ravnborg.org>
	 <20090422120510.cc17e470.akpm@linux-foundation.org>
	 <1240430185.21848.103.camel@localhost>  <20090422203005.GA467@elf.ucw.cz>
	 <1240557233.6735.240.camel@localhost>
	 <1241987200.3877.9.camel@Joe-AcerAspire>
Content-Type: text/plain
Date: Tue, 12 May 2009 17:03:36 -0700
Message-Id: <1242173016.9718.55.camel@Joe-AcerAspire>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch merges the P: and M: lines in MAINTAINERS
into a single M: line for easier manual copy/pasting.

scripts/get_maintainer.pl is updated to support this
integrated format along with a few bug fixes.

Documentation/SubmittingPatches is updated to recommend
using scripts/get_maintainer.pl.

A few patterns are updated in MAINTAINERS to track various
renames

The following changes since commit 1d80cac0fe44fb87b2a3d35fddd7f534ea81cd90:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://repo.or.cz/cris-mirror

are available in the git repository at:

  git://repo.or.cz/linux-2.6/trivial-mods.git gm_20090512

Joe Perches (19):
      scripts/get_maintainer.pl - Output first field only in mailing lists and after maintainers.
      scripts/get_maintainer.pl - Better fix for subscriber-only mailing lists
      scripts/get_maintainer.pl - improve --git-chief-penquins (Linus Torvalds) filtering
      scripts/get_maintainer.pl - Warn on missing git or git repository
      scripts/get_maintainer.pl - support M: lines with names and multiple entries per M: line
      scripts/get_maintainer.pl - Better email name quoting
      scripts/get_maintainer.pl - Support both "P:/M:" and integrated "M:" lines
      scripts/get_maintainer.pl - Don't print maintainers when not requested
      scripts/get_maintainer.pl - Allow 8 bit characters in email addresses
      MAINTAINERS - Swap mismarked ECRYPT FS M: and P: entries
      MAINTAINERS - Pair EDAC-E752X P: and M: entries
      MAINTAINERS - Add file patterns to "THE REST"
      MAINTAINERS - Update M32R file patterns after rename
      MAINTAINERS - Mark ALSA lists as moderated
      MAINTAINERS - Remove L:	linux-kernel@vger.kernel.org from all but "THE REST"
      MAINTAINERS - Mention scripts/get_maintainer.pl in the preface
      SubmittingPatches: Mention scripts/get_maintainer.pl and git request-pull
      MAINTAINERS - Merge P: name and M: address entries into M: name <address>
      MAINTAINERS - Deprecate the P: entry and describe M: more thoroughly

 Documentation/SubmittingPatches |    4 +
 MAINTAINERS                     | 2690 +++++++++++++--------------------------
 scripts/get_maintainer.pl       |  232 +++-
 3 files changed, 1073 insertions(+), 1853 deletions(-)


