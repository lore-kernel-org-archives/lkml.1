Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab0BYHsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 02:48:00 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58999 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab0BYHr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 02:47:59 -0500
Date: Thu, 25 Feb 2010 08:47:57 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Re: linux-next: manual merge of the block tree with Linus' tree
Message-ID: <20100225074757.GN1025@kernel.dk>
References: <20100225141022.c5b3b7ce.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100225141022.c5b3b7ce.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25 2010, Stephen Rothwell wrote:
> Hi Jens,
> 
> Today's linux-next merge of the block tree got a conflict in
> include/linux/blkdev.h between commit
> 79da0644a8e0838522828f106e4049639eea6baf ("Revert "block: improve
> queue_should_plug() by looking at IO depths"") from Linus' tree and
> commit 488991e28e55b4fbca8067edf0259f69d1a6f92c ("block: Added in
> stricter no merge semantics for block I/O") from the block tree.
> 
> Context changes - I have fixed it up (see below) and can carry the fix
> for a while.  I suspect that you were expecting this. :-)

I was, unfortunately I forgot to resolve the conflict yesterday. Your
fix confuses me a bit - I was expecting the first hunk, but what is the
second hunk doing? Conceptually good though, perhaps there are more
conflicts than I was expecting :-)

I'll update here as well so it disappears next time you pull.

-- 
Jens Axboe

