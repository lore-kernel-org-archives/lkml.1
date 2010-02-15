Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab0BOX50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 18:57:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59978 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab0BOX5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 18:57:24 -0500
Date: Mon, 15 Feb 2010 23:57:16 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: Rebase v. merge (Was: Re: linux-next: manual merge of the xfs
 tree with the vfs tree)
Message-ID: <20100215235716.GY30031@ZenIV.linux.org.uk>
References: <20100215122740.87c6cb5f.sfr@canb.auug.org.au>
 <20100215034417.GV30031@ZenIV.linux.org.uk>
 <20100216101626.0549dee8.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100216101626.0549dee8.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 10:16:26AM +1100, Stephen Rothwell wrote:
> Hi Al,
> 
> On Mon, 15 Feb 2010 03:44:17 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:
> >
> > Actually, I'd cheerfully rebased that sucker (to e.g. write_inode2); it has
> > grown a trivial conflict with mainline after one of gfs2 merges and it's
> > annoying to fix it up after each for-next rebase.
> > 
> > So I'd rather put a rebased variant and switched the for-next to using that,
> > if people who'd pulled it already are OK with that.
> 
> Just out of interest, is there some reason you didn't just merge Linus'
> tree (or the subset that caused the conflict) into the write-inode
> branch.  That would have meant that you still had a nonrebasing branch
> that others could use.  Now anyone who has merged your write_inode branch
> needs to rebuild their trees using you new write-rebase2 branch or risk
> causing conflicts in linux-next or Linus' tree when their tree's are
> merged.

Branch in question still doesn't exist; that was a question, not a description
of what I've already done.  I guess I can do what you describe, but...  Yuck.
Multiple merges from mainline can create one hell of a mess down the road.
I had to deal with results of exactly that when dwmw2 had dumped the audit
tree into my lap and it had been a huge mess that took quite a while to
untangle ;-/

The same goes for modifications hidden in merge commit, BTW.  I know that
Linus seems to be OK with that kind of thing, but... every time I run into
that is when some change is not to be found in git log -p ;-/

Oh, well...  I'll probably do that merge of mainline back into write_inode
and try hard to avoid anything similar in the next cycles.
