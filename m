Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbXICNU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbXICNU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 09:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbXICNUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 09:20:21 -0400
Received: from unthought.net ([212.97.129.88]:54781 "EHLO unthought.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbXICNUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 09:20:20 -0400
Date: Mon, 3 Sep 2007 15:20:19 +0200
From: Jakob Oestergaard <jakob@unthought.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: recent nfs change causes autofs regression
Message-ID: <20070903132019.GC21977@unthought.net>
Mail-Followup-To: Jakob Oestergaard <jakob@unthought.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	Frank van Maarseveen <frankvm@frankvm.com>,
	Hua Zhong <hzhong@gmail.com>,
	'Linux Kernel Mailing List' <linux-kernel@vger.kernel.org>,
	akpm@linux-foundation.org
References: <1188513433.6626.24.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org> <1188535485.6626.85.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302157470.25853@woody.linux-foundation.org> <1188536658.6626.98.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302215280.25853@woody.linux-foundation.org> <20070831074028.GR21979@unthought.net> <alpine.LFD.0.999.0708310055010.25853@woody.linux-foundation.org> <20070831085157.GS21979@unthought.net> <alpine.LFD.0.999.0708310935240.25853@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708310935240.25853@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 09:43:29AM -0700, Linus Torvalds wrote:
...
> This is *not* a security hole. In order to make it a security hole, you 
> need to be root in the first place.

Non-root users can write to places where root might believe they cannot write
because he might be under the mistaken assumption that ro means ro.

I am under the impression that that could have implications in some setups.

...
> 
>  - it's a misfeature that people are used to, and has been around forever.

Sure, they're used it it, but I doubt they are aware of it.

...
> so I really don't see why people excuse the new behaviour.

We can certainly agree that a nicer fix would be nicer :)

-- 

 / jakob

