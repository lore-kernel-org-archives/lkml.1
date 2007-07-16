Return-Path: <linux-kernel-owner+w=401wt.eu-S1765736AbXGPXSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765736AbXGPXSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbXGPXRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:17:55 -0400
Received: from waste.org ([66.93.16.53]:38171 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990AbXGPXRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:17:55 -0400
Date: Mon, 16 Jul 2007 18:17:20 -0500
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, olaf.kirch@oracle.com
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070716231720.GD11166@waste.org>
References: <20070716091236.GA10718@elte.hu> <20070716.042640.18306462.davem@davemloft.net> <alpine.LFD.0.999.0707161425361.20061@woody.linux-foundation.org> <20070716.150825.66176632.davem@davemloft.net> <alpine.LFD.0.999.0707161525250.20061@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707161525250.20061@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 03:29:15PM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 16 Jul 2007, David Miller wrote:
> > 
> > Ingo is the only person hitting and reporting this and last time I
> > checked he is competent enough to revert the thing locally in his own
> > trees, right? :-)
> 
> Umm. And your suggestion is what? Wait until -rc1, when non-developers 
> (the kinds of people who are supposed to *not* be competent enough) come 
> along, and report the problem?
> 
> That's explicitly what I do *not* want to happen.
> 
> If we knew something was wrong before the -rc1 release, all the better: we 
> can avoid havign that bug in -rc1, and the people who test it will tell us 
> about the problems we did *not* know about.

Unfortunately the particular patch from Olaf is presumably covering up
another bug that other people (including Olaf) had hit. So reverting
it is going to introduce a different regression.

I think this particular problem has _already_ bounced back and forth
once. But I haven't been keeping count as most of the relevant patches
weren't cc:ed to me.

-- 
Mathematics is the supreme nostalgia of our time.
