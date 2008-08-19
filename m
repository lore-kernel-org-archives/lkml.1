Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbYHSUyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbYHSUyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYHSUyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:54:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557AbYHSUyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:54:09 -0400
Date: Tue, 19 Aug 2008 13:54:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Marcel Holtmann <marcel@holtmann.org>
cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
In-Reply-To: <1219170451.7591.175.camel@violet.holtmann.net>
Message-ID: <alpine.LFD.1.10.0808191348540.3324@nehalem.linux-foundation.org>
References: <20080819.041706.261399060.davem@davemloft.net>  <alpine.LFD.1.10.0808190952000.3324@nehalem.linux-foundation.org> <1219170451.7591.175.camel@violet.holtmann.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Aug 2008, Marcel Holtmann wrote:
> 
> Also I cleaned up the MAINTAINERS file entries for Bluetooth. Are these
> considered harmful now and should be postponed to the next merge window?
> They can obviously not introduce any regressions?

What I consider harmful is not any individual commit per se, but the 
mindset that clearly says "hey, this particular commit is good, let's 
push it up".

And all of the commits are _individually_ fine and the likelihood for 
breakage is probably damn low, but when you have lots of them, that 
doesn't work any more. 

The whole point of the merge window is that you should be sending good, 
tested commits _then_. And if you miss the merge window, then you queue 
them up for the next one.

As it is, it seems like some people think that the merge window is when 
you send any random crap that hasn't even been tested, and then after the 
merge window you send the stuff that looks "obviously good".

How about raising your quality control a bit, so that I don't have to 
berate you? Send the _obviously good_ stuff during the merge window, and 
don't send the "random crap" AT ALL. And then, during the -rc series, you 
don't do any "obviously good" stuff at all, but you do the "absolutely 
required" stuff. 

The rule should be that if you have any doubt _what-so-ever_ that 
something is absolutely required, you simply don't send it during the -rc 
phase. And if you have any doubt at all about something not working, you 
don't send it during the merge window either!

The merge window is not for "let's get this tested, so that we can fix it 
during the -rc". And the stabilization phase is not for "this one looks 
obviously correct and safe".

		Linus
