Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbYEOWYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbYEOWYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 18:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbYEOWYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 18:24:09 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:58316 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751687AbYEOWYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 18:24:06 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subect: [GIT PULL] ext4 bugfixes
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1Jwlro-0000lF-1g@closure.thunk.org>
Date: Thu, 15 May 2008 18:24:04 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

These are all cleanups and bug fixes for 2.6.26.

Many thanks,

						- Ted

 fs/ext4/balloc.c  |   17 +++++++----
 fs/ext4/mballoc.c |   66 +++++++++++++++++++++++++++++--------------
 fs/ext4/super.c   |   80 ++++++++++++++++++++++++++++++++++++++--------------
 fs/jbd2/commit.c  |    2 +
 4 files changed, 116 insertions(+), 49 deletions(-)

Aneesh Kumar K.V (1):
      ext4: Retry block allocation if new blocks are allocated from system zone.

Jan Kara (4):
      ext4: correct mount option parsing to detect when quota options can be changed
      ext4: Fix mount messages when quota disabled
      ext4: fix synchronization of quota files in journal=data mode
      ext4: fix typos in messages and comments (journalled -> journaled)

Mingming Cao (1):
      jbd2: update transaction t_state to T_COMMIT fix

Valerie Clement (1):
      ext4: mballoc fix mb_normalize_request algorithm for 1KB block size filesystems

