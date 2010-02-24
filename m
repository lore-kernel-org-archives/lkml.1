Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab0BXLPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 06:15:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:37264 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756707Ab0BXLPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 06:15:16 -0500
Date: Wed, 24 Feb 2010 12:15:24 +0100
From: Jan Kara <jack@suse.cz>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Jan Kara <jack@suse.cz>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build warning after merge of the ext3 tree
Message-ID: <20100224111524.GC3687@quack.suse.cz>
References: <20100224190520.8cd15930.sfr@canb.auug.org.au>
 <20100224105808.GB3687@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224105808.GB3687@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24-02-10 11:58:11, Jan Kara wrote:
>   Hi Stephen,
> 
> On Wed 24-02-10 19:05:20, Stephen Rothwell wrote:
> > After merging the ext3 tree, today's linux-next build (x86_64
> > allmodconfig) produced this warning:
> > 
> > fs/gfs2/quota.c:1581: warning: initialization from incompatible pointer type
> > 
> > Introduced by commit ec304a27d7750ba666ad2d446434ddd47fa93c40 ("quota:
> > move code from sync_quota_sb into vfs_quota_sync").  From the commit
> > message, I expect that this has been thought about.
>   Thanks for the notification. It seems Christoph missed to convert
> gfs2_quota_sync(). I've now fixed it in a minimalistic way (just added
> the wait parameter to the function).
>   Steven (Whitehouse), if GFS2 wants to do something more clever, please
> let me know (or fix up in your tree).
  And I had to fixup a few internal callers in GFS2 as well. So Steven, you
might want to have a look at the patch (commit
ef9eb614d974943af3c8eab8ea78a30d5132428c in my linux-fs-2.6 tree).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
