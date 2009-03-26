Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbZCZOvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbZCZOvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759240AbZCZOt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:49:28 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:51797 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759266AbZCZOt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:49:26 -0400
Date: Thu, 26 Mar 2009 14:47:34 +0000 (GMT)
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
In-Reply-To: <20090326085748.GH27476@kernel.dk>
Message-ID: <Pine.LNX.4.64.0903261430410.32095@blonde.anvils>
References: <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain>
 <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain>
 <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk>
 <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk>
 <49CA8ADA.3040709@redhat.com> <20090325195747.GC27476@kernel.dk>
 <Pine.LNX.4.64.0903252036130.8872@blonde.anvils> <20090326085748.GH27476@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009, Jens Axboe wrote:
> On Wed, Mar 25 2009, Hugh Dickins wrote:
> > 
> > Tangential question, but am I right in thinking that BIO_RW_BARRIER
> > similarly bars across all partitions, whereas its WRITE_BARRIER and
> > DISCARD_BARRIER users would actually prefer it to apply to just one?
> 
> All the barriers refer to just that range which the barrier itself
> references.

Ah, thank you: then I had a fundamental misunderstanding of them,
and need to go away and work that out some more.

Though I didn't read it before asking, doesn't the I/O Barriers section
of Documentation/block/biodoc.txt give a very different impression?

> The problem with the full device flushes is implementation
> on the hardware side, since we can't do small range flushes. So it's not
> as-designed, but rather the best we can do...

Right, that part of it I did get.

Hugh
