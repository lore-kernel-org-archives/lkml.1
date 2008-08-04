Return-Path: <linux-kernel-owner+w=401wt.eu-S1761210AbYHDTGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761210AbYHDTGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 15:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761132AbYHDTFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 15:05:38 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:53461 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761116AbYHDTFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 15:05:33 -0400
Subject: Re: [PATCH] workaround minor lockdep bug triggered by
	mm_take_all_locks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Roland Dreier <rdreier@cisco.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <adazlnssj6h.fsf@cisco.com>
References: <ada63qgvppx.fsf@cisco.com> <1217859571.3589.7.camel@twins>
	 <aday73cua99.fsf@cisco.com> <1217860332.3589.11.camel@twins>
	 <20080804145318.GA17867@redhat.com> <1217861763.3589.13.camel@twins>
	 <20080804162657.GI11476@duo.random> <1217867935.3589.35.camel@twins>
	 <20080804172728.GJ11476@duo.random> <20080804174659.GK11476@duo.random>
	 <20080804175730.GL11476@duo.random> <1217875739.3589.56.camel@twins>
	 <adazlnssj6h.fsf@cisco.com>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 21:05:29 +0200
Message-Id: <1217876729.3589.66.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 11:56 -0700, Roland Dreier wrote:
> > NAK, come-on, you didn't even bother to look at the available
>  > annotations..
> 
> Agree that this trylock-in-a-loop is a horrible hack that should never
> be merged.
> 
> However I wonder what you think the right way to annotate the
> potentially unbounded number of locks taken in mm_take_all_locks() is?

Good question, one which I don't currently have an answer for - see my
other mail why getting rid of the MAX_LOCK_DEPTH limitation is hard.

I'll give it another serious go tomorrow (if nothing else preempts me).

