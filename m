Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbXI0PJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbXI0PJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbXI0PI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:08:59 -0400
Received: from brick.kernel.dk ([87.55.233.238]:1845 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755023AbXI0PI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:08:58 -0400
Date: Thu, 27 Sep 2007 17:08:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arjan van de Ven <arjan@infradead.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Correct SuS compliance for open of large file  without options
Message-ID: <20070927150853.GA10154@kernel.dk>
References: <20070927142919.10b62f9b@the-village.bc.nu> <20070927070118.2bd4792e@laptopd505.fenrus.org> <20070927151921.29b19abb@the-village.bc.nu> <20070927143548.GT5243@kernel.dk> <20070927154432.302ec5a7@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927154432.302ec5a7@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27 2007, Alan Cox wrote:
> > > Its a change of a specific error return from the wrong error to the right
> > > one, nothing more. Fixing the returned error gives us correct behaviour
> > > according to the standards and other systems.
> > 
> > It may still break applications. Waving some standard at them if they
> > complain is unlikely to impress them.
> 
> And our existing behaviour may well break correctly written
> portable applications, and is incorrect as well.

It's been that way for ages, how likely do you think that is? Not very,
is my guess. Existing practice trumps standard description in my book.

> Testing so far says it doesn't break anything, which is no suprise if you
> apply about ten braincells to the case under consideration.

Well it's not my call, just seems like a really bad idea to change the
error value. You can't claim full coverage for such testing anyway, it's
one of those things that people will complain about two releases later
saying it broke app foo.

-- 
Jens Axboe

