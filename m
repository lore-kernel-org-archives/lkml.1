Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbZIJUp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbZIJUp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbZIJUp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:45:28 -0400
Received: from verein.lst.de ([213.95.11.210]:40843 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845AbZIJUp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:45:28 -0400
Date: Thu, 10 Sep 2009 22:44:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, drepper@redhat.com, viro@zeniv.linux.org.uk,
       kyle@mcmartin.ca
Subject: Re: [PATCH 18/16] implement posix O_SYNC and O_DSYNC semantics
Message-ID: <20090910204431.GA20993@lst.de>
References: <1251899966-7316-1-git-send-email-jack@suse.cz> <20090910202521.GA20261@lst.de> <1252615120.8722.148.camel@heimdal.trondhjem.org> <20090910204026.GA20797@lst.de> <1252615415.8722.150.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252615415.8722.150.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.127 () BAYES_20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 04:43:35PM -0400, Trond Myklebust wrote:
> > 
> > Doesn't matter, we check early in the open path that __O_SYNC is only
> > set together with O_SYNC.
> 
> Right, but (file->f_flags & O_SYNC) will be non-zero even if only the
> O_DSYNC flag is set.

Thanks, corrected.
