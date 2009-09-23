Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbZIWS0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbZIWS0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 14:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbZIWS0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 14:26:38 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:43039 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbZIWS0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 14:26:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=oNOP+sVaMju4rQ0XQ/4cpsIvovdkFxW+mcgJDzeihdHEYQgmLRyfCN6YcaPYh1In21
         UM3LsplFkizm1XHRtS34rgv8oNnavKHhDNBQNqyJQ3gTiwn++6GUzoob9IuyPecZ89Ij
         tehroJ15fUcY27qeHlYm34IMeyYWAz6rDiKnU=
MIME-Version: 1.0
Date: Wed, 23 Sep 2009 13:26:41 -0500
Message-ID: <a4e6962a0909231126t734ee6e0i2be6d110e1d07758@mail.gmail.com>
Subject: [GIT PULL] 9p changes for 2.6.32-rc1
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 7043078630bbc9eb908a56e08077c5abe7f2d311:
  David Howells (1):
        MN10300: Handle removal of struct uart_info

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Abhishek Kulkarni (4):
      9p: Use the i_size_[read, write]() macros instead of using
inode->i_size directly.
      9p: Fix the incorrect update of inode size in v9fs_file_write()
      9p: Add fscache support to 9p
      9p: Update documentation to add fscache related bits

 Documentation/filesystems/9p.txt |   40 ++--
 fs/9p/Kconfig                    |    9 +
 fs/9p/Makefile                   |    3 +-
 fs/9p/cache.c                    |  474 ++++++++++++++++++++++++++++++++++++++
 fs/9p/cache.h                    |  176 ++++++++++++++
 fs/9p/v9fs.c                     |  196 ++++++++++++++--
 fs/9p/v9fs.h                     |   13 +-
 fs/9p/v9fs_vfs.h                 |    6 +
 fs/9p/vfs_addr.c                 |   88 +++++++-
 fs/9p/vfs_file.c                 |   25 ++-
 fs/9p/vfs_inode.c                |   61 +++++-
 fs/9p/vfs_super.c                |   16 +-
 include/net/9p/9p.h              |    3 +
 13 files changed, 1045 insertions(+), 65 deletions(-)
 create mode 100644 fs/9p/cache.c
 create mode 100644 fs/9p/cache.h
