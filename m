Return-Path: <linux-kernel-owner+w=401wt.eu-S1761532AbXHEULg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761532AbXHEULg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 16:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757922AbXHEUL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 16:11:29 -0400
Received: from verein.lst.de ([213.95.11.210]:36520 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756750AbXHEUL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 16:11:28 -0400
Date: Sun, 5 Aug 2007 22:11:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ufs: move non-layout parts of ufs_fs.h to fs/ufs/
Message-ID: <20070805201107.GA820@lst.de>
References: <20070803140917.GA24385@lst.de> <20070804192431.GA12216@rain> <20070804193648.GV21089@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070804193648.GV21089@ftp.linux.org.uk>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2007 at 08:36:49PM +0100, Al Viro wrote:
> On Sat, Aug 04, 2007 at 11:24:31PM +0400, Evgeniy Dushistov wrote:
> > Move prototypes and in-core structures to fs/ufs/ similar to what most
> > other filesystems already do.
> > 
> > I made little modifications: move also ufs debug macros and
> > mount options constants into fs/ufs/ufs.h, this stuff
> > also private for ufs.
> 
> Is there any reason to have util.h included directly?  Or to have
> it as a separate file and not a part of ufs.h, while we are at it...

I didn't want to do too many different things at once, but getting
rid of util.h sounds fine to me.
