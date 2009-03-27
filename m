Return-Path: <linux-kernel-owner+w=401wt.eu-S1762915AbZC0UMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762915AbZC0UMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757148AbZC0UJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:09:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55426 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762033AbZC0UJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:09:47 -0400
Date: Fri, 27 Mar 2009 15:04:02 -0500
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 2.6.30
Message-ID: <20090327200402.GA23457@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull dlm updates for 2.6.30 from:

 git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

They have all been in linux-next for quite a while.  The notable fixes come
from using the dlm with ocfs2 and relate to handling lock cancelation and
large nodeids.
Dave

Christine Caulfield (1):
      dlm: replace idr with hash table for connections

David Teigland (3):
      dlm: clear defunct cancel state
      dlm: ignore cancel on granted lock
      dlm: fix length calculation in compat code

Joe Perches (2):
      dlm: use ipv6_addr_copy
      dlm: comment typo fixes

Steven Whitehouse (1):
      dlm: Change rwlock which is only used in write mode to a spinlock

 fs/dlm/dir.c          |   18 +++---
 fs/dlm/dlm_internal.h |    2 +-
 fs/dlm/lock.c         |   60 ++++++++++++++--
 fs/dlm/lockspace.c    |    2 +-
 fs/dlm/lowcomms.c     |  181 ++++++++++++++++++++++++++-----------------------
 fs/dlm/user.c         |   24 ++++---
 6 files changed, 175 insertions(+), 112 deletions(-)
