Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbZIDILL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbZIDILL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756547AbZIDILJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:11:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49787 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755446AbZIDILI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:11:08 -0400
Date: Fri, 4 Sep 2009 10:11:08 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, Felix Blyakher <felixb@sgi.com>
Subject: Re: linux-next: manual merge of the xfs tree with the ext3 tree
Message-ID: <20090904081108.GA19857@duck.suse.cz>
References: <20090904095500.04205407.sfr@canb.auug.org.au> <20090903235652.GA7674@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903235652.GA7674@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 04-09-09 01:56:52, Christoph Hellwig wrote:
> On Fri, Sep 04, 2009 at 09:55:00AM +1000, Stephen Rothwell wrote:
> > 218604a0bf712976171798b1dd5c44d26d6d0ea4 ("xfs: Convert sync_page_range()
> > to simple filemap_write_and_wait_range()") from the ext3 tree and commit
> > 13e6d5cdde0e785aa943810f08b801cadd0935df ("xfs: merge fsync and O_SYNC
> > handling") from the xfs tree.
> > 
> > They both do the same thing (to this bit of code) ... I used the version
> > from the xfs tree.
> 
> Yes, the xfs tree one is the better one, the one in Jan's tree only
> does about half of it.
  Should I drop the XFS chunk or will you rebase your XFS patch on top of
my patch? The latter seems safer (since my patch series won't compile
without the XFS change)...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
