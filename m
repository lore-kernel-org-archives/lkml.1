Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249AbZDXF3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbZDXF3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 01:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZDXF3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 01:29:33 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:54939 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbZDXF3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 01:29:32 -0400
Date: Fri, 24 Apr 2009 10:58:40 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Steve Wise <swise@opengridcomputing.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Wolfram Strepp <wstrepp@gmx.de>
Subject: Re: [BUG] rbtree bug with mmotm 2009-04-14-17-24
Message-ID: <20090424052840.GB6867@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <49EF293F.4030504@opengridcomputing.com> <49EF2C32.4030409@opengridcomputing.com> <20090422163032.GV4593@kernel.dk> <20090422163705.GW4593@kernel.dk> <49EF5F31.30408@opengridcomputing.com> <20090422183406.GA4593@kernel.dk> <49EF6929.9020600@opengridcomputing.com> <20090422192216.GE4593@kernel.dk> <49EF7B40.9050505@opengridcomputing.com> <20090423104055.GU4593@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090423104055.GU4593@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jens Axboe <jens.axboe@oracle.com> [2009-04-23 12:40:55]:

> On Wed, Apr 22 2009, Steve Wise wrote:
> > Jens Axboe wrote:
> >
> >  
> >
> >>> Still crashes with this variant:
> >>>     
> >>
> >> OK, so please try and revert a36e71f996e25d6213f57951f7ae1874086ec57e
> >> and see if that works?
> >>
> >> Or, better yet, please try and revert
> >> 55a63998b8967615a15e2211ba0ff3a84a565824 first. If that doesn't work,
> >> try the above revert.
> >>
> >>   
> >
> > Reverting 55a63998b8967615a15e2211ba0ff3a84a565824 did the trick.
> 
> Steve, can you (and Balbir) try with pulling this into 2.6.30-rc3:
> 
>         git://git.kernel.dk/linux-2.6-block.git for-linus
> 
> It has two fixes for possible rbtree misuse in cfq. If it still crashes
> without reverting 55a63998b8967615a15e2211ba0ff3a84a565824 with that,
> then we also need to look further into the rbtree issue.
>

OK, I'll give it a try and get back with what I see. 

-- 
	Balbir
