Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab0CHWAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 17:00:39 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:25076 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912Ab0CHWAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 17:00:37 -0500
Date: Mon, 8 Mar 2010 17:00:22 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <h.peter.anvin@intel.com>
Subject: [GIT PULL] Btrfs pull for .34
Message-ID: <20100308220022.GB14976@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <h.peter.anvin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B957379.0146:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This merge window conflicted with my spring break skiing window, so this
pull request is very very short.  I have a larger one in testing but
really wanted to get this out.

Linus, please pull the btrfs-unstable master branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

The RB_ROOT patch changes btrfs to use the proper rbtree initializer,
and Josef's patch fixes a memory corruption during btrfs mount.

Eric Paris (1) commits (+12/-12):
    Btrfs: use RB_ROOT to intialize rb_trees instead of setting rb_node to NULL

Josef Bacik (1) commits (+3/-2):
    Btrfs: kfree correct pointer during mount option parsing

Total: (2) commits

 fs/btrfs/disk-io.c          |    4 ++--
 fs/btrfs/extent_io.c        |    4 ++--
 fs/btrfs/extent_map.c       |    2 +-
 fs/btrfs/free-space-cache.c |    4 ++--
 fs/btrfs/ordered-data.h     |    2 +-
 fs/btrfs/ref-cache.h        |    2 +-
 fs/btrfs/relocation.c       |    4 ++--
 fs/btrfs/super.c            |    5 +++--
 fs/btrfs/transaction.c      |    2 +-
 9 files changed, 15 insertions(+), 14 deletions(-)

