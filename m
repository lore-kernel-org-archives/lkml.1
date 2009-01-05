Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbZAEPvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbZAEPvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbZAEPvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 10:51:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52185 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136AbZAEPvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 10:51:15 -0500
Date: Mon, 5 Jan 2009 10:36:29 -0600
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 2.6.29
Message-ID: <20090105163629.GA3880@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull dlm updates for 2.6.29 from:

 git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

Most have been in linux-next for quite a while.  They are minor cleanups,
and some additions to debugfs dumps to help with debugging.
Thanks,
Dave

Andrew Morton (1):
     dlm: fs/dlm/ast.c: fix warning

David Teigland (5):
     dlm: remove extra blocking callback check
     dlm: improve how bast mode handling
     dlm: change lock time stamping
     dlm: add time stamp of blocking callback
     dlm: add new debugfs entry

Harvey Harrison (1):
     dlm: trivial annotation of be16 value

Steven Whitehouse (3):
     dlm: fix up memory allocation flags
     dlm: remove kmap/kunmap
     dlm: replace schedule with cond_resched

 fs/dlm/ast.c          |   56 ++++-----
 fs/dlm/ast.h          |    4 +-
 fs/dlm/debug_fs.c     |  310 ++++++++++++++++++++++++++++++++++++++++---------
 fs/dlm/dir.c          |   18 ++--
 fs/dlm/dlm_internal.h |    4 +-
 fs/dlm/lock.c         |   31 +++---
 fs/dlm/lowcomms.c     |    8 +-
 fs/dlm/memory.c       |    6 +-
 fs/dlm/midcomms.c     |    2 +-
 fs/dlm/netlink.c      |    1 -
 fs/dlm/user.c         |    4 +-
 fs/dlm/user.h         |    2 +-
 12 files changed, 316 insertions(+), 130 deletions(-)

