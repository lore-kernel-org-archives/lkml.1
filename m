Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723Ab0ATGEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab0ATGEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 01:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037Ab0ATGEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 01:04:36 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40937 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab0ATGEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 01:04:35 -0500
Date: Wed, 20 Jan 2010 00:04:32 -0600
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ecryptfs-devel@lists.launchpad.net
Subject: [GIT PULL] eCryptfs fixes for 2.6.33
Message-ID: <20100120060431.GA1480@fedora-virt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 24bc7347da73a9ed3383056c3d0f28c0e361621e:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../wim/linux-2.6-watchdog

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git for-linus

Dan Carpenter (1):
      ecryptfs: use after free

Erez Zadok (5):
      ecryptfs: initialize private persistent file before dereferencing pointer
      ecryptfs: don't ignore return value from lock_rename
      ecryptfs: remove unnecessary d_drop calls in ecryptfs_link
      ecryptfs: pass matching flags to interpose as defined and used there
      ecryptfs: fix interpose/interpolate typos in comments

Julia Lawall (1):
      ecryptfs: Eliminate useless code

Tyler Hicks (3):
      eCryptfs: Use notify_change for truncating lower inodes
      eCryptfs: Add getattr function
      eCryptfs: Remove mmap from directory operations

 fs/ecryptfs/crypto.c |    4 +-
 fs/ecryptfs/file.c   |   17 +++---
 fs/ecryptfs/inode.c  |  134 ++++++++++++++++++++++++++++++++++++--------------
 fs/ecryptfs/main.c   |    4 +-
 4 files changed, 109 insertions(+), 50 deletions(-)
