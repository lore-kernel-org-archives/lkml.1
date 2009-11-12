Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbZKLRyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbZKLRyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbZKLRyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:54:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34016 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbZKLRyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:54:49 -0500
Date: Thu, 12 Nov 2009 12:54:55 -0500
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for October 2009
Message-ID: <20091112175455.GA32539@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In October we saw the Linux 2.6.32 merge window with a major XFS update.
This update includes a refactoring of the inode allocator which also
allows for speedups for very large filesystems, major sync fixes, updates
to the fsync and O_SYNC handling which merge the two code paths into a single
and more efficient one, a workaround for the VFS time stamp behavior,
and of course various smaller fixes.  A couple of additional fixes have been
queued up for the next merge window.

On the userspace side there has been a healthy activity on xfsprogs:  mkfs can
now discard unused sectors on SSDs and thinly provisioned storage devices and
use the more generic libblkid for topology information and filesystems detection
instead of the older libdisk, and the build system gained some updates to
make the source package generation simpler and shared for different package
types.  A patch has been out to the list but yet committed to add symbol
versioning to the libhandle library to make future ABI additions easier.
The xfstests package only saw some minor activity with a new test case
and small build system fixes.

New minor releases of xfsprogs and xfsdump were tagged but not formally
released after additional discussion.  Instead a new major xfsprogs release
is planned for next month.
