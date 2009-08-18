Return-Path: <linux-kernel-owner+w=401wt.eu-S1757167AbZHRIft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbZHRIft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 04:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbZHRIfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 04:35:48 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34384 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038AbZHRIfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 04:35:46 -0400
Date: Tue, 18 Aug 2009 10:35:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] splice: update mtime and atime on files
Message-ID: <20090818083547.GK12579@kernel.dk>
References: <E1MbyLM-0006Xd-OE@pomaz-ex.szeredi.hu> <20090815064241.GE12579@kernel.dk> <20090818050027.GE11624@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090818050027.GE11624@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18 2009, Willy Tarreau wrote:
> On Sat, Aug 15, 2009 at 08:42:41AM +0200, Jens Axboe wrote:
> > On Fri, Aug 14 2009, Miklos Szeredi wrote:
> > > From: Miklos Szeredi <mszeredi@suse.cz>
> > > 
> > > Splice should update the modification and access times on regular
> > > files just like read and write.  Not updating mtime will confuse
> > > backup tools, etc...
> > > 
> > > This patch only adds the time updates for regular files.  For pipes
> > > and other special files that splice touches the need for updating the
> > > times is less clear.  Let's discuss and fix that separately.
> > 
> > Thanks Miklos, I've queued this one up.
> 
> wouldn't it make sense to send that to stable too ? The patch is not
> intrusive and looks like a fix to me.

It doesn't really meet the stable criteria, as it's not a security issue
nor does it crash the kernel.

-- 
Jens Axboe

