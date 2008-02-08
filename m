Return-Path: <linux-kernel-owner+w=401wt.eu-S935258AbYBHLa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935258AbYBHLa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 06:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935158AbYBHLaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 06:30:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934889AbYBHLaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 06:30:12 -0500
Date: Fri, 8 Feb 2008 05:21:20 -0600
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 2.6.25 (batch 2)
Message-ID: <20080208112120.GA17595@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull a second batch of dlm updates for 2.6.25 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

Al Viro (13):
      dlm: use proper C for dlm/requestqueue stuff (and fix alignment bug)
      dlm: dlm_process_incoming_buffer() fixes
      dlm: do not byteswap rcom_lock
      dlm: do not byteswap rcom_config
      dlm: use proper type for ->ls_recover_buf
      dlm: missing length check in check_config()
      dlm: validate data in dlm_recover_directory()
      dlm: verify that places expecting rcom_lock have packet long enough
      dlm: receive_rcom_lock_args() overflow check
      dlm: make find_rsb() fail gracefully when namelen is too large
      dlm: fix overflows when copying from ->m_extra to lvb
      dlm: fix dlm_dir_lookup() handling of too long names
      dlm: dlm/user.c input validation fixes

David Teigland (2):
      dlm: proper types for asts and basts
      dlm: eliminate astparam type casting

Denis Cheng (1):
      dlm: add __init and __exit marks to init and exit functions

 fs/dlm/ast.c          |    9 ++--
 fs/dlm/config.c       |    2 +-
 fs/dlm/debug_fs.c     |    8 +--
 fs/dlm/dir.c          |   28 +++++++++--
 fs/dlm/dlm_internal.h |   53 +++++++++++--------
 fs/dlm/lock.c         |  139 +++++++++++++++++++++++++++++--------------------
 fs/dlm/lock.h         |    2 +-
 fs/dlm/lockspace.c    |    2 +-
 fs/dlm/memory.c       |    4 +-
 fs/dlm/midcomms.c     |   33 +++++++-----
 fs/dlm/netlink.c      |    9 ++--
 fs/dlm/rcom.c         |   63 ++++++++++++++--------
 fs/dlm/recover.c      |    4 +-
 fs/dlm/requestqueue.c |   12 ++--
 fs/dlm/requestqueue.h |    2 +-
 fs/dlm/user.c         |   29 ++++------
 fs/dlm/util.c         |   61 ---------------------
 17 files changed, 235 insertions(+), 225 deletions(-)
