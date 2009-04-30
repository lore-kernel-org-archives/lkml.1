Return-Path: <linux-kernel-owner+w=401wt.eu-S1764905AbZD3SQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764905AbZD3SQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 14:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762014AbZD3SQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 14:16:16 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:20686 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757797AbZD3SQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 14:16:14 -0400
Date: Thu, 30 Apr 2009 11:14:39 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT PULL] configfs fixes
Message-ID: <20090430181439.GC2762@mail.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010205.49F9EA9C.0144:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, et al,
	The configfs tree has one tiny warning fix.  Please pull.

Joel

The following changes since commit a939b96cccdb65df80a52447ec8e4a6d79c56dbb:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../rafael/suspend-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/jlbec/configfs.git upstream-linus

Subrata Modak (1):
      configfs: Fix Trivial Warning in fs/configfs/symlink.c

 fs/configfs/symlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index 932a92b..c8afa6b 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -135,7 +135,7 @@ int configfs_symlink(struct inode *dir, struct dentry *dentry, const char *symna
 	struct path path;
 	struct configfs_dirent *sd;
 	struct config_item *parent_item;
-	struct config_item *target_item;
+	struct config_item *target_item = NULL;
 	struct config_item_type *type;
 
 	ret = -EPERM;  /* What lack-of-symlink returns */

-- 

"You don't make the poor richer by making the rich poorer."
	- Sir Winston Churchill

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
