Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbXKOGKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbXKOGKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbXKOGKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:10:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36464 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbXKOGKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:10:22 -0500
Date: Wed, 14 Nov 2007 22:05:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/13] 2.6.23-stable review, core kernel changes
Message-ID: <20071115060544.GA7602@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.23.X release.
There are 13 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Friday 00:00:00 UTC.  Anything received
after that time might be too late.

This set of patches focuses on only the core kernel.  Other sets of
patches will follow if you are interested in those instead.

The diffstat of this review series is included below.

thanks,

greg k-h

---------------

 Documentation/ja_JP/HOWTO |   84 ++++++++++++++++++++++++----------------------
 block/ll_rw_blk.c         |    8 +---
 fs/locks.c                |   11 ++++++
 fs/proc/array.c           |    6 ++-
 fs/splice.c               |    2 -
 include/linux/blkdev.h    |    2 -
 include/linux/sched.h     |    1 
 kernel/fork.c             |    2 +
 kernel/futex_compat.c     |   27 ++++++++++----
 kernel/lockdep.c          |   10 ++---
 kernel/params.c           |    8 +++-
 kernel/softlockup.c       |    7 ++-
 mm/filemap.c              |   13 +------
 mm/page-writeback.c       |    4 +-
 mm/shmem.c                |   15 ++++++++
 mm/slub.c                 |   22 ------------
 16 files changed, 125 insertions(+), 97 deletions(-)
