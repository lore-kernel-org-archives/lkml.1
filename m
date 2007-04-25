Return-Path: <linux-kernel-owner+w=401wt.eu-S2992456AbXDYKhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992456AbXDYKhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992572AbXDYKhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:37:48 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:18765 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992456AbXDYKhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:37:47 -0400
Date: Wed, 25 Apr 2007 12:36:25 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Neil Brown <neilb@suse.de>
Cc: Brad Campbell <brad@wasp.net.au>, Chuck Ebbert <cebbert@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
Message-ID: <20070425103625.GU9715@kernel.dk>
References: <46261ACE.1050407@wasp.net.au> <20070418132157.GC3720@kernel.dk> <462B10C3.1030906@wasp.net.au> <20070423073543.GE5311@kernel.dk> <462E5D38.5000801@wasp.net.au> <17967.4734.783140.512857@notabene.brown> <20070425084607.GM9715@kernel.dk> <17967.8536.788076.851546@notabene.brown> <20070425094712.GP9715@kernel.dk> <17967.11414.227668.186113@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17967.11414.227668.186113@notabene.brown>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25 2007, Neil Brown wrote:
> On Wednesday April 25, jens.axboe@oracle.com wrote:
> > 
> > Here's a fix for it, confirmed.
> > 
> 
> Patch looks good to me.

Good! And thanks for taking the time to look at this bug btw, it's had
me puzzled a bit this week. I should not have ruled out the aliases I
guess, they must be coming elsewhere than from O_DIRECT.

> Hopefully Brad can still wait for the WARN_ON to fire - it might give
> useful clues to why this is happening.  It might be interesting.

But he did and reported it about an hour ago, so all should be well.

-- 
Jens Axboe

