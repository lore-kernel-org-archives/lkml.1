Return-Path: <linux-kernel-owner+w=401wt.eu-S1758835AbZFMAQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbZFMAQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 20:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZFMAQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 20:16:02 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:31797 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZFMAQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 20:16:01 -0400
Date: Fri, 12 Jun 2009 17:14:34 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT PULL] configfs updates for 2.6.31
Message-ID: <20090613001434.GH22662@mail.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.4A32EFB7.011B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, et al,
	Here are the configfs updates for 2.6.31.  These two patches
modify and annotate configfs for lockdep, eliminating a long-standing
false warning.  Please pull.

Joel

(I tested the pull this time ;-)

The following changes since commit b4348f32dae3cb6eb4bc21c7ed8f76c0b11e9d6a:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://oss.sgi.com/xfs/xfs

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/configfs.git upstream-linus

Louis Rilling (2):
      configfs: Silence lockdep on mkdir() and rmdir()
      configfs: Rework configfs_depend_item() locking and make lockdep happy

 fs/configfs/configfs_internal.h |    3 +
 fs/configfs/dir.c               |  196 +++++++++++++++++++++++++++------------
 fs/configfs/inode.c             |   38 ++++++++
 3 files changed, 178 insertions(+), 59 deletions(-)
-- 

Life's Little Instruction Book #497

	"Go down swinging."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
