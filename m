Return-Path: <linux-kernel-owner+w=401wt.eu-S1755694AbZEXCiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbZEXCiP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 22:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbZEXCiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 22:38:02 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1424 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbZEXCiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 22:38:01 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 00/18] MAINTAINERS and scripts/get_maintainer.pl updates
Date: Sat, 23 May 2009 19:37:31 -0700
Message-Id: <cover.1243131992.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few fixes and updates.

This patchset does not change the style of
MAINTAINERS P: and M: lines to be integrated
M: "Full Name <address.tld>"

One day.  Maybe.

Joe Perches (18):
  scripts/get_maintainer.pl - Output first field only in mailing lists and after maintainers.
  scripts/get_maintainer.pl - Better fix for subscriber-only mailing lists
  scripts/get_maintainer.pl - improve --git-chief-penquins (Linus Torvalds) filtering
  scripts/get_maintainer.pl - Warn on missing git or git repository
  scripts/get_maintainer.pl - support M: lines with names and multiple entries per M: line
  scripts/get_maintainer.pl - Better email name quoting
  scripts/get_maintainer.pl - Support both "P:/M:" and integrated "M:" lines
  scripts/get_maintainer.pl - Don't print maintainers when not requested
  scripts/get_maintainer.pl - Allow 8 bit characters in email addresses
  scripts/get_maintainer.pl - change "die" to "warn" when command line file is not a patch
  MAINTAINERS - Swap mismarked ECRYPT FS M: and P: entries
  MAINTAINERS - Pair EDAC-E752X P: and M: entries
  MAINTAINERS - Add file patterns to "THE REST"
  MAINTAINERS - Update M32R file patterns after rename
  MAINTAINERS - Mark ALSA lists as moderated
  MAINTAINERS - Remove L:	linux-kernel@vger.kernel.org from all but "THE REST"
  MAINTAINERS - Mention scripts/get_maintainer.pl in the preface
  MAINTAINERS - Add file pattern to CISCO FCOE HBA DRIVER

 MAINTAINERS               |  108 ++++-----------------
 scripts/get_maintainer.pl |  234 ++++++++++++++++++++++++++++++++++++---------
 2 files changed, 208 insertions(+), 134 deletions(-)

