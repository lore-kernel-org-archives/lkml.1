Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab0BITGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:06:53 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:35163 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab0BITGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:06:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=JXNdKpixU87k2tvFqU+PsgBXlmK6J46y/rnFIzMLW0otV0NJevh376bNwCxOolI0Kb
         FrlsoMnXwmADe8Pcnl63CVg6iNQRafNB/7pCMixOLdFM5L95MyboE8pty+dbIiarN5jL
         YdYHDf0rOS8OYOpN9a3ZYIUB2m/9XjEmvjkAM=
MIME-Version: 1.0
Date: Tue, 9 Feb 2010 13:06:49 -0600
Message-ID: <a4e6962a1002091106g3ffaa6a4ga8070b53d0b1becd@mail.gmail.com>
Subject: [GiT PULL] 9p file system bug fixes for 2.6.33-rc7
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 08c4f1b096cc2468908ea58a77d2ef92ef765c52:
  Linus Torvalds (1):
        Merge branch 'v4l_for_linus' of git://linuxtv.org/fixes

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Aneesh Kumar K.V (1):
      9p: Fix the kernel crash on a failed mount

Eric Van Hensbergen (6):
      net/9p: fix virtio transport to correctly update status on connect
      net/9p: fail when user specifies a transport which we can't find
      net/9p: fix statsize inside twstat
      9p: fix option parsing
      9p: fix memory leak in v9fs_parse_options()
      9p: fix p9_client_destroy unconditional calling v9fs_put_trans

M. Mohan Kumar (1):
      9p: Include fsync support for 9p client

 fs/9p/v9fs.c          |   33 +++++++++++++++++++-----------
 fs/9p/v9fs_vfs.h      |    1 +
 fs/9p/vfs_file.c      |   19 +++++++++++++++++
 fs/9p/vfs_inode.c     |    2 +-
 net/9p/client.c       |   53 ++++++++++++++++++++++++++++++++----------------
 net/9p/trans_fd.c     |   10 +++++---
 net/9p/trans_rdma.c   |    9 ++++---
 net/9p/trans_virtio.c |    4 ++-
 8 files changed, 91 insertions(+), 40 deletions(-)

thanks,

      -eric
