Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbYBLVhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbYBLVhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYBLVgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:36:54 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43009 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752338AbYBLVgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:36:52 -0500
Date: Tue, 12 Feb 2008 13:36:20 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>, Jeff Garzik <jeff@garzik.org>,
       David Miller <davem@davemloft.net>, arjan@infradead.org,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <20080212212005.GA22309@kroah.com>
Message-ID: <alpine.LFD.1.00.0802121328270.2920@woody.linux-foundation.org>
References: <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <20080212174824.GA1919@kroah.com>
 <alpine.LFD.1.00.0802121011280.2920@woody.linux-foundation.org> <20080212191552.GA20883@kroah.com> <20080212194651.GI27894@ZenIV.linux.org.uk> <20080212205051.GB21650@kroah.com> <20080212210808.GJ27894@ZenIV.linux.org.uk>
 <20080212212005.GA22309@kroah.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, Greg KH wrote:
> 
> Yes, I agree, there are lots of examples of this, but the overall
> majority are reviewed by 2 people at least (or sure as hell should be,
> maybe we need to bring into existance the "reviewed-by" marking to
> ensure this.)

Well, I don't really "review" any patches that come through Andrew. What I 
do is:

 - global search-and-replace Andrew's "acked-by:" with one that is both 
   him and me (that way I make sure that I _only_ sign off on patches that 
   he has signed off on!)

 - look through all the commit *messages* (but not patches). This 
   sometimes involves also editing up grammar etc - some of those messages 
   just make me wince - but it also tends to include things like adding 
   commit one-liner information if only a git commit ID is mentioned etc.

 - and only for areas that I feel competent in, I look at the patches too.

So, to take an example, when Andrew passes on uml patches that only touch 
arch/um and include/asm-um, my sign-off does not mean *any* kind of review 
at all. It's purely a sign that it's passed the sign-off requirements 
properly.

When it comes to VM issues or other things, things are different, and I 
actually review the patch (and occasionally send it back with "nope, I'm 
not applying this"). But for stuff that comes through Andrew, that's 
probably less than a quarter of the patches. And I don't mark the ones 
I've reviewed specially in any way.

And I suspect I'm not at all alone in this. People simply have maintainers 
they trust (and _need_ to trust in order to not become a bottleneck).

			Linus
