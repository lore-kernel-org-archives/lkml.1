Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941AbZFSQuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbZFSQuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 12:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbZFSQu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 12:50:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46720 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758486AbZFSQu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 12:50:27 -0400
Subject: [GIT PULL] notification tree - inotify use after free
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 19 Jun 2009 12:50:20 -0400
Message-Id: <1245430220.19333.51.camel@dhcp235-23.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus please consider pulling from the notification tree.  There is one
patch in the tree which should fix a double free/use after free race
which one person hit and reported to me off list.  The patch has been
tested by myself and by the reporter and fixes the problem.  This has
been the only problem reported since the entirely new fsnotify
infrastructure and the dnotify/inotify rewrites went in.

-Eric

The following changes since commit 0732f87761dbe417cb6e084b712d07e879e876ef:
  Linus Torvalds (1):
        Merge branch 'for_linus' of git://git.kernel.org/.../tytso/ext4

are available in the git repository at:

  git://git.infradead.org/users/eparis/notify.git for-linus

Eric Paris (1):
      inotify: inotify_destroy_mark_entry could get called twice

 fs/notify/inotify/inotify.h          |    3 ++-
 fs/notify/inotify/inotify_fsnotify.c |    2 +-
 fs/notify/inotify/inotify_user.c     |   32 +++++---------------------------
 3 files changed, 8 insertions(+), 29 deletions(-)


