Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903AbZGARWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbZGARWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 13:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbZGARWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 13:22:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57340 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbZGARWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 13:22:34 -0400
Date: Wed, 1 Jul 2009 10:21:13 -0700
From: Greg KH <gregkh@suse.de>
To: Julien BLACHE <jb@jblache.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, felixb@sgi.com
Subject: Re: [patch 000/108] 2.6.30-stable review
Message-ID: <20090701172113.GB29115@suse.de>
References: <20090701002838.GA7100@kroah.com>
 <87tz1wd4vi.fsf@sonic.technologeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tz1wd4vi.fsf@sonic.technologeek.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 01:22:57PM +0200, Julien BLACHE wrote:
> Greg KH <gregkh@suse.de> wrote:
> 
> Hi,
> 
> >  fs/Kconfig                                |   14 ++--
> >  fs/cifs/file.c                            |   10 +-
> >  fs/eventpoll.c                            |   21 +++--
> >  fs/fs-writeback.c                         |    2 -
> >  fs/jfs/jfs_extent.c                       |    1 +
> >  fs/ocfs2/super.c                          |   32 +++++----
> >  fs/ramfs/inode.c                          |    9 ++-
> 
> There is a memory leak in XFS in 2.6.30 that was fixed in commit
> 7747a0b0af5976ba3828796b4f7a7adc3bb76dbd (xfs: fix freeing memory in
> xfs_getbmap()).
> 
> Felix wrote it was a candidate for stable (obviously!) but it's not on
> the list you posted. Care to include it?

I'll go queue it up.

thanks,

greg k-h
