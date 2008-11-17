Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbYKQT43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbYKQT43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbYKQT4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:56:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823AbYKQT4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:56:19 -0500
Date: Mon, 17 Nov 2008 11:55:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: mingo@elte.hu, dada1@cosmosbay.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       shemminger@vyatta.com
Subject: Re: [Bug #11308] tbench regression on each kernel release from 2.6.22
 -&gt; 2.6.28
In-Reply-To: <20081117.113936.81699150.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.0811171149100.18283@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0811170937540.3468@nehalem.linux-foundation.org> <20081117182320.GA26844@elte.hu> <20081117184951.GA5585@elte.hu> <20081117.113936.81699150.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Nov 2008, David Miller wrote:
> 
> Again, do a non-NMI profile and the top (at least for me)
> looks like this:

Can _you_ please do a NMI profile and see what your real problem is?

I can't imagine that Niagara (or whatever) is so weak that it can't do 
NMI's. 

The fact is, David, that Ingo just posted a profile that was _better_ than 
anything you have ever posted, and it doesn't show what you complain 
about. So he's not seeing it. Asking him to do a _stupid_ profile is just 
that: stupid.

So try to figure out why his (better) profile doesn't match your 
(inferior) one, instead of asking him to do stupid things. It's some 
difference in architectures, likely: maybe the sparc timekeeping is crap, 
maybe it's a cache issue and sparc caches are crap, maybe it's something 
where Niagara (is it niagara) has some oddness that shows up because it 
has that odd four-threads+four-cores or whatever.

			Linus
