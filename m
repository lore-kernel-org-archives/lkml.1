Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZALSh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZALSh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbZALShQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:37:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47345 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbZALShP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:37:15 -0500
Date: Mon, 12 Jan 2009 13:22:34 -0600
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm fix for 2.6.29-rc1
Message-ID: <20090112192234.GB12875@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull two dlm patches for 2.6.29-rc1 from:

 git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

The first fixes incorrect seq_file usage in the debugfs lock dump.  I had
to rework all the seq ops which created the large diff.
The second isn't a fix, but changes an rwlock (used prominently in the
first patch) into a spinlock.
Thanks,
Dave

David Teigland (2):
      dlm: fix seq_file usage in debugfs lock dump
      dlm: change rsbtbl rwlock to spinlock

 fs/dlm/debug_fs.c     |  696 ++++++++++++++++++++++++-------------------------
 fs/dlm/dlm_internal.h |    2 +-
 fs/dlm/lock.c         |   26 +-
 fs/dlm/lockspace.c    |    2 +-
 fs/dlm/recover.c      |   10 +-
 5 files changed, 357 insertions(+), 379 deletions(-)

