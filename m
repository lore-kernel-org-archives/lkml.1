Return-Path: <linux-kernel-owner+w=401wt.eu-S1756403AbZGBW5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbZGBW5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 18:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbZGBW5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 18:57:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59362 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069AbZGBW5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 18:57:23 -0400
Subject: [GIT PULL] notification tree - inotify does not decrement use count
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 02 Jul 2009 18:57:16 -0400
Message-Id: <1246575436.2855.15.camel@dhcp235-23.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus please consider pulling from the notification tree.  There is one
patch in the tree which should fix an issue in which the inotify device
use count is not decremented when a user closes the inotify file
descriptor and thus normal inotify use could improperly hit the per user
limits on inotify devices.

-Eric

The following changes since commit d960eea974f5e500c0dcb95a934239cc1f481cfd:
  Randy Dunlap (1):
        kernel-doc: move ignoring kmemcheck

are available in the git repository at:

  git://git.infradead.org/users/eparis/notify.git for-linus

Keith Packard (1):
      fs/notify/inotify: decrement user inotify count on close

 fs/notify/inotify/inotify_user.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

