Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966300Ab0BZVt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 16:49:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966171Ab0BZVtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 16:49:55 -0500
Date: Fri, 26 Feb 2010 15:49:30 -0600
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 2.6.34
Message-ID: <20100226214930.GB25083@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull dlm updates for 2.6.34 from:

 git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

There are two significant fixes that enforce correct ordering of blocking
and completion callbacks for remote locks.  Both ocfs2 and gfs2 have run
into problems with mis-ordered blocking callbacks that these fix.
Thanks,
Dave


David Teigland (3):
      dlm: fix ordering of bast and cast
      dlm: send reply before bast
      dlm: use bastmode in debugfs output

Steven Whitehouse (1):
      dlm: Send lockspace name with uevents


 fs/dlm/ast.c          |   74 +++++++++++++++++++++++-------
 fs/dlm/ast.h          |    4 +-
 fs/dlm/debug_fs.c     |    2 +-
 fs/dlm/dlm_internal.h |   10 +++-
 fs/dlm/lock.c         |  120 ++++++++++++++++++++++++++++++++++++------------
 fs/dlm/lockspace.c    |   14 +++++-
 fs/dlm/user.c         |   10 +++--
 fs/dlm/user.h         |    4 +-
 8 files changed, 180 insertions(+), 58 deletions(-)

