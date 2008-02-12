Return-Path: <linux-kernel-owner+w=401wt.eu-S1763397AbYBLSiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763397AbYBLSiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843AbYBLSiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:38:06 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40414 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754550AbYBLSiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:38:03 -0500
Date: Tue, 12 Feb 2008 10:36:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benny Halevy <bhalevy@panasas.com>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <47B1DD17.2030204@panasas.com>
Message-ID: <alpine.LFD.1.00.0802121031520.2920@woody.linux-foundation.org>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org>  <20080212044314.GA4888@kroah.com>  <20080211211751.3e265754@laptopd505.fenrus.org>  <20080211.221126.230471463.davem@davemloft.net>  <47B1CB08.4020101@garzik.org> 
 <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <1202838082.3137.54.camel@localhost.localdomain> <47B1DD17.2030204@panasas.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, Benny Halevy wrote:
> 
> IMHO, this base tree should typically be based off of linus' tree
> and kept rebased on top of it.  This way you get the mainline fixes
> through the integration base tree.

Hell no!

No rebasing! If people rebase, then it's useless as a base.

That base tree needs to be something people can *depend* on. It contains 
the API changes, and not anything else. Otherwise I will never ever pull 
the resulting mess, and you all end up with tons of extra work.

Just say *no* to rebasing.

Rebasing is fine for maintaining *your* own patch-set, ie  it is an 
alternative to using quilt. But it is absolutely not acceptable for 
*anythign* else. 

In particular, people who rebase other peoples trees should just be shot 
(*). It's simply not acceptable behaviour. It screws up the sign-off 
procedure, it screws up the people whose code was merged, and it's just 
WRONG.

			Linus

(*) The exception being if there is something seriously wrong with the 
tree. I think I've had trees which I just refused to pull, and while most 
of the time I just say "I refuse to pull", early on in git development I 
actually ended up fixing some of those trees up because my refusal was due 
to people mis-using git in the first place. So I have actually effectively 
rebased a maintainer tree at least once. But I still think it is seriously 
screwed up.
