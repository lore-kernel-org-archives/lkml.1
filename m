Return-Path: <linux-kernel-owner+w=401wt.eu-S1760416AbZFIMe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760416AbZFIMe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbZFIMeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:34:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56725 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbZFIMeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:34:19 -0400
Date: Tue, 9 Jun 2009 08:34:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for May 2009
Message-ID: <20090609123421.GA15623@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In May Linux 2.6.30 was getting close to be released, and various
important XFS fixes made it during the latest release candidates.
In the meantime some big patch series to rework the sync code and
the inode allocator have been posted for the next merge window.

On the userspace side xfsprogs and xfsdump 3.0.1 were finally released,
quickly followed by 3.0.2 releases with updated Debian packaging.
After that various small patches that were held back made it into xfsprogs.
A patch to add the xfs_reno tool which allows to move inodes around to
fit into 32 bit inode number space has been posted which is also one
central aspect of future online shrinking support.

There has been major activity on xfstests including adding generic
filesystems support to allow running tests that aren't XFS-specific on
any Linux filesystems.
