Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbZIICOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbZIICOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 22:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbZIICOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 22:14:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58556 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbZIICOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 22:14:51 -0400
Date: Tue, 8 Sep 2009 22:14:53 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for August 2009
Message-ID: <20090909021453.GA24173@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In August the Linux 2.6.31 kernel has still been in the release candidate
stage, but a couple of important XFS fixes made it in time for the release,
including a fix for the inode cache races with NFS workloads that have
plagued us for a long time.

The list saw various patches destined for the Linux 2.6.32 merge window,
including a merge of the fsync and O_SYNC handling code to address various
issues with the latter, a workaround for deficits in the timestamp handling
interface between the VFS and filesystems, a repost of the sync improvements
patch series and various smaller patches. 

August also saw the minor 3.0.3 release of xfsprogs which collects smaller
fixes to the various tools and most importantly a fix to allow xfsprogs to
work again on SPARC and other strict alignment handling which regressed a
few releases ago.  The xfstests repository saw a few new test cases and a
various small improvements.
