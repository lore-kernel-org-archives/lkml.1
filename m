Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbYHUF43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbYHUF43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 01:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbYHUF4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 01:56:16 -0400
Received: from [93.163.65.50] ([93.163.65.50]:6459 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbYHUF4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 01:56:15 -0400
X-Greylist: delayed 1807 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Aug 2008 01:56:15 EDT
Date: Thu, 21 Aug 2008 07:26:05 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Milan Broz <mbroz@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Ric Wheeler <rwheeler@redhat.com>,
       "MASON,CHRISTOPHER" <CHRIS.MASON@oracle.com>
Subject: Re: Mount ext3 with barrier=1 doesn't send real barrier bio?
Message-ID: <20080821052604.GM20055@kernel.dk>
References: <48A5F5C6.2090204@redhat.com> <48ACAADD.2010104@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48ACAADD.2010104@sandeen.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20 2008, Eric Sandeen wrote:
> Milan Broz wrote:
> > Hi,
> > 
> > I run some barrier tests over device-mapper (which currently doesn't
> > support barrier bio at all) and even if I set barrier=1 in ext3 mount,
> > there is never any bio with barrier flag... (in 2.6.27-rc)
> > 
> > How is the barrier=1 flag supposed to work in ext3 (JBD) now?
> 
> Milan, you're right.  Ric saw this same strange behavior when doing some
> benchmarking with and without barriers; Chris noticed the change in
> submit_bh; I was about to write up a similar patch to what you've sent
> already.  Jens, does Milan's fix look good to you?

Yep looks good, thanks a lot Milan! I'll send in the patch, unless I'm
badly mistaken we need it for 2.6.26-stable as well.

-- 
Jens Axboe

