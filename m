Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbYLAMBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbYLAMBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbYLAMBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:01:04 -0500
Received: from styx.suse.cz ([82.119.242.94]:36375 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754333AbYLAMBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:01:03 -0500
Date: Mon, 1 Dec 2008 13:01:01 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tibor.tajti@gmail.com
Subject: Re: [GIT PULL] UDF tree fixes
Message-ID: <20081201120101.GC17303@duck.suse.cz>
References: <20081127172313.GG32062@duck.suse.cz> <alpine.LFD.2.00.0811301253370.24125@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811301253370.24125@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 30-11-08 12:58:54, Linus Torvalds wrote:
> 
> 
> On Thu, 27 Nov 2008, Jan Kara wrote:
> > 
> >   would you please pull from
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6.git for_linus
> > 
> >   to get the following fix:
> > Jan Kara (1):
> >       udf: Fix BUG_ON() in destroy_inode()
> > 
> >   with diffstat:
> > 
> >  fs/buffer.c    |    1 +
> >  fs/udf/inode.c |    1 +
> >  2 files changed, 2 insertions(+)
> 
> Hmm. I really think you should use 'clear_inode()' rather than calling 
> invalidate_inode_buffers() directly.
  Yes, I would like to do it as well. But as I write in the changelog,
currently there's no good callback for that (I've mailed about it at
linux-fsdevel and noone had a better idea either). So for now I've just
used this kludge to silence the Oops.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
