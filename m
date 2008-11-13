Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbYKMKDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbYKMKDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 05:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbYKMKC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 05:02:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46869 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYKMKC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 05:02:58 -0500
Date: Thu, 13 Nov 2008 05:02:56 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [GIT PULL] XFS update for 2.6.28
Message-ID: <20081113100256.GA28659@infradead.org>
References: <20081111035805.EEC4B58FA24A@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111035805.EEC4B58FA24A@chook.melbourne.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, whats preventing this from going in?

On Tue, Nov 11, 2008 at 02:58:05PM +1100, Lachlan McIlroy wrote:
> This pull request is a little more conservative than the last one!  Just
> critical bug fixes this time.
> 
> The following changes since commit 3ad4f597058301c97f362e500a32f63f5c950a45:
>   Linus Torvalds (1):
>         Merge branch 'for-linus' of git://git.kernel.org/.../tiwai/sound-2.6
> 
> are available in the git repository at:
> 
>   git://oss.sgi.com:8090/xfs/xfs for-linus
> 
> Dave Chinner (1):
>       [XFS] handle memory allocation failures during log initialisation
> 
> David Chinner (2):
>       [XFS] Account for allocated blocks when expanding directories
>       [XFS] XFS: Check for valid transaction headers in recovery
> 
> Lachlan McIlroy (2):
>       [XFS] Fix use-after-free with log and quotas
>       [XFS] Wait for all I/O on truncate to zero file size
> 
>  fs/xfs/xfs_da_btree.c    |    5 +++++
>  fs/xfs/xfs_dir2.c        |    6 ++++++
>  fs/xfs/xfs_inode.c       |    2 +-
>  fs/xfs/xfs_log.c         |   39 ++++++++++++++++++++++++++++++++++++---
>  fs/xfs/xfs_log_recover.c |    8 +++++++-
>  fs/xfs/xfs_mount.c       |    5 +++--
>  6 files changed, 58 insertions(+), 7 deletions(-)
> 
> 
---end quoted text---
