Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab0CEVNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 16:13:00 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:63287 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab0CEVM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 16:12:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=HOWv1C/FWf/evt3z7ww+UUCF+Wnqsmo365l9B8R6kIPSldaNbhnvVSzmFW2UqQByNn
         jG5uEHM1GfBKFQK1olaTk32wFLK5a07CFLLfzw4dKz1//FE4KnBSngORmC3nwm9CJois
         99iWQ/YnJQazgS6tvQ6pseqXbNhXg/j9s9Fb8=
MIME-Version: 1.0
Date: Fri, 5 Mar 2010 15:12:57 -0600
Message-ID: <a4e6962a1003051312r2b6e12deg5c647c1cd5c0e321@mail.gmail.com>
Subject: GIT PULL] 9p file system additions for merge window
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: V9FS Developers <v9fs-developer@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 64ba9926759792cf7b95f823402e2781edd1b5d4:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.open-osd.org/linux-open-osd

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Aneesh Kumar K.V (4):
      net/9p: Add multi channel support.
      net/9p: Remove MAX_9P_CHAN limit
      net/9p: Handle mount errors correctly.
      fs/9p: Add hardlink support to .u extension

Sripathi Kodi (4):
      9P2010.L handshake: Add VFS flags
      9P2010.L handshake: Add mount option
      9P2010.L handshake: Remove "dotu" variable
      9P2010.L handshake: .L protocol negotiation

 fs/9p/fid.c               |    2 +-
 fs/9p/v9fs.c              |    8 ++--
 fs/9p/v9fs.h              |   23 ++++++---
 fs/9p/vfs_dir.c           |    2 +-
 fs/9p/vfs_file.c          |    4 +-
 fs/9p/vfs_inode.c         |   48 +++++++++++++------
 include/linux/virtio_9p.h |    3 -
 include/net/9p/client.h   |   18 +++++++-
 net/9p/client.c           |  114 ++++++++++++++++++++++++++++++++++-----------
 net/9p/protocol.c         |   74 ++++++++++++++++-------------
 net/9p/protocol.h         |    6 +-
 net/9p/trans_virtio.c     |   80 +++++++++++++------------------
 12 files changed, 238 insertions(+), 144 deletions(-)

thanks,

     -eric
