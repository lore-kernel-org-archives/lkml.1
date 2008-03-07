Return-Path: <linux-kernel-owner+w=401wt.eu-S1760533AbYCGI6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760533AbYCGI6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbYCGI5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:57:51 -0500
Received: from brick.kernel.dk ([87.55.233.238]:4885 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637AbYCGI5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:57:50 -0500
Date: Fri, 7 Mar 2008 09:57:48 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.25-rc4
Message-ID: <20080307085748.GM17940@kernel.dk>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <20080306090029.GA6215@elte.hu> <20080306125929.GD17940@kernel.dk> <20080306130643.GB21359@elte.hu> <20080307085341.GA23814@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307085341.GA23814@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07 2008, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > Presumably any hw issues would get noticed (like missing interrupt) 
> > > and trigger the error handler, so it looks like this IO is still 
> > > stuck in the queue somewhere. That mainly points the finger at AS, 
> > > but given that you cannot reproduce I'm not sure how best to proceed 
> > > with this...
> > 
> > me neither... just wanted to give notice that something's brewing in 
> > this area. Will know more after tonight's qa series i guess, if it 
> > gets above 100 bootups ;-)
> 
> no luck - a few hundred successful randconfig bootups overnight (with a 
> rather complex userspace startup to full X plus networking, and the 
> testbox is used via the network to compile the next random kernel as 
> well - etc.) and no failure at all. So there's not much we can do at 
> this point - i'll keep you updated if anything new happens in the tests.

OK, so it could possibly be something else or perhaps something that's
existed for a long time.

To capture vital debugging information for cases like this, I had an
idea for a sysrq key that would dump queue and io scheduler info for all
known block devices. That should help pin point where the problem lies.
If we have any letters left in the sysrq namespace :-)

-- 
Jens Axboe

