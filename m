Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbYEPQdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbYEPQdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbYEPQca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:32:30 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33685 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbYEPQc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:32:28 -0400
Message-Id: <20080516163136.560107038@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 16 May 2008 18:31:36 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 00/22] vfs: fixes and cleanups (v3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since the last submission

  - drop patches already merged into mainline
  - Al pointed out problems with "vfs: truncate: append-only checking
    cleanup", drop it
  - re-add the security call into "fat: dont call notify_change" to be
    absolutely safe, but add comment noting this may not strictly be needed
  - small changes to "vfs: utimes cleanup", hopefully everyone will
    be happy with this

Thanks to Christoph and Al for the reviews.

The series contains the following changes:

1-7   filesystem cleanups/fixes, mainly removing vfs_* calls
8-12  vfs cleanups/fixes
13-22 add path_* helpers to check r/o bind mounts

It's against mainline and the 13-22 patches have a small conflict with
git-unionfs.patch.  They also break unionfs compilation.  Erez has a
patch for that, what are the preferred logistics for getting that into
-mm?

This series is also available from the following git tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git vfs-cleanups

Thanks,
Miklos

--
