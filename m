Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbYBMBl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbYBMBl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYBMBls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:41:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42782 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751847AbYBMBlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:41:47 -0500
Date: Tue, 12 Feb 2008 17:41:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: jeff@garzik.org, arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <20080212.172051.58554658.davem@davemloft.net>
Message-ID: <alpine.LFD.1.00.0802121733000.2920@woody.linux-foundation.org>
References: <47B1CB08.4020101@garzik.org> <20080212.155853.193190548.davem@davemloft.net> <alpine.LFD.1.00.0802121610220.2920@woody.linux-foundation.org> <20080212.172051.58554658.davem@davemloft.net>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, David Miller wrote:
> 
> But as soon as I've applied any patches to my tree I've "pushed out".
> So this scheme doesn't work for me.  The first thing I do when I have
> changes to apply is clone a tree locally and on master.kernel.org,
> then I apply that first patch locally and push it out to master.

I actually suggest you literally delay your push-out.

I don't generally delay things by a lot, but I tend to try to at least do 
a compile in between pushing out - and even if I've pulled something in 
between the thing that broke, I'll just "git reset --hard" to a working 
state if something broke, and just re-pull instead of even trying to 
rebase or anything like that.

(IOW, I often find it much easier to just start over and re-do than 
actually doing a rebase).

I don't do it all the time, by any means, but there's really no huge 
reason to push out all the time. And that's doubly true for subsystem 
maintainers. Quite often, the right thing to do is to only push out when 
you are ready to do the "please pull" message.

> What would be really cool is if you could do the rebase thing, push
> that to a remote tree you were already pushing into and others could
> pull from that and all the right things happen.

It would also be really cool if Claudia Schiffer had decided that hiding 
under my desk is a good idea. 

IOW, you really haven't though that through. That is how TLA and darcs 
worked, and it's a total disaster.

Trust me, you don't know how good you have it.

			Linus
