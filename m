Return-Path: <linux-kernel-owner+w=401wt.eu-S1764338AbXIXQ5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764338AbXIXQ5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758398AbXIXQ5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:57:01 -0400
Received: from brick.kernel.dk ([87.55.233.238]:7264 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763649AbXIXQ47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:56:59 -0400
Date: Mon, 24 Sep 2007 18:58:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: 2.6.23-rc7-mm1
Message-ID: <20070924165813.GH2367@kernel.dk>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org> <46F7B4F2.1040506@fr.ibm.com> <46F7B735.2090509@fr.ibm.com> <46F7BB9E.70504@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F7BB9E.70504@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24 2007, Vlad Yasevich wrote:
> Cedric Le Goater wrote:
> > putting Vlad in Cc: 
> > 
> > Cedric Le Goater wrote:
> >> Andrew Morton wrote:
> >>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/
> >> I also get this compile error on s390. 'linux/scatterlist.h' has disappeared 
> >> from the #include pile but where ? 
> >>
> >> /home/clg/linux/2.6.23-rc7-mm1/net/sctp/auth.c: In function `sctp_auth_calculate_hmac':
> >> /home/clg/linux/2.6.23-rc7-mm1/net/sctp/auth.c:695: error: storage size of 'sg' isn't known
> >> /home/clg/linux/2.6.23-rc7-mm1/net/sctp/auth.c:695: warning: unused variable `sg'
> > 
> > The following patch works of course but it seems to simplistic for s390.
> 
> Odd that it didn't show up on x86 or ia64, but simple enough.

Most likely those archs end up pulling in scatterlist.h through some
other maze of includes.

-- 
Jens Axboe

