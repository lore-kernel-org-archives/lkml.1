Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbXFOEXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbXFOEXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 00:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbXFOEXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 00:23:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43517 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751292AbXFOEXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 00:23:42 -0400
Date: Thu, 14 Jun 2007 21:23:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Poole <mdpoole@troilus.org>
cc: Daniel Hazelton <dhazelton@enter.net>, Alexandre Oliva <aoliva@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <874pl928r6.fsf@graviton.dyn.troilus.org>
Message-ID: <alpine.LFD.0.98.0706142118410.14121@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
 <200706142049.41819.dhazelton@enter.net> <87fy4u0xty.fsf@graviton.dyn.troilus.org>
 <200706142246.57583.dhazelton@enter.net> <878xal2a0q.fsf@graviton.dyn.troilus.org>
 <alpine.LFD.0.98.0706142013120.14121@woody.linux-foundation.org>
 <874pl928r6.fsf@graviton.dyn.troilus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Jun 2007, Michael Poole wrote:
> 
> If the signature is one that serves to indicate origin, to detect
> tampering, or the other things you mentioned, the program's binary is
> useful when separated from the signature.  My objection arises when a
> functionally equivalent binary -- including advertised functions such
> as "runs on platform XYZ" -- cannot be produced from the distributed
> source code.

Ahh.

Ok, that's a totally different issue, and is one where I heartily agree 
with you. I would actually *love* for the GPL (any version) to have a 
"guarantee of authenticity", where if you distribute a binary, there has 
to be some documented way to get *exactly* that binary out of the source 
code that got distributed.

Of course, SHA1's can be used to verify that, although, quite frankly, I'd 
expect that a simple "cmp" would be the more straightforward approach.

So the "verification" can be used both to lock down a particular binary 
_and_ to authenticate that the binary really came from the source code it 
was claimed to come from.

Of course, in practice, it's actually really nasty to do that 
verification. Many compilers actually do things like insert date-stamps in 
the object files etc. So it's probably not all that practical.

			Linus
