Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbZLWVRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbZLWVRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbZLWVRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:17:49 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:21944 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbZLWVRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:17:48 -0500
Date: Wed, 23 Dec 2009 13:16:46 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [GIT PULL] ocfs2 fixes for 2.6.33
Message-ID: <20091223211645.GA5502@mail.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B3288ED.0058:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,
	This is the first of a couple small ocfs2 pulls for this cycle.
Sorry they are after the merge window; fixes kept dribbling in, and
eventually picked up a conflict against already merged stuff.
	This first batch is before that conflict and consists entirely
of fixes.  I'm sending them as tested rather than rebasing them.  The
next batch will be both fixes and small functional changes.
	Please pull.

The following changes since commit 56f3f55cf9b604b924353ab6fcdac5fee5637ae3:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../sameo/mfd-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Tao Ma (4):
      ocfs2: Find proper end cpos for a leaf refcount block.
      ocfs2: refcounttree.c cleanup.
      ocfs2: Add reflinked file's inode to inode hash eariler.
      ocfs2: Set i_nlink properly during reflink.

 fs/ocfs2/alloc.c        |   10 ++--
 fs/ocfs2/alloc.h        |    5 ++
 fs/ocfs2/namei.c        |    5 +-
 fs/ocfs2/refcounttree.c |  150 ++++++++++++++++++++++++++++++++++++----------
 4 files changed, 131 insertions(+), 39 deletions(-)
-- 

"But then she looks me in the eye
 And says, 'We're going to last forever,'
 And man you know I can't begin to doubt it.
 Cause it just feels so good and so free and so right,
 I know we ain't never going to change our minds about it, Hey!
 Here comes my girl."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel
