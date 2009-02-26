Return-Path: <linux-kernel-owner+w=401wt.eu-S1756371AbZBZT5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbZBZT5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 14:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZBZT5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 14:57:42 -0500
Received: from ns1.suse.de ([195.135.220.2]:46515 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbZBZT5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 14:57:42 -0500
Date: Thu, 26 Feb 2009 11:57:39 -0800
From: Mark Fasheh <mfasheh@suse.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git patches] Ocfs2 fixes
Message-ID: <20090226195739.GX17410@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/alloc.c         |   27 ++++++++++++++++++++++++++-
 fs/ocfs2/dlm/dlmmaster.c |   12 ++++++------
 fs/ocfs2/dlm/dlmthread.c |    3 +--
 fs/ocfs2/dlm/dlmunlock.c |    4 ++--
 fs/ocfs2/dlmglue.c       |   11 ++++++++---
 fs/ocfs2/ocfs2.h         |    3 +++
 fs/ocfs2/super.c         |    8 ++++++++
 fs/ocfs2/xattr.c         |   27 +++++++++++++++++----------
 8 files changed, 71 insertions(+), 24 deletions(-)

Sunil Mushran (4):
      ocfs2/dlm: Retract fix for race between purge and migrate
      ocfs2: Cleanup the lockname print in dlmglue.c
      ocfs2/dlm: Use ast_lock to protect ast_list
      ocfs2/dlm: Make dlm_assert_master_handler() kill itself instead of the asserter

Tao Ma (3):
      ocfs2: Access and dirty the buffer_head in mark_written.
      ocfs2: Use the right access_* method in ctime update of xattr.
      ocfs2: lock the metaecc process for xattr bucket

Tiger Yang (1):
      ocfs2: set gap to seperate entry and value when xattr in bucket

wengang wang (1):
      ocfs2: add IO error check in ocfs2_get_sector()

--
Mark Fasheh
