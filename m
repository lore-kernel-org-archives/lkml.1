Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbZHXVhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbZHXVhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZHXVg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:36:57 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:42933 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbZHXVg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:36:56 -0400
Date: Mon, 24 Aug 2009 14:34:30 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [GIT PULL] ocfs2 fixes for 2.6.31-rc7
Message-ID: <20090824213430.GD7698@mail.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4A9307EA.01A0:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, et al,
	Here are a couple small ocfs2 fixes for 2.6.31.  They fix
user-visible bugs, so I wanted to make sure they were in this cycle.
	Please pull.

Joel

The following changes since commit b409d7a0ab46fe530efe52734984b4ed5d46c3eb:
  Jan Kara (1):
        ocfs2: Fix possible deadlock when extending quota file

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Goldwyn Rodrigues (1):
      ocfs2/dlm: Wait on lockres instead of erroring cancel requests

Jan Kara (3):
      ocfs2: Handle quota file corruption more gracefully
      ocfs2: Don't oops in ocfs2_kill_sb on a failed mount
      ocfs2: Add missing lock name

Tao Ma (1):
      ocfs2: release the buffer head in ocfs2_do_truncate.

 fs/ocfs2/alloc.c         |    2 +-
 fs/ocfs2/dlm/dlmunlock.c |    4 ++--
 fs/ocfs2/ocfs2_lockid.h  |    1 +
 fs/ocfs2/quota_global.c  |   10 ++++++++++
 fs/ocfs2/super.c         |    6 +++++-
 5 files changed, 19 insertions(+), 4 deletions(-)
-- 

Life's Little Instruction Book #99

	"Think big thoughts, but relish small pleasures."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
