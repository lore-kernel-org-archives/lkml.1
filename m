Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322Ab0CMPdO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 10:33:14 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34316 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759275Ab0CMPdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 10:33:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Tc5cAMieKOImpWP41UKI682VtT08awi+feL5x5Q/JV3xO7JIQSNMR8ae8bwR9CTR9b
         HoIYdkHq4fCtzjvaAU3XxULv6+5xqIry2+iAAg0UKjtqiNo6xBmwHhP1zzYik+dWkYYJ
         DUl1wOIA2mANrIo9FUX4aGxQcSvUwZqsfpGwA=
MIME-Version: 1.0
Date: Sat, 13 Mar 2010 09:33:12 -0600
Message-ID: <a4e6962a1003130733s15ae6e93ld2060ede5f0861e3@mail.gmail.com>
Subject: [GIT PULL] 9p file system bug fixes
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,
  Please pull the following bug fixes for the 9p file system:

The following changes since commit daf9fe2ee9a203c4fc555cfe5c5f3d9f660e743c:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../sameo/mfd-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Aneesh Kumar K.V (3):
      net/9p: Use the tag name in the config space for identifying mount point
      net/9p: Add sysfs mount_tag file for virtio 9P device
      fs/9p: re-init the wstat in readdir loop

Sachin Prabhu (1):
      9p: Skip check for mandatory locks when unlocking

Sripathi Kodi (1):
      9p: Change the name of new protocol from 9p2010.L to 9p2000.L

jvrao (1):
      9p: Fixes a simple bug enabling writes beyond 2GB.

 fs/9p/v9fs.h              |    6 ++--
 fs/9p/vfs_dir.c           |   11 +++++++-
 fs/9p/vfs_file.c          |    4 +-
 include/linux/virtio.h    |    1 +
 include/linux/virtio_9p.h |   12 ++++++++
 include/net/9p/client.h   |    4 +-
 net/9p/client.c           |   16 +++++-----
 net/9p/trans_virtio.c     |   64 ++++++++++++++++++++++++++++++++++++++++----
 8 files changed, 96 insertions(+), 22 deletions(-)

    Thanks,

          -eric
