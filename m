Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbZDWUqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbZDWUqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 16:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757172AbZDWUqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 16:46:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069AbZDWUqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 16:46:35 -0400
Date: Thu, 23 Apr 2009 22:46:33 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/4] vfs: Make __fsync_super() a static function
	(version 2)
Message-ID: <20090423204633.GB31584@duck.suse.cz>
References: <1240498045-14288-1-git-send-email-jack@suse.cz> <1240498045-14288-4-git-send-email-jack@suse.cz> <20090423165205.GA4083@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423165205.GA4083@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 23-04-09 12:52:05, Christoph Hellwig wrote:
> On Thu, Apr 23, 2009 at 04:47:24PM +0200, Jan Kara wrote:
> > -void __fsync_super(struct super_block *sb)
> > +static int __fsync_super(struct super_block *sb)
> >  {
> >  	sync_inodes_sb(sb, 0);
> >  	vfs_dq_sync(sb);
> > @@ -284,8 +284,7 @@ void __fsync_super(struct super_block *sb)
> 
> I think you're missing a return somewhere :)
  Argh, forgot to commit this compile fix ;).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
