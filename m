Return-Path: <linux-kernel-owner+w=401wt.eu-S932772AbZHUR7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772AbZHUR7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932499AbZHUR7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:59:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:53393 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131AbZHUR7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:59:42 -0400
Date: Fri, 21 Aug 2009 19:59:43 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, Felix Blyakher <felixb@sgi.com>,
       xfs@oss.sgi.com
Subject: Re: [PATCH 13/17] xfs: Convert sync_page_range() to simple
	fdatawrite_range()
Message-ID: <20090821175943.GB10145@duck.novell.com>
References: <1250875447-15622-1-git-send-email-jack@suse.cz> <1250875447-15622-14-git-send-email-jack@suse.cz> <20090821172801.GA30254@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821172801.GA30254@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 21-08-09 19:28:01, Christoph Hellwig wrote:
> On Fri, Aug 21, 2009 at 07:24:03PM +0200, Jan Kara wrote:
> > +		error2 = filemap_fdatawrite_range(mapping, pos, pos + ret - 1);
> 
> I think this should be a filemap_write_and_wait_range
  Ah true, I somehow misinterpretted what xfs_write_sync_logforce() does.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
