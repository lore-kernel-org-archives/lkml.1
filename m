Return-Path: <linux-kernel-owner+w=401wt.eu-S1752087AbZH0MIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbZH0MIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZH0MIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:08:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbZH0MIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:08:46 -0400
Subject: [GIT PULL] notification tree - inotify fixes
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 27 Aug 2009 08:08:40 -0400
Message-Id: <1251374920.2280.19.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1e23502cc57cef33455ac7cb9111e3c6d991a894:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://git.infradead.org/users/eparis/notify.git for-linus

Eric Paris (3):
      inotify: seperate new watch creation updating existing watches
      inotify: do not BUG on idr entries at inotify destruction
      inotify: fix locking around inotify watching in the idr

Eric W. Biederman (1):
      inotify: Ensure we alwasy write the terminating NULL.

 fs/notify/inotify/inotify_fsnotify.c |   33 +++++-
 fs/notify/inotify/inotify_user.c     |  229 +++++++++++++++++++++------------
 2 files changed, 177 insertions(+), 85 deletions(-)

