Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbYHaRLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbYHaRLN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 13:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbYHaRK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 13:10:59 -0400
Received: from verein.lst.de ([213.95.11.210]:37162 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbYHaRK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 13:10:58 -0400
Date: Sun, 31 Aug 2008 19:10:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for August 2008
Message-ID: <20080831171056.GA23373@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the 2.6.27-rc5 release the 2.6.27 cycle is nearing it's end.  The major
XFS feature in 2.6.27-rc5 is support for case-insensitive file names.  At
this point it is still limited to 7bit ASCII file names, with updates for
utf8 file names expected to follow later.  In addition to that 2.6.27-rc5
fixes a long-standing problem with non-EABI arm compiler which pack some XFS
data structures wrongly.  Besides this 2.6.27-rc5 also contains various
cleanups, most notably the removal of the last bhv_vnode_t instances, and
most uses of semaphores.  As usual the diffstat for XFS from 2.6.26 to
2.6.26-rc5 is negative:

	 100 files changed, 3819 insertions(+), 4409 deletions(-)

On the user space front a new minor xfsprogs version is about to be released
containing various fixes including the user space part of arm packing fix.

Work in progress on the XFS mailing list are a large patch set to unify the
alloc, inobt and bmap btree implementation into a single that supports
arbitrarily pluggable key and record formats.  These btree changes are the
first major preparation for adding CRC checks to all metadata structures in
XFS, and an even larger patch set to unify the XFS and Linux inode structures,
and perform all inode write back from the btree uses instead of an inode
cache in XFS.
