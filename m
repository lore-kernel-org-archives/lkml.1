Return-Path: <linux-kernel-owner+w=401wt.eu-S1759025AbZDBLr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025AbZDBLr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbZDBLrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:47:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:43615 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991AbZDBLrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:47:12 -0400
Date: Thu, 2 Apr 2009 13:47:09 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PULL REQUEST] UDF changes for 2.6.30
Message-ID: <20090402114708.GD3010@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6.git for_linus

  to get:

Clemens Ladisch (2):
      udf: fix novrs mount option
      udf: use hardware sector size

Coly Li (1):
      udf: return f_fsid for statfs(2)

Jan Kara (6):
      udf: fix sparse warnings:
      udf: Add checks to not underflow sector_t
      udf: Fix oops when invalid character in filename occurs
      udf: Some type fixes and cleanups
      udf: Try anchor in block 256 first
      udf: Don't write integrity descriptor too often

Marcin Slusarz (4):
      udf: reduce stack usage of udf_load_pvoldesc
      udf: reduce stack usage of udf_get_filename
      udf: implement mode and dmode mounting options
      udf: fix default mode and dmode options handling

Pekka Enberg (2):
      Remove struct typedefs from fs/udf/ecma_167.h et al.
      Fix the udf code not to pass structs on stack where possible.

roel kluin (1):
      udf: unsigned last[i] cannot be less than 0

The diffstat is

 Documentation/filesystems/udf.txt |    2 +
 fs/udf/balloc.c                   |  150 ++++-----
 fs/udf/dir.c                      |   14 +-
 fs/udf/directory.c                |   38 ++--
 fs/udf/ecma_167.h                 |  416 +++++++++++++-------------
 fs/udf/ialloc.c                   |    9 +-
 fs/udf/inode.c                    |  213 +++++++-------
 fs/udf/misc.c                     |   29 +-
 fs/udf/namei.c                    |   86 +++---
 fs/udf/osta_udf.h                 |   22 +-
 fs/udf/partition.c                |    2 +-
 fs/udf/super.c                    |  605 +++++++++++++++++++------------------
 fs/udf/truncate.c                 |   44 ++--
 fs/udf/udf_i.h                    |    6 +-
 fs/udf/udf_sb.h                   |    9 +-
 fs/udf/udfdecl.h                  |   57 +++--
 fs/udf/udfend.h                   |   28 +-
 fs/udf/udftime.c                  |    6 +-
 fs/udf/unicode.c                  |   62 +++--
 19 files changed, 930 insertions(+), 868 deletions(-)

							Thanks
								Honza
---
Jan Kara <jack@suse.cz>
SUSE Labs, CR
