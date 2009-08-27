Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbZH0NrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbZH0NrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 09:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZH0NrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 09:47:04 -0400
Received: from mail-yw0-f184.google.com ([209.85.211.184]:61047 "EHLO
	mail-yw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbZH0NrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 09:47:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cbIiWEhWmdsGR8l9h2MB+zn63YIrNSQb+y7Q1MyKodiJsG3cQcaE2jb3sCbPjynFAX
         YqYXz2XrEhzfY9EHFG7EFH2yKt6rR2O2mDgIJllYXZ8txjM+aKweFjCOqsS7Cv6stVid
         uO+MovHLYNIlCzXDPp+gUjbgCoiyCjuclgpQ8=
MIME-Version: 1.0
Date: Thu, 27 Aug 2009 08:47:04 -0500
Message-ID: <a4e6962a0908270647r182191ftf833590924f066b8@mail.gmail.com>
Subject: [GIT PULL] 9p bug fixes for 2.6.31-rc7
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull this set of bug fixes and minor documentation
revisions.  Thanks.

The following changes since commit 3edf2fb9d80a46d6c32ba12547a42419845b4b76:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jbarnes/pci-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Abhishek Kulkarni (10):
      9p: Check for error in return value of v9fs_fid_add
      9p: Fix possible inode leak in v9fs_get_inode.
      9p: minor comment fixes
      9p: Fix possible memleak in v9fs_inode_from fid.
      9p: Fix v9fs show_options
      9p: Fix possible regressions when ->get_sb fails.
      9p: Remove redundant inode uid/gid assignment
      9p: Add missing cast for the error return value in v9fs_get_inode
      net/9p: insulate the client against an invalid error code sent
by a 9p server
      9p: remove unnecessary v9fses->options which duplicates the mount string

Eric Van Hensbergen (1):
      9p: update documentation pointers

 Documentation/filesystems/9p.txt |    3 +
 fs/9p/v9fs.c                     |   21 ++-----
 fs/9p/v9fs.h                     |    1 -
 fs/9p/vfs_inode.c                |  126 +++++++++++++++++++------------------
 fs/9p/vfs_super.c                |   39 ++++--------
 net/9p/client.c                  |   21 +++----
 net/9p/error.c                   |    2 +-
 net/9p/trans_fd.c                |    8 +-
 net/9p/trans_rdma.c              |    9 ++-
 net/9p/trans_virtio.c            |   11 +--
 10 files changed, 107 insertions(+), 134 deletions(-)
