Return-Path: <linux-kernel-owner+w=401wt.eu-S1760265AbXI0XmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265AbXI0XmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 19:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbXI0XmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 19:42:08 -0400
Received: from brick.kernel.dk ([87.55.233.238]:25048 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246AbXI0XmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 19:42:05 -0400
Date: Fri, 28 Sep 2007 01:41:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Correct SuS compliance for open of large file without options
Message-ID: <20070927234158.GB10154@kernel.dk>
References: <20070927142919.10b62f9b@the-village.bc.nu> <20070927070118.2bd4792e@laptopd505.fenrus.org> <20070927151921.29b19abb@the-village.bc.nu> <20070927143548.GT5243@kernel.dk> <20070927154432.302ec5a7@the-village.bc.nu> <20070927150853.GA10154@kernel.dk> <20070927161912.2f08aff6@the-village.bc.nu> <20070927155902.GA6450@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927155902.GA6450@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27 2007, Theodore Tso wrote:
> On Thu, Sep 27, 2007 at 04:19:12PM +0100, Alan Cox wrote:
> > > Well it's not my call, just seems like a really bad idea to change the
> > > error value. You can't claim full coverage for such testing anyway, it's
> > > one of those things that people will complain about two releases later
> > > saying it broke app foo.
> > 
> > Strange since we've spent years changing error values and getting them
> > right in the past. 
> 
> I doubt there any apps which are going to specifically check for EFBIG
> and do soemthing different if they get EOVERFLOW instead.  If it was
> something like EAGAIN or EPERM, I'd be more concerned, but EFBIG
> vs. EOVERFLOW?  C'mon!

It's not checking EFBIG vs EOVERFLOW, it's checking one and not the
other. But I digress, not trying to NAK the patch, just voicing my
opinion on the matter. It's not something you can easily test and claim
good app coverage, though.

-- 
Jens Axboe

