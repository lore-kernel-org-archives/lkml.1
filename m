Return-Path: <linux-kernel-owner+w=401wt.eu-S1760045AbZKZIot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045AbZKZIot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759968AbZKZIos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:44:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48997 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759962AbZKZIor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:44:47 -0500
Date: Thu, 26 Nov 2009 09:44:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/9] tracing: Convert some block events to DEFINE_EVENT
Message-ID: <20091126084443.GA1389@elte.hu>
References: <4B0E2807.4060102@cn.fujitsu.com>
 <4B0E28E6.7060609@cn.fujitsu.com>
 <20091126083621.GM8742@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091126083621.GM8742@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Nov 26 2009, Li Zefan wrote:
> > use TRACE_EVENT_TEMPLATE to remove duplicate code:
> > 
> >    text    data     bss     dec     hex filename
> >   53570    3284     184   57038    dece block/blk-core.o.old
> >   43702    3284     144   47130    b81a block/blk-core.o
> 
> Nice! When I played with the writeback tracing, I did notice that code
> bloat does get pretty severe quickly.
> 
> I have applied this to for-2.6.33, thanks a lot.

Note that it wont build in your tree, because the TRACE_EVENT_TEMPLATE / 
DEFINE_EVENT facility this relies on is not upstream yet.

The events are not affected in any way (and block/* is not modified) - 
it's just a more efficient representation of the same. I've applied them 
to -tip, to keep the facility and dependent updates in a single place.

	Ingo
