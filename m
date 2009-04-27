Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbZD0Nbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbZD0Nbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 09:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbZD0Nbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 09:31:42 -0400
Received: from thunk.org ([69.25.196.29]:56450 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbZD0Nbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 09:31:41 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 fixes for 2.6.30-rc3
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1LyQvn-0008N6-6y@closure.thunk.org>
Date: Mon, 27 Apr 2009 09:31:35 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab the following fixes for ext4.

                                                - Ted

Theodore Ts'o (3):
      ext4: Fix softlockup caused by illegal i_file_acl value in on-disk inode
      ext4: Ignore i_file_acl_high unless EXT4_FEATURE_INCOMPAT_64BIT is present
      ext4: Do not try to validate extents on special files

 fs/ext4/inode.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)
