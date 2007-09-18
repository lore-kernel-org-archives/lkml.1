Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbXIRJbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbXIRJbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 05:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbXIRJbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 05:31:04 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:62211 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754611AbXIRJbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 05:31:01 -0400
Date: Tue, 18 Sep 2007 11:30:57 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Mike Snitzer" <snitzer@gmail.com>
Cc: "Daniel Phillips" <phillips@phunq.net>,
       "Christoph Lameter" <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dkegel@google.com, "David Miller" <davem@davemloft.net>,
       "Nick Piggin" <npiggin@suse.de>, "Wouter Verhelst" <w@uter.be>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
Message-ID: <20070918113057.6838f54f@twins>
In-Reply-To: <170fa0d20709172027g3b83d606k6a8e641f71848c3@mail.gmail.com>
References: <20070814142103.204771292@sgi.com>
	<200709050916.04477.phillips@phunq.net>
	<170fa0d20709072212m4563ce76sa83092640491e4f3@mail.gmail.com>
	<200709171728.26180.phillips@phunq.net>
	<170fa0d20709172027g3b83d606k6a8e641f71848c3@mail.gmail.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 23:27:25 -0400 "Mike Snitzer" <snitzer@gmail.com>
wrote:

> I'm going to try adding all the things I've learned into the mix all
> at once; including both of peterz's patchsets.  Peter, do you have a
> git repo or website/ftp site for you r latest per-bdi and network
> deadlock patchsets?  Pulling them out of LKML archives isn't "fun".

BDI should be back in -mm, for the other its in shambles atm, I'll tell
you where to find it when I've put it back together.

I should get myself some time to read on how to push relative git
trees, as I did get myself a kernel.org account.
 
> Also, I've noticed that the more recent network deadlock avoidance
> patchsets haven't included NBD changes; any reason why these have been
> dropped?  Should I just look to shoe-horn in previous NBD-oriented
> patches from an earlier version of that patchset?

NBD has some serious block layer issues, I once talked with Jens about
it and he explained what needed to be done to get NBD back in
shape again, but I could not be bothered to spend time on it.
[ and have since forgotten most of the details :-/ ]

For me NBD is dead and broken beyond repair, it needs a wholesale
rewrite.
