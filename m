Return-Path: <linux-kernel-owner+w=401wt.eu-S1758504AbZF2UCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504AbZF2UCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 16:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbZF2UBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 16:01:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34549 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025AbZF2UBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 16:01:53 -0400
Subject: [GIT PULL] notification tree - fsnotify assumes incorrectly
 positive parent dentry
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 29 Jun 2009 16:01:52 -0400
Message-Id: <1246305712.754.292.camel@dhcp235-23.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus please consider pulling from the notification tree.  There is one
patch in the tree which should fix an issue in which fsnotify assumed
that dentry->d_parent->d_inode != NULL.  This turns out to be false for
spufs and causes a panic.

-Eric

The following changes since commit 52989765629e7d182b4f146050ebba0abf2cb0b7:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://git.infradead.org/users/eparis/notify.git for-linus

Jeremy Kerr (1):
      fs: allow d_instantiate to be called with negative parent dentry

 include/linux/fsnotify_backend.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

