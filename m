Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbZAELIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbZAELIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZAELIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:08:19 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:39565 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377AbZAELIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:08:16 -0500
To: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com, sfr@canb.auug.org.au
Subject: [PATCH V3 00/17] Squashfs: compressed read-only filesystem
Message-Id: <E1LJnJn-0002Kx-Dd@dylan.lougher.demon.co.uk>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Mon, 05 Jan 2009 11:08:23 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This a second respin of the Squashfs patches incorporating the review comments
received.  Thanks to everyone who have sent comments.

Summary of changes in patch respin:

1. Vmalloc removed, smaller PAGE_CACHE_SIZE buffers are now allocated
2. Renamed some global functions, prefixing with squashfs_
3. brelse changed to put_bh
4. cache->lock coverage extended in squashfs_put_cache() and
   squashfs_cache_get()
5. New squashfs.txt file in Documentation/filesystems
6. Changed 'long long' usage to u64 for variables referring to 64-bit
   filesystem locations
7. SQUASHFS_I() renamed to squashfs_i()
8. Renamed locked variable to refcount to clarify usage
9. Renamed waiting variable to num_waiters, making it clear it is a count
   rather than a boolean
10. Made pending and error fields int rather than char

These 17 patches are against the latest linux-2.6.git (will apply to 2.6.28).

These patches are also available from
git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git

As requested by Andrew Morton I have prepared a tree for linux-next inclusion.
This is git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-next.git

The Squashfs patches have been tested against both linus-2.6.git and
linux-next.git.

Finally, I would like to acknowledge the financial support of the Consumer
Embedded Linux Forum (CELF).  They've made it possible for me to spend the
last six months working full time on this mainlining attempt.

Thanks

Phillip
