Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab0BJSIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 13:08:54 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53848 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab0BJSIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 13:08:52 -0500
Date: Wed, 10 Feb 2010 13:08:51 -0500
From: Christoph Hellwig <hch@infradead.org>
To: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: XFS status update for January 2010
Message-ID: <20100210180851.GA9854@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

January saw additional release candidates of the Linux 2.6.33 kernel,
including a couple of bug fixes for XFS.  In the meantime the XFS tree
has been growing a large number of patches destined for the Linux 2.6.34
merge window: a large rework of the handling of per-AG data, support for
the quota netlink interface, and better power saving behavior of the
XFS kernel threads, and of course various cleanups.

A large patch series to replace the current asynchronous inode writeback
with a new scheme that uses the delayed write buffers was posted to
the list.  The new scheme, which allows archive better I/O locality by
dispatching meta-data I/O from a single place has been discussed
extensively and is expected to be merged in February.

On the userspace side January saw the 3.1.0 and 3.1.1 releases of xfsprogs,
as well as the 3.0.4 release of xfsdump.  The biggest changes in xfsprogs
3.1.0 were optimizations in xfs_repair that lead to a much lower memory
usage, and optional use of the blkid library for filesystem detection
and retrieving storage topology information.  The 3.1.1 release contained
various important bug fixes for these changes and a various improvements to
the build system.  The major feature of xfsdump 3.0.4 were fixes for
time stamp handling on 64-bit systems.

The xfstests package also lots of activity including various new testcases
and an improved build system.

