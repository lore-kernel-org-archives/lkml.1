Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbZBCIJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbZBCIJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 03:09:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbZBCIJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 03:09:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37139 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbZBCIJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 03:09:18 -0500
Date: Tue, 3 Feb 2009 03:09:16 -0500
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for January 2009
Message-ID: <20090203080915.GA8921@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

January has been an extremely busy month on the userspace front.  Many
smaller and medium updates went into xfsprogs, xfstests and to a lesser
extent xfsdump.  xfsprogs and xfsdump are ramping up for getting a 3.0.0
release out in early February which will include the first major re-sync
with the kernel code in libxfs, a cleanup of the exported library interfaces
and the move of two tools (xfs_fsr and xfs_estimate) from the xfsdump
package to xfsprogs.  After this the xfsprogs package will contain all
tools that use internal libxfs interfaces which fortunately equates to those
needed for normal administration.  The xfsdump package now only contains
the xfsdump/xfsrestore tools needed for backing up and restoring XFS
filesystems.  In addition it grew a fix to support dump/restore on systems
with a 64k page size.  A large number of acl/attr package patches was
posted to the list, but pending a possible split of these packages from the
XFS project these weren't processed yet.

On the kernel side the big excitement in January was an in-memory corruption
introduced in the btree refactoring which hit people running 32bit platforms
without support for large block devices.  This issue was fixed and pushed
to the 2.6.29 development tree after a long collaborative debugging effort
at linux.conf.au.  Besides that about a dozen minor fixes were pushed to
2.6.29 and the first batch of misc patches for the 2.6.30 release cycle
was sent out.

At the end of December the SGI group in Melbourne which the previous
XFS maintainer and some other developers worked for has been closed down
and they will be missed greatly.  As a result maintainership has been passed
on in a way that has been slightly controversial in the community, and the
first patchset of work in progress in Melbourne have been posted to the list
to be picked up by others.

The xfs.org wiki has gotten a little facelift on it's front page making it
a lot easier to read.
