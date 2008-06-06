Return-Path: <linux-kernel-owner+w=401wt.eu-S1760904AbYFFWRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904AbYFFWRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 18:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbYFFWRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 18:17:23 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:55500 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751471AbYFFWRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 18:17:22 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 bugfixes
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1K4kFL-0005Z2-Fh@closure.thunk.org>
Date: Fri, 06 Jun 2008 18:17:19 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

These are all cleanups and bug fixes against 2.6.26-rc5

Thanks,

							- Ted

Aneesh Kumar K.V (1):
      ext4: Fix use of uninitialized data with debug enabled.

Eric Sandeen (1):
      ext4: enable barriers by default

Jose R. Santos (1):
      ext4: Fix uninit block group initialization with FLEX_BG

Josef Bacik (1):
      ext4: fix online resize bug

Theodore Ts'o (4):
      jbd2: Fix memory leak when verifying checksums in the journal
      jbd2: If a journal checksum error is detected, propagate the error to ext4
      ext4: Display the journal_async_commit mount option in /proc/mounts
      jbd2: Fix barrier fallback code to re-lock the buffer head

 Documentation/filesystems/ext4.txt |   12 +++++-
 fs/ext4/balloc.c                   |   71 +++++++++++++++++++++++++++++++-----
 fs/ext4/mballoc.c                  |    8 ++--
 fs/ext4/resize.c                   |    3 +-
 fs/ext4/super.c                    |   36 +++++++++++++++++-
 fs/jbd2/commit.c                   |    1 +
 fs/jbd2/recovery.c                 |   12 +++----
 include/linux/jbd2.h               |    3 ++
 8 files changed, 121 insertions(+), 25 deletions(-)
