Return-Path: <linux-kernel-owner+w=401wt.eu-S1761477AbXKBRRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761477AbXKBRRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761357AbXKBRQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:16:47 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2361 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761334AbXKBRQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:16:46 -0400
Date: Fri, 2 Nov 2007 08:54:01 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jeff Garzik <jeff@garzik.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 00/33] Swap over NFS -v14
Message-ID: <20071102085401.GA3921@ucw.cz>
References: <20071030160401.296770000@chello.nl> <200710311426.33223.nickpiggin@yahoo.com.au> <1193830033.27652.159.camel@twins> <47287220.8050804@garzik.org> <1193835413.27652.205.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193835413.27652.205.camel@twins>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > 2) Nonetheless, swap over NFS is a pretty rare case.  I view this work 
> > as interesting, but I really don't see a huge need, for swapping over 
> > NBD or swapping over NFS.  I tend to think swapping to a remote resource 
> > starts to approach "migration" rather than merely swapping.  Yes, we can 
> > do it...  but given the lack of burning need one must examine the price.
> 
> There is a large corporate demand for this, which is why I'm doing this.
> 
> The typical usage scenarios are:
>  - cluster/blades, where having local disks is a cost issue (maintenance
>    of failures, heat, etc)
>  - virtualisation, where dumping the storage on a networked storage unit
>    makes for trivial migration and what not..
> 
> But please, people who want this (I'm sure some of you are reading) do
> speak up. I'm just the motivated corporate drone implementing the
> feature :-)

I have wyse thin client here, geode (or something) cpu, 128MB flash,
256MB RAM (IIRC). You want to swap on this one, and no, you don't want
to swap to flash.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
