Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbYHMIu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbYHMIu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbYHMIuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:50:46 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:27212 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232AbYHMIup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:50:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAOw7okh5LAMb/2dsb2JhbAC3L4FV
X-IronPort-AV: E=Sophos;i="4.32,200,1217773800"; 
   d="scan'208";a="181067958"
Date: Wed, 13 Aug 2008 18:50:40 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lachlan McIlroy <lachlan@sgi.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [GIT PULL] XFS update for 2.6.27-rc4
Message-ID: <20080813085040.GB6119@disturbed>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Lachlan McIlroy <lachlan@sgi.com>, torvalds@linux-foundation.org,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com
References: <20080813081147.8ECE258C52A8@chook.melbourne.sgi.com> <20080813011606.06f2c2da.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813011606.06f2c2da.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 01:16:06AM -0700, Andrew Morton wrote:
> On Wed, 13 Aug 2008 18:11:47 +1000 lachlan@sgi.com (Lachlan McIlroy) wrote:
> 
> > The following changes since commit 30a2f3c60a84092c8084dfe788b710f8d0768cd4:
> >   Linus Torvalds (1):
> >         Linux 2.6.27-rc3
> > 
> > are available in the git repository at:
> > 
> >   git://oss.sgi.com:8090/xfs/linux-2.6 master
> 
> Who do I have to pay to get rid of these:
> 
> xfs-use-get_unaligned_-helpers.patch
> xfs-clean-up-stale-references-to-semaphores.patch
> xfs-replace-the-xfs-buf-iodone-semaphore-with-a-completion.patch
> xfs-extend-completions-to-provide-xfs-object-flush-requirements.patch
> xfs-replace-inode-flush-semaphore-with-a-completion.patch
> xfs-replace-dquot-flush-semaphore-with-a-completion.patch
> xfs-remove-the-sema_t-from-xfs.patch
> 
> and how much?

They are all in that pull request:

| David Chinner (12):
.....
|      [XFS] clean up stale references to semaphores
|      [XFS] replace the XFS buf iodone semaphore with a completion
|      [XFS] extend completions to provide XFS object flush requirements
|      [XFS] replace inode flush semaphore with a completion
|      [XFS] replace dquot flush semaphore with a completion
|      [XFS] remove the sema_t from XFS.
.....
| Harvey Harrison (1):
|       [XFS] use get_unaligned_* helpers

So you won't have to pay anyone anything ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
