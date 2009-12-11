Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbZLKGat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbZLKGat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 01:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757285AbZLKGaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 01:30:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757284AbZLKGaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 01:30:46 -0500
Date: Thu, 10 Dec 2009 22:30:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alex Elder <aelder@sgi.com>
cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [GIT PULL] XFS update for 2.6.33-rc1
In-Reply-To: <200912102219.nBAMJRr6028987@stout.americas.sgi.com>
Message-ID: <alpine.LFD.2.00.0912102228180.3560@localhost.localdomain>
References: <200912102219.nBAMJRr6028987@stout.americas.sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Dec 2009, Alex Elder wrote:
> 
>   git://oss.sgi.com/xfs/xfs for-linus

Hmm. There seems to be a lot of duplicate commits there due to something 
odd going on: rebasing _and_ then merging the rebased end result. IOW, 
these are all duplicates:

      xfs: cleanup data end I/O handlers
      xfs: cleanup data end I/O handlers
      xfs: cleanup dmapi macros in the umount path
      xfs: cleanup dmapi macros in the umount path
      xfs: Fix error return for fallocate() on XFS
      xfs: Fix error return for fallocate() on XFS
      xfs: fix mmap_sem/iolock inversion in xfs_free_eofblocks
      xfs: fix mmap_sem/iolock inversion in xfs_free_eofblocks
      xfs: I/O completion handlers must use NOFS allocations
      xfs: I/O completion handlers must use NOFS allocations
      xfs: kill the STATIC_INLINE macro
      xfs: kill the STATIC_INLINE macro
      xfs: remove incorrect sparse annotation for xfs_iget_cache_miss
      xfs: remove incorrect sparse annotation for xfs_iget_cache_miss
      xfs: remove IO_ISAIO
      xfs: remove IO_ISAIO
      xfs: rename xfs_attr_fetch to xfs_attr_get_int
      xfs: rename xfs_attr_fetch to xfs_attr_get_int
      xfs: reset the i_iolock lock class in the reclaim path
      xfs: reset the i_iolock lock class in the reclaim path
      xfs: simplify inode teardown
      xfs: simplify inode teardown
      xfs: simplify xfs_buf_get / xfs_buf_read interfaces
      xfs: simplify xfs_buf_get / xfs_buf_read interfaces
      xfs: uninline xfs_get_extsz_hint
      xfs: uninline xfs_get_extsz_hint
      xfs: use WRITE_SYNC_PLUG for synchronous writeout
      xfs: use WRITE_SYNC_PLUG for synchronous writeout
      xfs: Wrapped journal record corruption on read at recovery
      xfs: Wrapped journal record corruption on read at recovery

What's up, doc?

			Linus
