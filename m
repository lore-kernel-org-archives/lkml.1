Return-Path: <linux-kernel-owner+w=401wt.eu-S1763966AbYDPM7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763966AbYDPM7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 08:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759910AbYDPM7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 08:59:39 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:35704 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759902AbYDPM7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 08:59:39 -0400
Date: Wed, 16 Apr 2008 06:59:21 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Roland Dreier <rdreier@cisco.com>, Ingo Oeser <ioe-lkml@rameria.de>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org
Subject: Killable stat/readdir
Message-ID: <20080416125921.GI9191@parisc-linux.org>
References: <1208242017.7053.4.camel@lappy> <e2e108260804150017u7d0aad8do9b26f7531a3a5226@mail.gmail.com> <1208249088.7124.7.camel@twins> <alpine.LFD.1.00.0804150907080.2879@woody.linux-foundation.org> <4804D779.6070907@firstfloor.org> <alpine.LFD.1.00.0804150952300.2879@woody.linux-foundation.org> <20080415170556.GA16417@elte.hu> <20080415185008.GE9191@parisc-linux.org> <20080416123732.GA32527@elte.hu> <4805F61A.1060306@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4805F61A.1060306@firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 02:50:34PM +0200, Andi Kleen wrote:
> killable stat and readdir would be even more important I would say.
> 
> When sync/fsync takes too long it's typically just a kernel bug
> of some sort (like that long running MM starvation issue that stalls
> writes on some kinds of background activity) that should be really just
> fixed.
> 
> But handling down network servers which hit stat/readdir etc. is
> a real situation not explained by a bug.
> 
> For example a standard situation that hits me regularly is that
> I save something in firefox on a different server and then later
> turn that machine off. Then next time I try to save something
> in firefox it first blocks forever in stat()ing that down directory.

I think that's fixed now.  Can you check with 2.6.25-rc1 or later?
If it's unkillable, can you let me know the wchan for that process?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
