Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbZHCVoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbZHCVoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbZHCVoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:44:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41152 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbZHCVop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:44:45 -0400
Date: Mon, 3 Aug 2009 17:44:45 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for July 2009
Message-ID: <20090803214445.GA3167@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a traditional summer vacation month July has not seen a lot of XFS
activity.  The mainline 2.6.31 kernel made it to the 5th release candidate
but besides a few kernel-wide patches touching XFS the only activity were
two small patches fixing a bug in FIEMAP and working around writeback
performance problems in the VM.

A few more patches were posted to the list but haven't been merged yet.
Two big patch series deal with theoretically possible deadlocks due to
locks taken in reclaim contexts, which are now detected by lockdep.

The pace on the userspace side has been slow.  There have been a couple
of fixes to xfs_repair and xfs_db, and xfstests grew a few more testcases.
