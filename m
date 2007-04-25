Return-Path: <linux-kernel-owner+w=401wt.eu-S1030852AbXDYKUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030852AbXDYKUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030879AbXDYKUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:20:10 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:49722 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030852AbXDYKUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:20:08 -0400
Date: Wed, 25 Apr 2007 12:18:57 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Brad Campbell <brad@wasp.net.au>
Cc: Neil Brown <neilb@suse.de>, Chuck Ebbert <cebbert@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
Message-ID: <20070425101857.GR9715@kernel.dk>
References: <46261ACE.1050407@wasp.net.au> <20070418132157.GC3720@kernel.dk> <462B10C3.1030906@wasp.net.au> <20070423073543.GE5311@kernel.dk> <462E5D38.5000801@wasp.net.au> <17967.4734.783140.512857@notabene.brown> <20070425084607.GM9715@kernel.dk> <17967.8536.788076.851546@notabene.brown> <20070425094712.GP9715@kernel.dk> <462F2727.7090205@wasp.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462F2727.7090205@wasp.net.au>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25 2007, Brad Campbell wrote:
> Jens Axboe wrote:
> 
> >It looks to be extremely rare. Aliases are extremely rare, front merges
> >are rare. And you need both to happen with the details you outlined. But
> >it's a large user base, and we've had 3-4 reports on this in the past
> >months. So it obviously does happen. I could not make it trigger without
> >doctoring the unplug code when I used aio.
> 
> Well, not that rare on this particular machine (I had a case where I could 
> reproduce it in less than an hour of normal use previously on this box), 
> and I've had it occur a number of times on my servers, I just never 
> reported it before as I never took the time to set up a serial console and 
> capture the oops.

Extremely rare in the sense that it takes md and some certain conditions
to happen for it to trigger. So for most people it'll be extremely rare,
and for others (such as yourself) that hit it, it wont be so rare :-)

> >Here's a fix for it, confirmed.
> 
> Shall I leave the other debugging in, apply this and run it for a few hard 
> days?

Yes, that would be perfect!

-- 
Jens Axboe

