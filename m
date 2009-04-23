Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbZDWQwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbZDWQwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 12:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZDWQwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 12:52:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54007 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbZDWQwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 12:52:10 -0400
Date: Thu, 23 Apr 2009 12:52:05 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/4] vfs: Make __fsync_super() a static function
	(version 2)
Message-ID: <20090423165205.GA4083@infradead.org>
References: <1240498045-14288-1-git-send-email-jack@suse.cz> <1240498045-14288-4-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240498045-14288-4-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 04:47:24PM +0200, Jan Kara wrote:
> -void __fsync_super(struct super_block *sb)
> +static int __fsync_super(struct super_block *sb)
>  {
>  	sync_inodes_sb(sb, 0);
>  	vfs_dq_sync(sb);
> @@ -284,8 +284,7 @@ void __fsync_super(struct super_block *sb)

I think you're missing a return somewhere :)

