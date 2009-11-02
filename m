Return-Path: <linux-kernel-owner+w=401wt.eu-S932313AbZKBUGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbZKBUGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 15:06:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbZKBUGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 15:06:05 -0500
Received: from mail-qy0-f174.google.com ([209.85.221.174]:50991 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbZKBUGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 15:06:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=gec2YhDf37Uy66udGyDLCf9dULaefiBykQTJHmypuhVAWkZaahSDahEjbf/7pKJHYw
         ERhu/Quny1K01f+LCtsHaeke1azFxztex03rOAtmxH0rKAu+KfYLE1r8dKw/s/1sinkq
         E2o34IhFO+b8hKvxF4aY6JO5zv/boMc2ekrQw=
MIME-Version: 1.0
Date: Mon, 2 Nov 2009 14:06:07 -0600
Message-ID: <a4e6962a0911021206r62989ba7pf8a204bcf440da47@mail.gmail.com>
Subject: [GIT PULL] v9fs bug fixes
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

   Please pull a couple of bug fixes for the 9P filesystem for 2.6.32-rc5.

The following changes since commit b6727b12dd2ffb4a890eb5b13a298230c29ba45d:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../gregkh/staging-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Eric Van Hensbergen (1):
      9p: fix readdir corner cases

Martin Stava (2):
      9p: fix a small bug in readdir for long directories
      9p: fix readlink

 fs/9p/vfs_dir.c         |   93 ++++++++++++++++++++++++++++++++++-------------
 fs/9p/vfs_inode.c       |    5 +--
 include/net/9p/client.h |    7 ++--
 net/9p/client.c         |    5 +--
 4 files changed, 74 insertions(+), 36 deletions(-)


       Thanks,

            -eric
