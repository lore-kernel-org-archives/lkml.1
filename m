Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988AbZIKOEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbZIKOEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbZIKOEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:04:51 -0400
Received: from brick.kernel.dk ([93.163.65.50]:55087 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbZIKOEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:04:51 -0400
Date: Fri, 11 Sep 2009 16:04:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: What's in linux-2.6-block.git for 2.6.32
Message-ID: <20090911140453.GG14984@kernel.dk>
References: <20090911124106.GC14984@kernel.dk> <x49d45xa93a.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49d45xa93a.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11 2009, Jeff Moyer wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > Hi,
> >
> > This is just the core block bits, I have other branches pending. And a
> > heads up that I had to rebase this branch today, something I haven't
> > done during the .31 cycle. This was due to the history being really odd,
> > with modified patches of for-2.6.32 patches being forwarded to mainline.
> > So I though it would be better to clean this history and merge fixups.
> > There was also a middle point that would break bisection.
> >
> > Nothing really earth shattering in here, nor are there really big
> > changes for this cycle.
> >
> > - Some updates to CFQ to improve interactiveness.
> > - Some cleanups and sanitization of the bio IO flags.
> > - blk-iopoll, an experimental API for doing NAPI like polled completions
> >   for really fast devices. In testing this has shown to be faster for
> >   some cases, while slower for others. The included patch is just the
> >   core bits, no driver support is being merged yet.
> > - Enable CPU IO completion by default. My testing has shown this to be
> >   faster, and independent testing by Intel confirms that as well.
> > - A fix to only issue a block queue trace when we actually intend to
> >   queue.
> > - A fix for splice to update mtime and atime on files.
> > - A cleanup of the failfast bits and merge fixups for the same.
> 
> Any particular reason you're holding off on the pktcdvd regression fix I
> posted?

No, I'll get it added. Sorry for the delay on that.

-- 
Jens Axboe

