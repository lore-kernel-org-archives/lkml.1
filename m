Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117AbYLWQNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbYLWQNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYLWQNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:13:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48922 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbYLWQNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:13:02 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 00/10] dlm patches for 2.6.29
Date: Tue, 23 Dec 2008 10:58:33 -0600
Message-Id: <1230051523-5478-1-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These are the pending dlm patches for the 2.6.29 merge.  Most have been in
linux-next for quite a while.  They are minor cleanups, and some additions
to debugfs dumps to help with debugging.
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

