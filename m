Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbZAFX3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbZAFX3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbZAFX3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:29:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980AbZAFX27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:28:59 -0500
Date: Tue, 6 Jan 2009 15:28:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: 2.6.29 -mm merge plans
Message-Id: <20090106152829.43dab4a0.akpm@linux-foundation.org>
In-Reply-To: <20090106225744.GA10553@infradead.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	<20090106225744.GA10553@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc added)

On Tue, 6 Jan 2009 17:57:44 -0500
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Jan 05, 2009 at 12:43:00AM -0800, Andrew Morton wrote:
> 
> > nilfs2-add-document.patch
> > nilfs2-disk-format-and-userland-interface.patch
> > nilfs2-add-inode-and-other-major-structures.patch
> > nilfs2-integrated-block-mapping.patch
> > nilfs2-b-tree-based-block-mapping.patch
> > nilfs2-direct-block-mapping.patch
> > nilfs2-b-tree-node-cache.patch
> > nilfs2-buffer-and-page-operations.patch
> > nilfs2-meta-data-file.patch
> > nilfs2-persistent-object-allocator.patch
> > nilfs2-disk-address-translator.patch
> > nilfs2-inode-map-file.patch
> > nilfs2-checkpoint-file.patch
> > nilfs2-segment-usage-file.patch
> > nilfs2-inode-operations.patch
> > nilfs2-inode-operations-fix.patch
> > nilfs2-file-operations.patch
> > nilfs2-directory-entry-operations.patch
> > nilfs2-pathname-operations.patch
> > nilfs2-pathname-operations-fix.patch
> > nilfs2-operations-for-the_nilfs-core-object.patch
> > nilfs2-super-block-operations.patch
> > nilfs2-super-block-operations-fix.patch
> > nilfs2-segment-buffer.patch
> > nilfs2-segment-constructor.patch
> > nilfs2-recovery-functions.patch
> > nilfs2-another-dat-for-garbage-collection.patch
> > nilfs2-block-cache-for-garbage-collection.patch
> > nilfs2-ioctl-operations.patch
> > nilfs2-update-makefile-and-kconfig.patch
> > #
> > nilfs2-fix-problems-of-memory-allocation-in-ioctl.patch
> > nilfs2-cleanup-nilfs_clear_inode.patch
> > nilfs2-avoid-double-error-caused-by-nilfs_transaction_end.patch
> > nilfs2-insert-explanations-in-gcinode-file.patch
> > nilfs2-add-maintainer.patch
> > nilfs2-fix-gc-failure-on-volumes-keeping-numerous-snapshots.patch
> > 
> >   Dunno.   Has this been reviewed enough?
> 
> No.  I might eventually take a look, but looking into btrfs has a little
> higher priority right now, and split into gazillions of
> non-selfcontained patches certainly doesn't help reviewing it.

nilfs will remain under development for a couple of months and we'll
take a look at a 2.6.20 merge.  Can you please find time to take a
closer look during this cycle?

> BTW, the current influx of higher-complexity filesystems certainly worries
> me a little.

Well yes.  Each new filesystem (complex or not) is an additional
boatanchor on development of core kernel: block, vfs, MM, etc.  So each
filesystem should be justified on the basis that it adds sufficient
benefit to justify that cost.  (And I got mau-muaed for pointing this
out in the omfs context, I might add).

Will nilfs bring enough value to justify it's cost?  Hard call.  What
do you think?

(otoh, we could probably randomly delete ten old filesystems and
practically nobody would notice)
