Return-Path: <linux-kernel-owner+w=401wt.eu-S1759347AbZKZIwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347AbZKZIwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZKZIwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:52:44 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55055 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbZKZIwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:52:44 -0500
Date: Thu, 26 Nov 2009 09:52:49 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/9] tracing: Convert some block events to DEFINE_EVENT
Message-ID: <20091126085249.GQ8742@kernel.dk>
References: <4B0E2807.4060102@cn.fujitsu.com> <4B0E28E6.7060609@cn.fujitsu.com> <20091126083621.GM8742@kernel.dk> <20091126084443.GA1389@elte.hu> <20091126084752.GP8742@kernel.dk> <20091126085052.GB1389@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091126085052.GB1389@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26 2009, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Thu, Nov 26 2009, Ingo Molnar wrote:
> > > 
> > > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > > 
> > > > On Thu, Nov 26 2009, Li Zefan wrote:
> > > > > use TRACE_EVENT_TEMPLATE to remove duplicate code:
> > > > > 
> > > > >    text    data     bss     dec     hex filename
> > > > >   53570    3284     184   57038    dece block/blk-core.o.old
> > > > >   43702    3284     144   47130    b81a block/blk-core.o
> > > > 
> > > > Nice! When I played with the writeback tracing, I did notice that code
> > > > bloat does get pretty severe quickly.
> > > > 
> > > > I have applied this to for-2.6.33, thanks a lot.
> > > 
> > > Note that it wont build in your tree, because the TRACE_EVENT_TEMPLATE / 
> > > DEFINE_EVENT facility this relies on is not upstream yet.
> > > 
> > > The events are not affected in any way (and block/* is not modified) - 
> > > it's just a more efficient representation of the same. I've applied them 
> > > to -tip, to keep the facility and dependent updates in a single place.
> > 
> > OK, lets merge them through -tip then. You can add my acked-by.
> 
> Thanks Jens!
> 
> Do you have any pending (or planned) changes to 
> include/trace/events/block.h in the block tree that might cause 
> problems?
> 
> We can pick those up too (and resolve any conflicts) to reduce the 
> surface of friction.

Nope, I don't have any block tracing bits pending for 2.6.33, so we wont
have merge issues there.

-- 
Jens Axboe

