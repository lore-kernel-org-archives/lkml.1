Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbZGAO4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbZGAO4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbZGAO4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:56:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42693 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbZGAO4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:56:17 -0400
Date: Wed, 1 Jul 2009 10:56:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for June 2009
Message-ID: <20090701145620.GA13061@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On June 9th we finally saw the release of Linux 2.6.30.  For XFS
this release mostly contains the improved ENOSPC handling, but also
various smaller bugfixes and lots of cleanups.  The code size of XFS
decreased again by 500 lines of code in this release.

The Linux 2.6.31 merge opened in the mid of the month and some big XFS
changes have been pushed: A removal of the quotaops 
infrastructure which simplifies the quota implementation, the switch
from XFS's own Posix ACL implementation to the generic one shared
by various other filesystems which also supports in-memory caching of
ACLs and another incremental refactoring of the sync code.

A patch to better track dirty inodes and work around issues in the
way the VFS updates the access time stamp on inodes has been reposted
and discussed. Another patch to converting the existing XFS tracing
infrastructure to use the ftrace even tracer has been posted.

On the userspace side there have been a few updates to xfsprogs, including
some repair fixes and a new fallocate command for xfs_io.  There were
major updates for xfstests:  The existing aio-dio-regress testsuite has
been merged into xfstests, and various changes went into the tree to make
xfstests better suitable for use with other filesystems.

The attr and acl projects which have been traditionally been hosted
as part of the XFS userspace utilities have now been split into a separate
project maintained by Andreas Gruenbacher, who has been doing most of
the work on it, and moved to the Savannah hosting platform.
