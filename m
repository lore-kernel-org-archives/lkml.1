Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbZHRIqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbZHRIqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 04:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757206AbZHRIqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 04:46:42 -0400
Received: from 1wt.eu ([62.212.114.60]:44441 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbZHRIqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 04:46:40 -0400
Date: Tue, 18 Aug 2009 10:46:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] splice: update mtime and atime on files
Message-ID: <20090818084625.GF18709@1wt.eu>
References: <E1MbyLM-0006Xd-OE@pomaz-ex.szeredi.hu> <20090815064241.GE12579@kernel.dk> <20090818050027.GE11624@1wt.eu> <20090818083547.GK12579@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090818083547.GK12579@kernel.dk>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 10:35:48AM +0200, Jens Axboe wrote:
> On Tue, Aug 18 2009, Willy Tarreau wrote:
> > On Sat, Aug 15, 2009 at 08:42:41AM +0200, Jens Axboe wrote:
> > > On Fri, Aug 14 2009, Miklos Szeredi wrote:
> > > > From: Miklos Szeredi <mszeredi@suse.cz>
> > > > 
> > > > Splice should update the modification and access times on regular
> > > > files just like read and write.  Not updating mtime will confuse
> > > > backup tools, etc...
> > > > 
> > > > This patch only adds the time updates for regular files.  For pipes
> > > > and other special files that splice touches the need for updating the
> > > > times is less clear.  Let's discuss and fix that separately.
> > > 
> > > Thanks Miklos, I've queued this one up.
> > 
> > wouldn't it make sense to send that to stable too ? The patch is not
> > intrusive and looks like a fix to me.
> 
> It doesn't really meet the stable criteria, as it's not a security issue
> nor does it crash the kernel.

Oh there are many other things which go to stable, especially bug
fixes and minor improvements. We *could* classify this in the bug
fixes as, I Miklos suggested it, this could have an impact on
modified files which would currently not be backed up for instance.

Regards,
Willy

