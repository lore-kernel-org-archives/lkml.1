Return-Path: <linux-kernel-owner+w=401wt.eu-S1764960AbYBMAy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764960AbYBMAy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbYBMAyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:54:19 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59636 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753286AbYBMAyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:54:17 -0500
Date: Tue, 12 Feb 2008 16:53:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: James.Bottomley@HansenPartnership.com, jeff@garzik.org,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <20080212.163623.132476636.davem@davemloft.net>
Message-ID: <alpine.LFD.1.00.0802121650350.2920@woody.linux-foundation.org>
References: <1202840682.3137.83.camel@localhost.localdomain> <alpine.LFD.1.00.0802121037340.2920@woody.linux-foundation.org> <alpine.LFD.1.00.0802121051341.2920@woody.linux-foundation.org> <20080212.163623.132476636.davem@davemloft.net>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, David Miller wrote:

> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Tue, 12 Feb 2008 10:59:00 -0800 (PST)
> 
> > That sure as hell would put the pain on API changes solidly where it
> > belongs.
> 
> If a person does a driver API change and does all the work to sweep
> the entire tree updating all the drivers, doesn't it penalize that
> person a bit much to stick a new driver in front of that work?

If that API change doesn't conflict with the work that hundreds of other 
people do, it's obviously not a problem whichever way it goes.

And if the API change *does* cause conflicts, then yes, the onus of fixing 
those conflicts (again) goes to the person who changed the API. Everybody 
else did everything right.

> People write code on top of infrastructure, both new and old, not the
> other way around.  At least to me, that seems how the merging ought to
> work too.

You think that infrastructure is more important than outlying code. But 
you do that only because you write the infrastructure, not because you 
have any logical reason to think so.

The fact is, that "outlying code" is where we have all the bulk of the 
code, and it's also where we have all those developers who aren't on the 
"inside track". So we should help the outliers, not the core code. 

And very fundamentally, API changes are to be discouraged. If we make them 
harder to do and make people think twice (and occasionally say "not worth 
it"), that sounds like a damn good thing to me.

			Linus
