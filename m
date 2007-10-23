Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbXJWU5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbXJWU5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 16:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbXJWU5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 16:57:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52171 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbXJWU5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 16:57:12 -0400
Date: Tue, 23 Oct 2007 22:57:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, Boaz Harrosh <bharrosh@panasas.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH 09/10] Change table chaining layout
Message-ID: <20071023205710.GA32592@one.firstfloor.org>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-10-git-send-email-jens.axboe@oracle.com> <471E2A96.7050304@panasas.com> <20071023183321.GA14671@kernel.dk> <p738x5t4nbn.fsf@bingen.suse.de> <20071023202017.GI14671@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023202017.GI14671@kernel.dk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 10:20:17PM +0200, Jens Axboe wrote:
> On Tue, Oct 23 2007, Andi Kleen wrote:
> > Jens Axboe <jens.axboe@oracle.com> writes:
> > 
> > >> You might want to put a BUG_ON(page & 0x3); Make sure
> > >> you're not loosing information. (The m68k problem)
> > >
> > > That's a really good idea, thanks Boaz! I'll add that.
> > 
> > It would be even better if you replaced all the magic numbers with defines
> > or better accessors.
> 
> All? There are two numbers, and all are confined to scatterlist.h
> privately. Except the one in blk_rq_map_sg(), which was done on purpose
> since I don't want to export that knowledge to others. So we definitely
> don't want accessors, I can name the two bit values but don't see much
> point in doing it.

Maybe no point for you, but it would be helpful for any poor soul
who has to read/debug/change the code later.

Even if they're limited right now that doesn't mean it'll stay
that way anyways.

-Andi
