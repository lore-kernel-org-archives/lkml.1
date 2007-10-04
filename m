Return-Path: <linux-kernel-owner+w=401wt.eu-S1762491AbXJDJit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762491AbXJDJit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760861AbXJDJ2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:28:42 -0400
Received: from brick.kernel.dk ([87.55.233.238]:25794 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760909AbXJDJ2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:28:40 -0400
Date: Thu, 4 Oct 2007 11:30:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Mullis <dwm@meer.net>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc8-mm2: OOPS in mmc on boot
Message-ID: <20071004093014.GE23808@kernel.dk>
References: <1191478262.21598.5.camel@dmullis-laptop> <20071003231659.f41df5ed.akpm@linux-foundation.org> <20071004072515.GC5236@kernel.dk> <20071004100154.6093844d@poseidon.drzeus.cx> <20071004080631.GB23808@kernel.dk> <20071004104626.2a219926@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004104626.2a219926@poseidon.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04 2007, Pierre Ossman wrote:
> On Thu, 4 Oct 2007 10:06:32 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Thu, Oct 04 2007, Pierre Ossman wrote:
> > > 
> > > Huh? Isn't the block layer supposed to fill in the entire thing?
> > > (i.e. current contents shouldn't matter)
> > 
> > Yeah, but sg chaining requires that ->page be filled in properly or it
> > could confuse it. I think I'll add some debugging to catch that.
> > 
> 
> I assume sg_init_one() still can work on an uninitialized sg entry?

Yes, but only if that sg entry is not part of a chained list.

-- 
Jens Axboe

