Return-Path: <linux-kernel-owner+w=401wt.eu-S1752125AbZIXVkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbZIXVkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 17:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZIXVkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 17:40:51 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58166 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbZIXVku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 17:40:50 -0400
Date: Thu, 24 Sep 2009 16:40:51 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ecryptfs-devel@lists.launchpad.net
Subject: [GIT PULL] eCryptfs fixes for 2.6.32
Message-ID: <20090924214049.GA29265@boomer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 94e0fb086fc5663c38bbc0fe86d698be8314f82f:
  Linus Torvalds (1):
        Merge branch 'drm-intel-next' of git://git.kernel.org/.../anholt/drm-intel

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git for-linus

Dave Hansen (1):
      ecryptfs: improved dependency checking and reporting

Roland Dreier (2):
      ecryptfs: Remove unneeded locking that triggers lockdep false positives
      eCryptfs: Fix lockdep-reported AB-BA mutex issue

Tyler Hicks (6):
      eCryptfs: Handle unrecognized tag 3 cipher codes
      eCryptfs: Check for O_RDONLY lower inodes when opening lower files
      eCryptfs: Filename encryption only supports password auth tokens
      eCryptfs: Validate global auth tok keys
      eCryptfs: Propagate vfs_read and vfs_write return codes
      eCryptfs: Prevent lower dentry from going negative during unlink

 fs/ecryptfs/Kconfig      |    4 +++-
 fs/ecryptfs/crypto.c     |   39 ++++++++++++++++++++++-----------------
 fs/ecryptfs/inode.c      |    2 ++
 fs/ecryptfs/keystore.c   |   39 ++++++++++++++++++++++++++-------------
 fs/ecryptfs/kthread.c    |   24 ++++++++----------------
 fs/ecryptfs/main.c       |    3 +--
 fs/ecryptfs/mmap.c       |    4 +++-
 fs/ecryptfs/read_write.c |   32 ++++++++++++--------------------
 fs/ecryptfs/super.c      |    2 --
 9 files changed, 77 insertions(+), 72 deletions(-)
