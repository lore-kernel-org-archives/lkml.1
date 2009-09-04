Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbZIDL7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbZIDL7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 07:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756726AbZIDL7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 07:59:19 -0400
Received: from brick.kernel.dk ([93.163.65.50]:51960 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbZIDL7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 07:59:18 -0400
Date: Fri, 4 Sep 2009 13:59:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       tytso@mit.edu, akpm@linux-foundation.org
Subject: Re: [PATCH 1/8] writeback: get rid of generic_sync_sb_inodes()
	export
Message-ID: <20090904115920.GU18599@kernel.dk>
References: <1252050406-22467-1-git-send-email-jens.axboe@oracle.com> <1252050406-22467-2-git-send-email-jens.axboe@oracle.com> <20090904082813.GC19857@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904082813.GC19857@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04 2009, Jan Kara wrote:
> On Fri 04-09-09 09:46:39, Jens Axboe wrote:
> > This adds two new exported functions:
> > 
> > - writeback_inodes_sb(), which only attempts to writeback dirty inodes on
> >   this super_block, for WB_SYNC_NONE writeout.
> > - sync_inodes_sbt(), which writes out all dirty inodes on this super_block
> >   and also waits for the IO to complete.
> > 
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
>   The patch looks good. A nice cleanup.
> Acked-by: Jan Kara <jack@suse.cz>

Thanks, ack added.

-- 
Jens Axboe

