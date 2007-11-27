Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbXK0I4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbXK0I4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 03:56:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbXK0Iz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 03:55:59 -0500
Received: from brick.kernel.dk ([87.55.233.238]:1977 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbXK0Iz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 03:55:59 -0500
Date: Tue, 27 Nov 2007 09:54:56 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] mmc: Add missing sg_init_table() call
Message-ID: <20071127085456.GC5029@kernel.dk>
References: <1195759971-19825-1-git-send-email-hskinnemoen@atmel.com> <20071126212955.07f65b0d.akpm@linux-foundation.org> <20071127065703.63fea228@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127065703.63fea228@poseidon.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27 2007, Pierre Ossman wrote:
> On Mon, 26 Nov 2007 21:29:55 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > Pierre, I can queue this up but if you merge it into your tree I shall drop
> > it and shall lose track of it.  So it's then all down to you to remember to
> > get the fix into 2.6.24.
> > 
> > (Except this particular bug looks like a post-2.6.23 regression, so I can cc
> > the Rafael which never forgets, so it will then get tracked all the way into
> > Linus's tree)
> > 
> 
> Jens said he applied it, so I figured the issue was handled. Jens,
> what happened to it?

It's in my for-linus branch, it was applied when I wrote that reply. So
it's going upstream, the pull request has been sent to Linus.

My error here was not updating the for-akpm branch that Andrew pulls, so
he doesn't notice the patch. That is also updated now.

-- 
Jens Axboe

