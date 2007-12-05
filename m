Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbXLEKSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbXLEKSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 05:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbXLEKSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 05:18:07 -0500
Received: from brick.kernel.dk ([87.55.233.238]:23324 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbXLEKSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 05:18:07 -0500
Date: Wed, 5 Dec 2007 11:15:48 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Aaron Carroll <aaronc@gelato.unsw.edu.au>, linux-kernel@vger.kernel.org,
       Peter Chubb <peterc@gelato.unsw.edu.au>
Subject: Re: [PATCH] as-iosched: fix write batch start point
Message-ID: <20071205101548.GB4969@kernel.dk>
References: <4756784B.40607@gelato.unsw.edu.au> <20071205101434.GE1114@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205101434.GE1114@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05 2007, Nick Piggin wrote:
> On Wed, Dec 05, 2007 at 09:07:07PM +1100, Aaron Carroll wrote:
> > New write batches currently start from where the last one completed.
> > We have no idea where the head is after switching batches, so this
> > makes little sense.  Instead, start the next batch from the request
> > with the earliest deadline in the hope that we avoid a deadline
> > expiry later on.
> > 
> > Signed-off-by: Aaron Carroll <aaronc@gelato.unsw.edu.au>
> 
> I think this seems reasonable. What's deadline doing in this case?
> They should probably be kept in synch where possible...

Aaron sent a similar patch for deadline a while ago, so this just
matches them up again. I acked that patch, it makes a lot of sense to
me.

-- 
Jens Axboe

