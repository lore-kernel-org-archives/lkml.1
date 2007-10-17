Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbXJQVe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbXJQVe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 17:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759394AbXJQVeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 17:34:08 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:61567 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759351AbXJQVeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 17:34:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=FMSAleEoUONKZse8or58qBcNvSaen+J2rvuafRUum5YKA62ehUhAzMyny9oFKnobICNAy0/WqZikAs1a0wPYWXHhus6cQSIt4j4IzIEmBVbju1AhOFQGMcNzk9nWsrKaj5Bkb/Q43ndFoxksomQL3gpsEon/tu++WGH/IDBFjcg=
Message-ID: <a4e6962a0710171434l5ff6cecfib1e8b231b8b610b6@mail.gmail.com>
Date: Wed, 17 Oct 2007 16:34:02 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: torvalds@osdl.org
Subject: [GIT PULL] 9p patches for 2.6.24 merge window
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the 'for-linus' branch of:
  git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git/ for-linus

This tree contains the following:

Latchesar Ionkov(3):
  attach-per-user support
  rename uid and gid parameters
  define session flags

Eric Van Hensbergen(4)
  remove sysctl code
  fix bad kconfig cross-dependency
  soften invalidationin loose mode
  make transports dynamic

There are a few patches relating to a virtio transport support that
I'm holding back until I know Rusty's lguest series is merged.

 b/Documentation/filesystems/9p.txt |   22 +
 b/fs/9p/fid.c                      |  157 +++++++++++--
 b/fs/9p/v9fs.c                     |  189 +++++++---------
 b/fs/9p/v9fs.h                     |   38 +--
 b/fs/9p/vfs_file.c                 |    6
 b/fs/9p/vfs_inode.c                |   50 ++--
 b/fs/9p/vfs_super.c                |   19 -
 b/include/net/9p/9p.h              |   21 -
 b/include/net/9p/client.h          |    9
 b/include/net/9p/conn.h            |    4
 b/include/net/9p/transport.h       |   27 +-
 b/net/9p/Kconfig                   |   10
 b/net/9p/Makefile                  |    5
 b/net/9p/client.c                  |   13 -
 b/net/9p/conv.c                    |   32 ++
 b/net/9p/mod.c                     |   71 +++++-
 b/net/9p/mux.c                     |    5
 b/net/9p/trans_fd.c                |  419 +++++++++++++++++++++++--------------
 net/9p/sysctl.c                    |   81 -------
 19 files changed, 689 insertions(+), 489 deletions(-)


                Thanks,
                      -eric
