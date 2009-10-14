Return-Path: <linux-kernel-owner+w=401wt.eu-S1761716AbZJNAKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761716AbZJNAKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 20:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761668AbZJNAKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 20:10:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38589 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760514AbZJNAKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 20:10:18 -0400
Date: Tue, 13 Oct 2009 20:09:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for September 2009
Message-ID: <20091014000942.GA8811@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In September the Linux 2.6.31 kernel was finally released, including another
last minute XFS fix for the swapext (defragmentation) compat ioctl handler.
The final patch from 2.6.30 to 2.6.31 shows the following impressive diffstat
for XFS:

   55 files changed, 1476 insertions(+), 2269 deletions(-)

The 2.6.32 merge window started with a large XFS merge that included changes
to the inode allocator, and a few smaller fixes.  New versions of the sync 
and time stamp fixes as well as the event tracing support have been posted
in September but not yet merged into the XFS development tree and/or mainline.

On the userspace side a large patch series to reduce the memory usage in
xfs_repair to acceptable levels was posted, but not yet merged.  A new xfs_df
shell script to measure use of the on disk space was posted but not yet
merged pending some minor review comments and a missing man page.  In addition
we saw the usual amount of smaller fixes and cleanups.

Also this month Felix Blyakher resigned from his post as XFS maintainer
and handed off to Alex Elder.
