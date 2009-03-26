Return-Path: <linux-kernel-owner+w=401wt.eu-S1760913AbZCZTGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760913AbZCZTGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 15:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759685AbZCZTEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 15:04:11 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:53646 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760228AbZCZTEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 15:04:06 -0400
Date: Thu, 26 Mar 2009 19:00:10 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Jens Axboe <jens.axboe@oracle.com>
cc: Ric Wheeler <rwheeler@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <20090326183254.GI27476@kernel.dk>
Message-ID: <Pine.LNX.4.64.0903261855590.18132@blonde.anvils>
References: <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org>
 <20090325194341.GB27476@kernel.dk> <49CA8ADA.3040709@redhat.com>
 <20090325195747.GC27476@kernel.dk> <Pine.LNX.4.64.0903252036130.8872@blonde.anvils>
 <20090326085748.GH27476@kernel.dk> <Pine.LNX.4.64.0903261430410.32095@blonde.anvils>
 <20090326154610.GH27476@kernel.dk> <Pine.LNX.4.64.0903261755010.14358@blonde.anvils>
 <20090326183254.GI27476@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009, Jens Axboe wrote:
> On Thu, Mar 26 2009, Hugh Dickins wrote:
> > 
> > So, directing a barrier (WRITE_BARRIER or DISCARD_BARRIER) to a range
> > of sectors in one partition interposes a barrier into the queue of I/O
> > across (all partitions of) that whole device.
> 
> Correct
> 
> > I think that's not how filesystems really want barriers to behave,
> > and might tend to discourage us from using barriers more freely.
> > But I have zero appreciation of whether it's a significant issue
> > worth non-trivial change - just wanted to get it out into the open.
> 
> Per-partition definitely makes sense. The problem is that we do sorting
> on a per-device basis right now. But it's a good point, I'll try and
> take a look at how much work it would be to make it per-partition
> instead. It wont be trivial :-)

Thanks, that would be interesting.
Trivial bores you anyway, doesn't it?

Hugh
