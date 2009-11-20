Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbZKTCs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbZKTCs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 21:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758243AbZKTCsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 21:48:25 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:22870 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758242AbZKTCsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 21:48:25 -0500
Date: Thu, 19 Nov 2009 18:47:02 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [GIT PULL] ocfs2 updates for 2.6.32-rc8
Message-ID: <20091120024701.GA12968@mail.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B06036F.01B5:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus et al,
	Here are a few small fixes for ocfs2.  The most important one 
fixes a crash when duplicating inline data properly.
	Please pull.

Joel

The following changes since commit 964fe080d94db82a3268443e9b9ece4c60246414:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../rusty/linux-2.6-for-linus

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Coly Li (1):
      ocfs2: return f_fsid info in ocfs2_statfs()

Joel Becker (1):
      ocfs2: Return -EINVAL when a device is not ocfs2.

Sunil Mushran (2):
      ocfs2: Refresh documentation
      ocfs2: Trivial cleanup of jbd compatibility layer removal

Tao Ma (2):
      ocfs2: Move ocfs2_complete_reflink to the right place.
      ocfs2: duplicate inline data properly during reflink.

 Documentation/filesystems/ocfs2.txt |    6 ++--
 fs/ocfs2/file.c                     |    3 +-
 fs/ocfs2/ocfs2.h                    |    7 +---
 fs/ocfs2/refcounttree.c             |   69 ++++++++++++++++++++++++++++++++---
 fs/ocfs2/super.c                    |   20 +++++++----
 fs/ocfs2/uptodate.c                 |    5 ---
 6 files changed, 83 insertions(+), 27 deletions(-)

-- 

Life's Little Instruction Book #232

	"Keep your promises."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
